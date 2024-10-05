#!/bin/bash
# set -e
GITPASS=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
sudo apt-get update; sudo apt-get install jo vim tmux -y
mkdir -p /home/sagemaker-user/training-infrastructure
cd /home/sagemaker-user/training-infrastructure
git clone https://www.github.com/language-learning-modelling/mlm-pipeline.git /home/sagemaker-user/training-infrastructure/mlm-pipeline/
pip install /home/sagemaker-user/training-infrastructure/mlm-pipeline/
git clone https://berstearns:$GITPASS@github.com/berstearns/personal-notes.git /home/sagemaker-user/training-infrastructure/personal-notes/
git clone https://www.github.com/language-learning-modelling/ll-datasets.git /home/sagemaker-user/training-infrastructure/ll-datasets/
cd /home/sagemaker-user/training-infrastructure/ll-datasets/clients/ 
cp /home/sagemaker-user/training-infrastructure/personal-notes/env-ll-datasets /home/sagemaker-user/training-infrastructure/ll-datasets/clients/.env 
sed -i -e 's/3.12/3/g' /home/sagemaker-user/training-infrastructure/ll-datasets/pyproject.toml
pip install python-dotenv
pip install /home/sagemaker-user/training-infrastructure/ll-datasets/ --no-dependencies 
pip install accelerate==0.26
#python3 /home/sagemaker-user/training-infrastructure/ll-datasets/clients/client.py
git clone https://www.github.com/language-learning-modelling/mlml-clients.git /home/sagemaker-user/training-infrastructure/mlml-clients/
cd /home/sagemaker-user/training-infrastructure/mlml-clients/newclient/
ln -s /home/sagemaker-user/training-infrastructure/ll-datasets/clients/outputs/ /home/sagemaker-user/training-infrastructure/mlml-clients/newclient/ 
python3 /home/sagemaker-user/training-infrastructure/mlml-clients/newclient/client.py /home/sagemaker-user/training-infrastructure/mlml-clients/newclient/run_configs/train_bert_on_cleaned_efcamdat_all.json 
