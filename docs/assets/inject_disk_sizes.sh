#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 3 ]]; then
	echo "Usage: $0 <compose-file> <markdown-file> <variable-name>" >&2
	exit 1
fi

COMPOSE_FILE="$1"
MARKDOWN_FILE="$2"
VARIABLE_NAME="$3"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CALCULATE_SCRIPT="$SCRIPT_DIR/calculate_disk_size.sh"

# The demo-data image is reported on its own and excluded from the requested
# variable's total whenever it is part of the given compose file. Matched by
# repository, so the pinned tag does not need to be tracked here.
DEMO_DATA_IMAGE="ghcr.io/openads-project/openadstack/demo-data"
DEMO_DATA_VARIABLE="DISK_SIZE_DEMODATA"

if [[ ! -f "$COMPOSE_FILE" ]]; then
	echo "Error: compose file not found: $COMPOSE_FILE" >&2
	exit 1
fi

if [[ ! -f "$MARKDOWN_FILE" ]]; then
	echo "Error: markdown file not found: $MARKDOWN_FILE" >&2
	exit 1
fi

extract_bytes() {
	local compose_file="$1"
	local exclude="${2:-}"
	local only="${3:-}"
	env EXCLUDE_IMAGES="$exclude" INCLUDE_ONLY_IMAGES="$only" \
		bash "$CALCULATE_SCRIPT" "$compose_file" \
		| awk -F': ' '/Total size \(bytes\)/ {print $2}'
}

format_size() {
	python3 - "$1" <<'PY'
import sys

size = int(sys.argv[1])
units = ["B", "KiB", "MiB", "GiB", "TiB"]
value = float(size)

for unit in units:
    if value < 1024 or unit == units[-1]:
        if unit == "B":
            print(f"{int(value)} {unit}")
        elif value >= 100:
            print(f"{value:.0f} {unit}")
        elif value >= 10:
            print(f"{value:.1f} {unit}")
        else:
            print(f"{value:.2f} {unit}")
        break
    value /= 1024
PY
}

inject_variable() {
	python3 - "$MARKDOWN_FILE" "$1" "$2" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
variable = sys.argv[2]
value = sys.argv[3]

text = path.read_text()
text = text.replace(f"${variable}", value)
path.write_text(text)
PY
}

# Size of the demo-data image on its own (empty when it is not part of this
# compose file).
demodata_bytes="$(extract_bytes "$COMPOSE_FILE" "" "$DEMO_DATA_IMAGE")"

if [[ -n "$demodata_bytes" ]]; then
	# Exclude the demo-data image from the requested variable's total and report
	# its size separately.
	main_bytes="$(extract_bytes "$COMPOSE_FILE" "$DEMO_DATA_IMAGE" "")"
	inject_variable "$DEMO_DATA_VARIABLE" "$(format_size "$demodata_bytes")"
else
	main_bytes="$(extract_bytes "$COMPOSE_FILE")"
fi

inject_variable "$VARIABLE_NAME" "$(format_size "$main_bytes")"
