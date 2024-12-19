#!/bin/bash
BASEFOLDER=.
RCLONEREMOTE=insight-gdrive
TIMESTAMP=`date +%Y-%m-%d_%H-%M`
rclone copyto --progress $BASEFOLDER/datasets/NLP4CALL_2025_experiment/experiment_data.zip $RCLONEREMOTE:/phd-experimental-data/data/nlp4call2025_article_experiments_$TIMESTAMP.zip
