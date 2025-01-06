from dataclasses import dataclass
from typing import List

@dataclass
class Learner:
    id: str
    name: str
    skills: List['Skill']

