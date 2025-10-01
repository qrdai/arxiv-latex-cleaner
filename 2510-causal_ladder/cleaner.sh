#!/bin/bash

basedir="./arxiv-latex-cleaner/2510-causal_ladder"

# TODO: add a timestamp to the log file name
timestamp=$(date +"%Y%m%d_%H%M%S")
log_file="$basedir/$timestamp-cleaner.log"

arxiv_latex_cleaner \
    ./latex-source/Counterfactual_Reasoning_ICLR_2026_FINAL \
    --keep_bib \
    --verbose \
    --config "$basedir/cleaner_config.yaml" 2>&1 | tee "$log_file"