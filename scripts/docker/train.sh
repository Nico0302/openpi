#!/bin/bash

# Compute norm stats
uv run scripts/compute_norm_stats.py --config-name $TRAIN_CONFIG

# Train
export XLA_PYTHON_CLIENT_MEM_FRACTION=0.9
uv run scripts/train.py $TRAIN_CONFIG --exp-name=$EXP_NAME --overwrite