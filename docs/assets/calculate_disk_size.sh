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

if ! command -v python3 >/dev/null 2>&1; then
	echo "Error: python3 is required." >&2
	exit 1
fi

# Collect unique images from compose config, with a file-based fallback for
# compose files that use include plus service overrides.
image_output="$(python3 - "$COMPOSE_FILE" <<'PY'
from pathlib import Path
import os
import re
import subprocess
import sys

compose_file = Path(sys.argv[1]).resolve()

KEY_PATTERN = re.compile(r"^(\s*)([^:#][^:]*):(?:\s*(.*))?$")
LIST_ITEM_PATTERN = re.compile(r"^(\s*)-\s+(.*?)\s*$")


def selected_profiles() -> list[str]:
	return [item.strip() for item in os.environ.get("COMPOSE_PROFILES", "").split(",") if item.strip()]


def active_profiles() -> set[str] | None:
	# None means every profile is active (equivalent to "--profile *"); a set
	# restricts activation to the profiles listed in COMPOSE_PROFILES.
	profiles = set(selected_profiles())
	if not profiles or "*" in profiles:
		return None
	return profiles


def service_is_active(service_info: dict[str, object], profiles: set[str] | None) -> bool:
	service_profiles = service_info.get("profiles")
	if not service_profiles:
		return True  # services without a profile are always enabled
	if profiles is None:
		return True  # all-profiles mode
	return any(profile in profiles for profile in service_profiles)


def strip_comment(text: str) -> str:
	result: list[str] = []
	in_single = False
	in_double = False
	escape = False

	for character in text:
		if character == "\\" and in_double and not escape:
			escape = True
			result.append(character)
			continue

		if character == "'" and not in_double:
			in_single = not in_single
		elif character == '"' and not in_single and not escape:
			in_double = not in_double
		elif character == "#" and not in_single and not in_double:
			break

		escape = False
		result.append(character)

	return "".join(result).rstrip()


def parse_scalar(value: str | None) -> str | None:
	if value is None:
		return None

	parsed = strip_comment(value).strip()
	if not parsed:
		return None

	if len(parsed) >= 2 and parsed[0] == parsed[-1] and parsed[0] in {"'", '"'}:
		return parsed[1:-1]

	return parsed


def parse_inline_list(value: str) -> list[str]:
	parsed = parse_scalar(value)
	if parsed is None:
		return []

	if not (parsed.startswith("[") and parsed.endswith("]")):
		return [parsed]

	items: list[str] = []
	current: list[str] = []
	in_single = False
	in_double = False
	escape = False

	for character in parsed[1:-1]:
		if character == "\\" and in_double and not escape:
			escape = True
			current.append(character)
			continue

		if character == "'" and not in_double:
			in_single = not in_single
		elif character == '"' and not in_single and not escape:
			in_double = not in_double
		elif character == "," and not in_single and not in_double:
			item = parse_scalar("".join(current))
			if item is not None:
				items.append(item)
			current = []
			escape = False
			continue

		escape = False
		current.append(character)

	item = parse_scalar("".join(current))
	if item is not None:
		items.append(item)

	return items


compose_cache: dict[Path, tuple[list[Path], dict[str, dict[str, str | None]]]] = {}


