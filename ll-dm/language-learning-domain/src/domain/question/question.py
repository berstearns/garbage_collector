from dataclasses import dataclass

@dataclass
class Question:
    id: str
    text: str
    difficulty: str

