import os
import json
from dataclasses import dataclass

@dataclass
class Config:
    annotated_authors_fp: str = None
    list_of_authors_fp: str = None
    input_candidates_fp: str = None

    def __init__(self, **kwargs):
        for k, v in kwargs.items():
            setattr(self, k, v) 

    def __post_init__(self):
        print(dir(self))
        exit()

def save_annotated_dict(config,
                         AA_dict):
    with open(config.annotated_authors_fp,"w") as outf:
        json_str = json.dumps(AA_dict,
                              indent=4)
        outf.write(json_str)

def setup_initial_dict(config):
    with open(config.list_of_authors_fp) as inpf:
        list_of_authors_names = [author_name.lower()
                                 for author_name in
                                 inpf.read().split("\n")[:-1]]


    if not os.path.exists(config.annotated_authors_fp): 
        with open(config.annotated_authors_fp,"w") as inpf:
           inpf.write("{}") 

    with open(config.annotated_authors_fp) as inpf:
        try:
            AA_dict = json.load(inpf)
        except:
            AA_dict = {
                    "unannotated":{},
                    "annotated":{}
                    }

    AA_dict = {
            "unannotated":{k.lower():v for k, v in AA_dict["unannotated"].items()},
            "annotated":{k.lower():v for k, v in AA_dict["annotated"].items()}
            }
    for author_name in list_of_authors_names:
        if all([not AA_dict["annotated"].get(author_name,False),
                not AA_dict["unannotated"].get(author_name,False)]):
                AA_dict["unannotated"][author_name] = {
                        "name": author_name
                        }

    return AA_dict

def input_annotated_candidates(config, AA_dict):
    with open(config.input_candidates_fp) as inpf:
        input_dict = json.load(inpf)
    AA_dict["annotated"].update(input_dict)


def print_missing_authors(AA_dict):
    missing_authors = []
    for author_name_lower in AA_dict["unannotated"].keys():
        if not AA_dict["annotated"].get(author_name_lower,False):
            missing_authors.append(author_name_lower)
    print("do it for :")
    for a in missing_authors[:5]:
        print(a)

if __name__ == "__main__":
    config = {
            "annotated_authors_fp": "annotated_authors.json",
            "list_of_authors_fp": "list_of_authors.txt",
            "input_candidates_fp": "alfred_adlet.json" 
            #"jean_piaget_erik_erikson_abraham_maslow_alberta_bandura_john_bowlby_lev.json" 
            #"ex1.json"
    }

    config = Config(**config)
    AA_dict = setup_initial_dict(config)
    input_annotated_candidates(config, AA_dict)
    save_annotated_dict(config, AA_dict)
    print_missing_authors(AA_dict)
