# Paper-specific arXiv cleaner

This directory builds a cleaned snapshot from a separate authoring checkout into the private submodule at `./2501-bids/emnlp25-bids`. The outer repository records the private submodule endpoint in `.gitmodules`, while machine-specific authoring settings remain local.

## Local setup

Initialize the private checkout using the tracked submodule configuration:

```bash
git submodule update --init ./2501-bids/emnlp25-bids
```

Create the ignored runtime configuration:

```bash
cp ./2501-bids/cleaner.local.example.conf ./2501-bids/cleaner.local.conf
```

Fill in the authoring checkout path and its expected remote endpoint. The runner also reads the expected clean endpoint from `.gitmodules`; both values act as safety invariants so a cleaned snapshot cannot be written back to the authoring repository accidentally.

Install the repository dependencies, ensure both checkouts are clean, and run from the repository root:

```bash
python3 -m pip install -r ./requirements.txt
./2501-bids/cleaner.sh
```

The runner archives the committed authoring tree into a temporary directory, cleans that snapshot, and synchronizes only the derived output into the private checkout. It preserves the private checkout's Git metadata and ignored root PDF, and it never fetches, commits, or pushes automatically.