def load_compose_metadata(path: Path) -> tuple[list[Path], dict[str, dict[str, str | None]]]:
	path = path.resolve()
	if path in compose_cache:
		return compose_cache[path]

	if not path.is_file():
		raise SystemExit(f"Error: compose file not found: {path}")

	includes: list[Path] = []
	services: dict[str, dict[str, str | None]] = {}
	section: str | None = None
	current_service: str | None = None
	current_service_indent: int | None = None
	current_extends_indent: int | None = None
	current_profiles_indent: int | None = None

	for raw_line in path.read_text().splitlines():
		line = strip_comment(raw_line)
		if not line.strip():
			continue

		key_match = KEY_PATTERN.match(line)
		list_match = LIST_ITEM_PATTERN.match(line)
		indent = len(line) - len(line.lstrip(" "))

		if indent == 0:
			section = None
			current_service = None
			current_service_indent = None
			current_extends_indent = None
			current_profiles_indent = None

			if key_match is None:
				continue

			key = key_match.group(2).strip()
			value = key_match.group(3)
			if key == "include":
				section = "include"
				if value is not None:
					includes.extend((path.parent / item).resolve() for item in parse_inline_list(value))
			elif key == "services":
				section = "services"
			continue

		if section == "include":
			if list_match is None:
				continue

			item = parse_scalar(list_match.group(2))
			if item is not None:
				includes.append((path.parent / item).resolve())
			continue

		if section != "services":
			continue

		# Collect the items of a "profiles:" block list before the generic
		# key handling below discards non key-value lines.
		if current_profiles_indent is not None and current_service is not None:
			if list_match is not None and indent > current_profiles_indent:
				item = parse_scalar(list_match.group(2))
				if item is not None:
					services[current_service]["profiles"].append(item)
				continue
			if indent <= current_profiles_indent:
				current_profiles_indent = None

		if key_match is None:
			continue

		key = key_match.group(2).strip()
		value = parse_scalar(key_match.group(3))

		if current_service is None or current_service_indent is None or indent <= current_service_indent:
			current_extends_indent = None
			current_profiles_indent = None
			if value is None:
				current_service = key
				current_service_indent = indent
				services.setdefault(
					current_service,
					{"image": None, "extends_file": None, "extends_service": None, "profiles": None},
				)
			else:
				current_service = None
				current_service_indent = None
			continue

		service_info = services[current_service]

		if current_extends_indent is not None and indent <= current_extends_indent:
			current_extends_indent = None

		if key == "image" and value is not None:
			service_info["image"] = value
			continue

		if key == "profiles":
			service_info["profiles"] = parse_inline_list(key_match.group(3)) if value is not None else []
			current_profiles_indent = None if value is not None else indent
			continue

		if key == "extends":
			if value is not None:
				service_info["extends_service"] = value
				service_info["extends_file"] = str(path)
			else:
				current_extends_indent = indent
			continue

		if current_extends_indent is not None and indent > current_extends_indent:
			if key == "file" and value is not None:
				service_info["extends_file"] = value
			elif key == "service" and value is not None:
				service_info["extends_service"] = value

	compose_cache[path] = (includes, services)
	return compose_cache[path]


def resolve_service_images(
	compose_path: Path,
	service_name: str,
	active_stack: set[tuple[Path, str]],
) -> list[str]:
	compose_path = compose_path.resolve()
	stack_key = (compose_path, service_name)
	if stack_key in active_stack:
		chain = " -> ".join(f"{path}:{name}" for path, name in (*active_stack, stack_key))
		raise SystemExit(f"Error: circular compose extends reference detected: {chain}")

	_, services = load_compose_metadata(compose_path)
	service_info = services.get(service_name)
	if service_info is None:
		raise SystemExit(f"Error: service not found in compose file {compose_path}: {service_name}")

	image = service_info.get("image")
	if image is not None:
		return [image]

	extends_service = service_info.get("extends_service")
	if extends_service is None:
		return []

	extends_file_value = service_info.get("extends_file")
	if extends_file_value is None:
		extends_path = compose_path
	else:
		extends_path = Path(extends_file_value)
		if not extends_path.is_absolute():
			extends_path = (compose_path.parent / extends_path).resolve()

	return resolve_service_images(extends_path, extends_service, {*active_stack, stack_key})


def collect_declared_images(compose_path: Path) -> list[str]:
	images: set[str] = set()
	visited_files: set[Path] = set()
	profiles = active_profiles()

	def visit(path: Path) -> None:
		path = path.resolve()
		if path in visited_files:
			return

		visited_files.add(path)
		includes, services = load_compose_metadata(path)

		for include_path in includes:
			visit(include_path)

		for service_name, service_info in services.items():
			if not service_is_active(service_info, profiles):
				continue

			if service_info.get("image") is not None:
				images.add(service_info["image"])
				continue

			for image in resolve_service_images(path, service_name, set()):
				images.add(image)

	visit(compose_path)
	return sorted(images)


def collect_images(compose_path: Path) -> list[str]:
	# Honour COMPOSE_PROFILES so the size matches the images that profile pulls;
	# with no selection, enable every profile ("--profile *") as before.
	selected = selected_profiles()
	if selected:
		profile_args = [argument for profile in selected for argument in ("--profile", profile)]
	else:
		profile_args = ["--profile", "*"]

	result = subprocess.run(
		["docker", "compose", "-f", str(compose_path), *profile_args, "config", "--images"],
		check=False,
		capture_output=True,
		text=True,
	)

	if result.returncode == 0:
		return sorted({line.strip() for line in result.stdout.splitlines() if line.strip()})

	fallback_images = collect_declared_images(compose_path)
	if fallback_images:
		error_output = (result.stderr or result.stdout).strip().splitlines()
		error_summary = error_output[0] if error_output else "unknown docker compose error"
		print(
			f"Falling back to compose file image discovery for {compose_path}: {error_summary}",
			file=sys.stderr,
		)
		return fallback_images

	error_output = (result.stderr or result.stdout).strip() or "unknown docker compose error"
	raise SystemExit(
		f"Error: unable to discover images from compose file {compose_path}: {error_output}"
	)


