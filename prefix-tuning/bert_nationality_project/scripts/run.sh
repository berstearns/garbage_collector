#!/bin/bash

echo "Preparing dataset..."
python bert_nationality_project/data/prepare_data.py

echo "Starting training..."
python bert_nationality_project/train/train.py
