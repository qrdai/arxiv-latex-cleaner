#!/bin/bash

set -euo pipefail

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 <cleaner_config.yaml>" >&2
    exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
    echo "Error: rsync is required for syncing cleaned output back in place." >&2
    exit 1
fi

script_path="$(realpath "$0")"
project_dir="$(dirname "$script_path")"
repo_root="$(dirname "$project_dir")"
source_dir="$project_dir/neurips26-universal-causal-reasoners"
clean_output_dir="${source_dir}_arXiv"
log_dir="$project_dir/.logs"
timestamp="$(date +"%Y%m%d_%H%M%S")"
log_file="$log_dir/$timestamp-cleaner.log"

if [[ ! -f "$1" ]]; then
    echo "Error: config file not found: $1" >&2
    exit 1
fi

config_path="$(realpath "$1")"

if [[ ! -d "$source_dir" ]]; then
    echo "Error: source directory not found: $source_dir" >&2
    exit 1
fi

if ! git -C "$source_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: source directory is not a git working tree: $source_dir" >&2
    exit 1
fi

if [[ -n "$(git -C "$source_dir" status --short)" ]]; then
    echo "Error: source repo has uncommitted changes. Commit or stash them before cleaning." >&2
    git -C "$source_dir" status --short >&2
    exit 1
fi

mkdir -p "$log_dir"
exec > >(tee "$log_file") 2>&1

echo "Running arXiv cleaner for $source_dir"
echo "Using config $config_path"

PYTHONPATH="$repo_root${PYTHONPATH:+:$PYTHONPATH}" python3 -m arxiv_latex_cleaner \
    "$source_dir" \
    --config "$config_path"

if [[ ! -d "$clean_output_dir" ]]; then
    echo "Error: expected cleaner output directory was not created: $clean_output_dir" >&2
    exit 1
fi

echo "Syncing cleaned output back into $source_dir"
rsync -a --delete \
    --exclude='.git/' \
    --exclude='.gitignore' \
    "$clean_output_dir/" \
    "$source_dir/"

rm -rf "$clean_output_dir"

echo "Cleaned source repo updated in place."
echo "Review changes with:"
echo "git -C $source_dir status --short"
