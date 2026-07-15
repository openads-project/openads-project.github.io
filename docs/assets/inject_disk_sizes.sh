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

if [[ ! -f "$COMPOSE_FILE" ]]; then
	echo "Error: compose file not found: $COMPOSE_FILE" >&2
	exit 1
fi

if [[ ! -f "$MARKDOWN_FILE" ]]; then
	echo "Error: markdown file not found: $MARKDOWN_FILE" >&2
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

disk_size="$(format_size "$(extract_bytes "$COMPOSE_FILE")")"

python3 - "$MARKDOWN_FILE" "$VARIABLE_NAME" "$disk_size" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
variable = sys.argv[2]
value = sys.argv[3]

text = path.read_text()
text = text.replace(f"${variable}", value)
path.write_text(text)
PY
