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

class InMemoryUserRepository:
    def __init__(self, app):
        self.app = app

    def get(self, user_id):
        return self.app.domain["users"].get(user_id, None)

    def add(self, data):
        user = User(**data)  
        self.app.domain["users"][user.id] = user 
