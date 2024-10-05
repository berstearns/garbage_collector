import sys
import os
from pathlib import Path
filepath =\
        Path(os.path.abspath(__file__))
infrastucture_dir=\
        filepath.parent
root_package_dir=\
        infrastucture_dir.parent
sys.path.append(root_package_dir.as_posix())
from domain import User

def load_database():
    return {
            "users": {
                1: User(id=1,
                        name="bernardo",
                        email="berstearns@gmail.com")
                }
    }
