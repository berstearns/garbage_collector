from dataclasses import dataclass

@dataclass
class Activity:
    id: str
    name: str
    questions: List['Question']

