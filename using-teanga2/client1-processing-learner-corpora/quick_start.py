from teanga import Corpus, read_json
import json

# how tostart thinking in teanga

# You create a corpus.
## a corpus essentially has a set of documents
## a corpus behave like a dict but
## it has other metadata, and know how to process the corpus
## rather than just getting /setting data

with open("./datasets/CELVA/celva_texts.json") as inpf:
    corpus = read_json(inpf)
    for doc_id, doc in corpus.items():
        print(doc)
        input()

with open("./datasets/CELVA/celva_texts.json") as inpf:
    corpus = Corpus()
    corpus.add_layer_meta("text")
    corpus.add_layer_meta("words", layer_type="span", base="text")
    corpus.add_layer_meta("pos", layer_type="seq", base="words", data="string")
    
    json_dict = json.load(inpf)
    for instance_dict in json_dict.items():
        doc = corpus.add_doc("This is a document.")
        doc["words"] = [(0,4), (5,7), (8,9), (10,18), (18,19)]
        doc["pos"] = ["DT", "VBZ", "DT", "NN", "."]
        doc
        input()
