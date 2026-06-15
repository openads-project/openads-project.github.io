#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 3 ]]; then
	echo "Usage: $0 <start-page> <openadstack-compose> <openadsim-size-or-compose>" >&2
	exit 1
fi

START_PAGE="$1"
OPENADSTACK_COMPOSE_FILE="$2"
OPENADSIM_SOURCE="$3"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CALCULATE_SCRIPT="$SCRIPT_DIR/calculate_disk_size.sh"

if [[ ! -f "$START_PAGE" ]]; then
	echo "Error: start page not found: $START_PAGE" >&2
	exit 1
fi

if [[ ! -f "$OPENADSTACK_COMPOSE_FILE" ]]; then
	echo "Error: OpenADStack compose file not found: $OPENADSTACK_COMPOSE_FILE" >&2
	exit 1
fi

extract_bytes() {
	bash "$CALCULATE_SCRIPT" "$1" | awk -F': ' '/Total size \(bytes\)/ {print $2}'
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

resolve_size() {
	local source="$1"

	if [[ -f "$source" ]]; then
		format_size "$(extract_bytes "$source")"
		return
	fi

	if [[ "$source" == *.yml || "$source" == *.yaml ]]; then
		echo "Error: compose file not found: $source" >&2
		return 1
	fi

	printf '%s\n' "$source"
}

openadstack_size="$(format_size "$(extract_bytes "$OPENADSTACK_COMPOSE_FILE")")"
openadsim_size="10 GB"  # "$(resolve_size "$OPENADSIM_SOURCE")"  # TODO: uncomment once openadsim is available

python3 - "$START_PAGE" "$openadstack_size" "$openadsim_size" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()
text = text.replace("$DISK_SIZE_OPENADSTACK", sys.argv[2])
text = text.replace("$DISK_SIZE_OPENADSIM", sys.argv[3])
path.write_text(text)
PY
