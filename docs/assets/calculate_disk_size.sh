#!/usr/bin/env bash

set -euo pipefail

COMPOSE_FILE="${1:-docker-compose.yml}"

if ! command -v docker >/dev/null 2>&1; then
	echo "Error: docker is not installed or not in PATH." >&2
	exit 1
fi

if [[ ! -f "$COMPOSE_FILE" ]]; then
	echo "Error: compose file not found: $COMPOSE_FILE" >&2
	exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
	echo "Error: docker compose (v2) is required." >&2
	exit 1
fi

get_remote_image_size_bytes() {
	local image="$1"

	if ! command -v python3 >/dev/null 2>&1; then
		echo "Error: python3 is required to parse docker manifest output for remote images." >&2
		return 1
	fi

	docker manifest inspect --verbose "$image" | python3 -c '
import json
import sys

def manifest_size(entry):
	if not isinstance(entry, dict):
		return 0

	manifest = entry.get("OCIManifest") or entry.get("SchemaV2Manifest") or entry
	total = 0

	config = manifest.get("config")
	if isinstance(config, dict):
		total += int(config.get("size", 0) or 0)

	for layer in manifest.get("layers", []) or []:
		if isinstance(layer, dict):
			total += int(layer.get("size", 0) or 0)

	return total

payload = json.load(sys.stdin)
if isinstance(payload, list):
	print(sum(manifest_size(entry) for entry in payload))
else:
	print(manifest_size(payload))
'
}

# Collect unique images from compose config
mapfile -t IMAGES < <(docker compose -f "$COMPOSE_FILE" --profile "*" config --images | awk 'NF' | sort -u)

if [[ ${#IMAGES[@]} -eq 0 ]]; then
	echo "No images found in compose file: $COMPOSE_FILE"
	exit 0
fi

total_bytes=0

for image in "${IMAGES[@]}"; do
	if docker image inspect "$image" >/dev/null 2>&1; then
		size_bytes="$(docker image inspect "$image" --format '{{.Size}}')"
	else
		echo "Inspecting remote manifest for missing image: $image" >&2
		size_bytes="$(get_remote_image_size_bytes "$image")"
	fi

	size_bytes="${size_bytes:-0}"
	total_bytes=$((total_bytes + size_bytes))
done

echo "Compose file: $COMPOSE_FILE"
echo "Image count: ${#IMAGES[@]}"
echo "Total size (bytes): $total_bytes"

if command -v numfmt >/dev/null 2>&1; then
	echo "Total size (human): $(numfmt --to=iec-i --suffix=B "$total_bytes")"
fi
