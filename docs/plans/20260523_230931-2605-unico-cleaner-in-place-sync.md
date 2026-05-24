# 2605-Unico Cleaner Runner With In-Place Sync

## Summary
- Keep `arxiv_latex_cleaner`'s default behavior of generating `./2605-unico/neurips26-universal-causal-reasoners_arXiv`.
- Extend `./2605-unico/cleaner.sh` so it syncs that cleaned output back into the existing git-tracked source checkout at `./2605-unico/neurips26-universal-causal-reasoners`.
- Preserve the nested repo's `.git/` metadata, remove the temporary `*_arXiv` folder after a successful sync, and leave the user with only `./2605-unico/neurips26-universal-causal-reasoners` to review via `git -C ... diff`.

## Key Changes
- Populate `./2605-unico/cleaner_config.yaml` with `keep_bib`, `verbose`, draft-comment commands to delete, `high` as a wrapper to unwrap, and `qirunblock` as an environment to delete.
- Update `./2605-unico/cleaner.sh` to require one YAML config argument, validate prerequisites, require a clean nested source repo, run the cleaner, sync cleaned output back with `rsync`, and remove the temporary output directory after success.
- Add the `./2605-unico/.logs/` output directory to `./.gitignore`.

## Test Plan
- Run `bash -n ./2605-unico/cleaner.sh`.
- Run `./2605-unico/cleaner.sh ./2605-unico/cleaner_config.yaml`.
- Verify `./2605-unico/neurips26-universal-causal-reasoners_arXiv` is removed after success.
- Verify `git -C ./2605-unico/neurips26-universal-causal-reasoners status --short` shows reviewable cleaned-source changes.
- Spot-check cleaned files for removed `%` comments, removed `comment` environments, deleted draft-comment commands, and unwrapped `\high{...}` text.
- Verify `./2605-unico/neurips26-universal-causal-reasoners/.git/` remains intact and `custom.bib` is still present.

## Assumptions
- The runner should refuse to operate if the nested source repo is already dirty, to avoid mixing existing edits with cleaner-generated changes.
- `.gitignore` should be preserved in the nested repo even though the cleaner omits it from arXiv output.
- Exact in-place mutation is implemented in the shell runner, not by changing the Python cleaner's public CLI.
