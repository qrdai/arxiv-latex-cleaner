# 2501-BIDS Cleaner Integration Plan

## Goal
Commit the paper-specific cleaning workflow to the outer repository and the refreshed source to its private nested repository. Follow the established private-submodule layout while keeping machine-specific authoring settings and authoring-repository provenance out of tracked scripts and documentation.

## Planned Changes
- Track the private clean repository through a normal `.gitmodules` entry and gitlink.
- Load the authoring checkout path and expected authoring endpoint from an ignored local configuration file.
- Derive the expected clean endpoint from `.gitmodules` so it is not duplicated in the runner.
- Retain the paper's submission metadata alongside the cleaner configuration.
- Commit the private nested repository first, then record its new gitlink in the outer repository.

## Verification
- Test the cleaner's shell syntax, local configuration validation, exact-remote guards, and committed-snapshot workflow.
- Run the cleaner test suite and verify the refreshed paper PDF remains ignored.
- Confirm tracked scripts and documentation contain no machine-specific authoring path, authoring endpoint, credentials, or authoring commit provenance.
- Inspect both commits before finishing and do not push either repository automatically.
