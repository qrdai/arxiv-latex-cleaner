#!/bin/bash

set -euo pipefail

if [[ "$#" -ne 0 ]]; then
    echo "Usage: $0" >&2
    exit 1
fi

script_path="$(realpath "$0")"
project_dir="$(dirname "$script_path")"
repo_root="$(dirname "$project_dir")"
submodule_name="2501-bids/emnlp25-bids"
clean_repo_dir="$project_dir/emnlp25-bids"
config_path="$project_dir/cleaner_config.yaml"
local_config_path="$project_dir/cleaner.local.conf"
log_dir="$project_dir/.logs"
timestamp="$(date +"%Y%m%d_%H%M%S")"
log_file="$log_dir/$timestamp-cleaner.log"
work_dir=""

cleanup_work_dir() {
    if [[ -z "$work_dir" ]]; then
        return
    fi

    if [[ "$work_dir" != /tmp/2501-bids-clean.* ]]; then
        echo "Error: refusing to remove unexpected work directory: $work_dir" >&2
        return 1
    fi

    rm -rf -- "$work_dir"
}

require_clean_git_checkout() {
    local checkout_name="$1"
    local checkout_dir="$2"

    if [[ ! -d "$checkout_dir" ]]; then
        echo "Error: $checkout_name directory not found: $checkout_dir" >&2
        exit 1
    fi

    if ! git -C "$checkout_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Error: $checkout_name is not a git working tree: $checkout_dir" >&2
        exit 1
    fi

    if [[ -n "$(git -C "$checkout_dir" status --short)" ]]; then
        echo "Error: $checkout_name has uncommitted changes: $checkout_dir" >&2
        git -C "$checkout_dir" status --short >&2
        exit 1
    fi
}

require_origin_url() {
    local checkout_name="$1"
    local checkout_dir="$2"
    local expected_origin="$3"
    local actual_origin

    actual_origin="$(git -C "$checkout_dir" remote get-url origin)"
    if [[ "$actual_origin" != "$expected_origin" ]]; then
        echo "Error: unexpected $checkout_name origin." >&2
        echo "Expected: $expected_origin" >&2
        echo "Actual:   $actual_origin" >&2
        exit 1
    fi
}

trap cleanup_work_dir EXIT

for required_command in git mktemp python3 rsync tar; do
    if ! command -v "$required_command" >/dev/null 2>&1; then
        echo "Error: required command not found: $required_command" >&2
        exit 1
    fi
done

if [[ ! -f "$config_path" ]]; then
    echo "Error: config file not found: $config_path" >&2
    exit 1
fi

if [[ ! -f "$local_config_path" ]]; then
    echo "Error: local config file not found: $local_config_path" >&2
    echo "Copy $project_dir/cleaner.local.example.conf and fill in the private values." >&2
    exit 1
fi

# This ignored file contains trusted, machine-specific paths and remote endpoints.
# shellcheck source=/dev/null
source "$local_config_path"

for required_setting in AUTHORING_SOURCE_DIR EXPECTED_AUTHORING_ORIGIN; do
    if [[ -z "${!required_setting:-}" ]]; then
        echo "Error: missing required setting in $local_config_path: $required_setting" >&2
        exit 1
    fi
done

authoring_source_dir="$AUTHORING_SOURCE_DIR"
expected_authoring_origin="$EXPECTED_AUTHORING_ORIGIN"
expected_clean_origin="$(git -C "$repo_root" config --file .gitmodules \
    --get "submodule.$submodule_name.url" || true)"
if [[ -z "$expected_clean_origin" ]]; then
    echo "Error: missing submodule URL in $repo_root/.gitmodules: $submodule_name" >&2
    exit 1
fi

if ! PYTHONPATH="$repo_root${PYTHONPATH:+:$PYTHONPATH}" python3 -c \
    'import PIL, regex, yaml' >/dev/null 2>&1; then
    echo "Error: Python dependencies are missing. Run:" >&2
    echo "python3 -m pip install -r $repo_root/requirements.txt" >&2
    exit 1
fi

require_clean_git_checkout "authoring checkout" "$authoring_source_dir"
require_clean_git_checkout "clean checkout" "$clean_repo_dir"
require_origin_url "authoring checkout" "$authoring_source_dir" "$expected_authoring_origin"
require_origin_url "clean checkout" "$clean_repo_dir" "$expected_clean_origin"

mkdir -p "$log_dir"
exec > >(tee "$log_file") 2>&1

source_revision="$(git -C "$authoring_source_dir" rev-parse HEAD)"
work_dir="$(mktemp -d /tmp/2501-bids-clean.XXXXXXXX)"
raw_snapshot_dir="$work_dir/source"
clean_output_dir="${raw_snapshot_dir}_arXiv"
mkdir -p "$raw_snapshot_dir"

echo "Building clean paper snapshot from authoring commit $source_revision"
echo "Using config $config_path"

git -C "$authoring_source_dir" archive --format=tar HEAD | \
    tar -xf - -C "$raw_snapshot_dir"

if [[ ! -f "$raw_snapshot_dir/.gitignore" ]]; then
    echo "Error: committed authoring snapshot does not contain .gitignore." >&2
    exit 1
fi

PYTHONPATH="$repo_root${PYTHONPATH:+:$PYTHONPATH}" python3 -m arxiv_latex_cleaner \
    "$raw_snapshot_dir" \
    --keep_bib \
    --verbose \
    --config "$config_path"

if [[ ! -d "$clean_output_dir" ]]; then
    echo "Error: expected cleaner output directory was not created: $clean_output_dir" >&2
    exit 1
fi

echo "Syncing cleaned output into $clean_repo_dir"
rsync -a --delete \
    --exclude='.git' \
    --exclude='.gitignore' \
    --exclude='/acl_latex.pdf' \
    "$clean_output_dir/" \
    "$clean_repo_dir/"
cp "$raw_snapshot_dir/.gitignore" "$clean_repo_dir/.gitignore"

if [[ -z "$(git -C "$clean_repo_dir" status --short)" ]]; then
    echo "Clean checkout already matches authoring commit $source_revision."
    exit 0
fi

echo "Clean checkout updated from authoring commit $source_revision."
git -C "$clean_repo_dir" status --short
echo "Review changes before committing and pushing the clean checkout:"
echo "git -C $clean_repo_dir diff"