print("\n".join(collect_images(compose_file)))
PY
)"

IMAGES=()
while IFS= read -r image; do
	if [[ -n "$image" ]]; then
		IMAGES+=("$image")
	fi
done <<< "$image_output"

# Optionally narrow the discovered image set. Callers may set INCLUDE_ONLY_IMAGES
# and/or EXCLUDE_IMAGES to comma- or newline-separated image references; tags and
# digests are ignored when matching, so pinned versions do not need to be tracked
# here.
repository_of() {
	local ref="${1%@*}"        # drop any @sha256:... digest
	local name="${ref##*/}"    # keep an eventual registry:port intact
	if [[ "$name" == *:* ]]; then
		ref="${ref%:*}"        # drop the :tag
	fi
	printf '%s' "$ref"
}

repository_in_list() {
	local target="$1"
	local list="${2//,/$'\n'}"
	local entry
	while IFS= read -r entry; do
		entry="${entry#"${entry%%[![:space:]]*}"}"  # trim leading whitespace
		entry="${entry%"${entry##*[![:space:]]}"}"  # trim trailing whitespace
		[[ -z "$entry" ]] && continue
		if [[ "$(repository_of "$entry")" == "$target" ]]; then
			return 0
		fi
	done <<< "$list"
	return 1
}

if [[ -n "${INCLUDE_ONLY_IMAGES:-}" || -n "${EXCLUDE_IMAGES:-}" ]]; then
	filtered_images=()
	for image in "${IMAGES[@]}"; do
		repository="$(repository_of "$image")"
		if [[ -n "${INCLUDE_ONLY_IMAGES:-}" ]] && ! repository_in_list "$repository" "$INCLUDE_ONLY_IMAGES"; then
			continue
		fi
		if [[ -n "${EXCLUDE_IMAGES:-}" ]] && repository_in_list "$repository" "$EXCLUDE_IMAGES"; then
			continue
		fi
		filtered_images+=("$image")
	done
	IMAGES=("${filtered_images[@]+"${filtered_images[@]}"}")
fi

if [[ ${#IMAGES[@]} -eq 0 ]]; then
	echo "No images found in compose file: $COMPOSE_FILE"
	exit 0
fi

DEFAULT_PLATFORM="${DOCKER_DEFAULT_PLATFORM:-$(docker version --format '{{.Server.Os}}/{{.Server.Arch}}')}"

total_bytes="$(python3 - "$DEFAULT_PLATFORM" "${IMAGES[@]}" <<'PY'
import json
import re
import subprocess
import sys

platform = sys.argv[1]
images = sys.argv[2:]

SIZE_PATTERN = re.compile(r"^\s*(\d+)\s*$")
ARCH_ALIASES = {
	"aarch64": "arm64",
	"arm64": "arm64",
	"armhf": "arm",
	"armv7l": "arm",
	"x86_64": "amd64",
	"amd64": "amd64",
	"i386": "386",
}


def run_capture(*command: str) -> str:
	return subprocess.check_output(command, text=True)


def try_run_capture(*command: str) -> str | None:
	result = subprocess.run(command, check=False, capture_output=True, text=True)
	if result.returncode != 0:
		return None
	return result.stdout


def run_json(*command: str):
	return json.loads(run_capture(*command))


def try_run_json(*command: str):
	output = try_run_capture(*command)
	if output is None:
		return None
	return json.loads(output)


def normalize_arch(arch: str | None) -> str | None:
	if arch is None:
		return None
	return ARCH_ALIASES.get(arch, arch)


def normalize_platform(spec: str) -> tuple[str | None, str | None, str | None]:
	parts = [part for part in spec.split("/") if part]
	if len(parts) < 2:
		return None, normalize_arch(parts[0]) if parts else None, None
	os_name = parts[0]
	arch = normalize_arch(parts[1])
	variant = parts[2] if len(parts) > 2 else None
	return os_name, arch, variant


def parse_history_size(value: str) -> int:
	match = SIZE_PATTERN.match(value.strip())
	if match is None:
		raise SystemExit(f"Error: unexpected docker history size value: {value!r}")
	return int(match.group(1))


def image_exists_locally(image: str) -> bool:
	return subprocess.run(
		["docker", "image", "inspect", image],
		stdout=subprocess.DEVNULL,
		stderr=subprocess.DEVNULL,
		check=False,
	).returncode == 0


def collect_local_layers(local_images: list[str]) -> dict[str, int]:
	unique_layers: dict[str, int] = {}
	if not local_images:
		return unique_layers

	inspect_payload = run_json("docker", "image", "inspect", *local_images)
	inspect_by_reference: dict[str, dict] = {}

	for item in inspect_payload:
		inspect_by_reference[item["Id"]] = item
		for tag in item.get("RepoTags") or []:
			inspect_by_reference[tag] = item
		for digest in item.get("RepoDigests") or []:
			inspect_by_reference[digest] = item

	for image in local_images:
		item = inspect_by_reference.get(image)
		if item is None:
			item = run_json("docker", "image", "inspect", image)[0]

		layers = ((item.get("RootFS") or {}).get("Layers") or [])
		history_output = run_capture(
			"docker",
			"history",
			"--no-trunc",
			"--human=false",
			"--format",
			"{{json .}}",
			image,
		)

		history_sizes = []
		for line in history_output.splitlines():
			if not line.strip():
				continue
			entry = json.loads(line)
			size_bytes = parse_history_size(entry.get("Size", "0"))
			if size_bytes > 0:
				history_sizes.append(size_bytes)

		history_sizes.reverse()

		if len(history_sizes) != len(layers):
			raise SystemExit(
				"Error: unable to map docker history output to local image layers "
				f"for {image} ({len(history_sizes)} sizes for {len(layers)} layers)."
			)

		for layer_digest, size_bytes in zip(layers, history_sizes):
			previous_size = unique_layers.get(layer_digest)
			if previous_size is not None and previous_size != size_bytes:
				raise SystemExit(
					f"Error: conflicting local layer sizes for {layer_digest}: "
					f"{previous_size} vs {size_bytes}."
				)
			unique_layers[layer_digest] = size_bytes

	return unique_layers


def select_manifest_entry(payload, target_platform: tuple[str | None, str | None, str | None]):
	entries = payload if isinstance(payload, list) else [payload]
	if len(entries) == 1:
		return entries[0]

	target_os, target_arch, target_variant = target_platform
	os_arch_match = None

	for entry in entries:
		descriptor = entry.get("Descriptor") or {}
		platform_info = descriptor.get("platform") or {}
		entry_os = platform_info.get("os")
		entry_arch = normalize_arch(platform_info.get("architecture"))
		entry_variant = platform_info.get("variant")

		if entry_os == target_os and entry_arch == target_arch and entry_variant == target_variant:
			return entry

		if os_arch_match is None and entry_os == target_os and entry_arch == target_arch:
			os_arch_match = entry

	return os_arch_match or entries[0]


def collect_manifest_blobs(
	images_to_process: list[str],
	target_platform: tuple[str | None, str | None, str | None],
) -> tuple[dict[str, int], list[str]]:
	unique_blobs: dict[str, int] = {}
	local_fallback_images: list[str] = []

	for image in images_to_process:
		payload = try_run_json("docker", "manifest", "inspect", "--verbose", image)
		if payload is None:
			if image_exists_locally(image):
				print(
					f"Falling back to local image metadata for image without remote manifest: {image}",
					file=sys.stderr,
				)
				local_fallback_images.append(image)
				continue

			raise SystemExit(f"Error: unable to inspect manifest for image: {image}")

		entry = select_manifest_entry(payload, target_platform)
		manifest = entry.get("OCIManifest") or entry.get("SchemaV2Manifest") or entry

		blobs = []
		config = manifest.get("config")
		if isinstance(config, dict):
			blobs.append((config.get("digest") or f"{image}@config", int(config.get("size", 0) or 0)))

		for index, layer in enumerate(manifest.get("layers") or []):
			if not isinstance(layer, dict):
				continue
			digest = layer.get("digest") or f"{image}@layer:{index}"
			blobs.append((digest, int(layer.get("size", 0) or 0)))

		for digest, size_bytes in blobs:
			previous_size = unique_blobs.get(digest)
			if previous_size is not None and previous_size != size_bytes:
				raise SystemExit(
					f"Error: conflicting remote blob sizes for {digest}: "
					f"{previous_size} vs {size_bytes}."
				)
			unique_blobs[digest] = size_bytes

	return unique_blobs, local_fallback_images


target_platform = normalize_platform(platform)

manifest_blobs, local_fallback_images = collect_manifest_blobs(images, target_platform)
local_layers = collect_local_layers(local_fallback_images)

print(sum(manifest_blobs.values()) + sum(local_layers.values()))
PY
)"

echo "Compose file: $COMPOSE_FILE"
echo "Image count: ${#IMAGES[@]}"
echo "Total size (bytes): $total_bytes"

if command -v numfmt >/dev/null 2>&1; then
	echo "Total size (human): $(numfmt --to=iec-i --suffix=B "$total_bytes")"
fi
