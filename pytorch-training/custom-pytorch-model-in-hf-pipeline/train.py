import sys
sys.path.append('./pytorch-model-pyclasses')
import json
from fnn import BoG_V8473_FNN


with open('./outputs/CELVA/masked_sentences_batch/reduced_json.json') as inpf:
    data = json.load(inpf)

for instance_id, instance_dict in data.items():
    pass
    #print(" ".join([k['token']['token_str'] for k in instance_dict['tokens']]))
