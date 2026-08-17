# Repository Agent Instructions

## Scope Priority
- These instructions apply to the entire repository.
- Deeper `AGENTS.md` or `CLAUDE.md` files override these instructions for their subtrees.

## Path & Filesystem Conventions
- Treat `./2501-bids/emnlp25-bids` and `./2605-unico/neurips26-universal-causal-reasoners` as private Git submodule checkouts.
- Do not copy private submodule source files into the outer repository; the outer repository should track only the submodule gitlink and `.gitmodules` metadata.
- Keep the machine-specific authoring path and its expected remote endpoint only in the ignored `./2501-bids/cleaner.local.conf`. Track the private clean repository endpoint normally in `.gitmodules`, consistent with the other private paper submodule.
- Treat the configured external checkout as authoritative and read-only during cleanup. Treat `./2501-bids/emnlp25-bids` as a derived, cleaned checkout, and never push or merge the authoring repository's commits, branches, tags, or history into it.
- Refresh the BIDS clean checkout only through `./2501-bids/cleaner.sh`, which builds from a fresh archive of the committed authoring checkout and leaves publication as an explicit review, commit, and push step.
- Keep the BIDS `.gitignore` synchronized from the authoring checkout into the clean checkout. Ignore root-level compiled PDFs and LaTeX intermediates while retaining nested source-figure PDFs, and preserve the local ignored `./2501-bids/emnlp25-bids/acl_latex.pdf` across cleaner refreshes.
