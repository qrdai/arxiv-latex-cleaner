# 2501-BIDS Cleaner Integration

## Overview
Added a paper-specific cleaner whose source is maintained in a private nested repository. The workflow follows the existing private-submodule pattern while separating the editable authoring checkout from the derived clean checkout.

## Changed Files And Rationale
- `./.gitmodules`: records the private clean repository so authorized users can initialize and navigate the submodule normally.
- `./.gitignore`: excludes the machine-specific local cleaner configuration.
- `./2501-bids/cleaner.local.example.conf`: documents the required authoring settings using placeholder values.
- `./2501-bids/cleaner.sh`: reads authoring settings locally, obtains the clean endpoint from `.gitmodules`, validates both remotes, and performs one-way snapshot cleanup.
- `./2501-bids/cleaner_config.yaml`: records the paper-specific command cleanup policy.
- `./2501-bids/submission_metadata.md`: records the submission title, authors, affiliations, author note, and abstract.
- `./2501-bids/README.md`: documents setup and usage.
- `./AGENTS.md`: records the authoritative-source and derived-clean-checkout boundary.

## Usage
Initialize the private submodule, create the ignored local configuration from its example, fill in the authoring settings, and run:

```bash
git submodule update --init ./2501-bids/emnlp25-bids
cp ./2501-bids/cleaner.local.example.conf ./2501-bids/cleaner.local.conf
./2501-bids/cleaner.sh
```

The cleaner does not fetch, commit, or push automatically.

## Required Environment
- The runner requires `git`, `mktemp`, `python3`, `rsync`, `tar`, and the Python packages in `./requirements.txt`.
- Repository authentication remains the responsibility of normal Git credential helpers.
- No credentials are stored in tracked files or passed through the cleaner.

## Artifact Layout
- Cleaner runner, configuration, and submission metadata: `./2501-bids/`.
- Private cleaned source checkout: `./2501-bids/emnlp25-bids`.
- Ignored local authoring configuration: `./2501-bids/cleaner.local.conf`.
- Ignored runner logs: `./2501-bids/.logs/`.
- Ignored compiled PDF: inside the private cleaned checkout.

## Verification
- All 100 repository unit tests passed.
- `bash -n` and `shellcheck` passed for `./2501-bids/cleaner.sh`.
- A full runner invocation validated both exact-remote checks, the committed-tree archive, cleanup transformation, and synchronization path; the clean checkout was already up to date.
- The private checkout contains the intended ignore-policy and source refresh commit, with its compiled PDF remaining ignored.
- The tracked runner and documentation were scanned for machine-specific authoring settings, credentials, and authoring commit provenance.

## Notes And Limitations
- The submodule repository remains private; users without access cannot initialize or browse its contents.
- The local authoring configuration is ignored and is not backed up by the outer repository.
- Neither repository was pushed as part of this update.
