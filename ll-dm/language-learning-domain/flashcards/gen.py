from dataclasses import dataclass
from typing import List

@dataclass
class Learner:
    id: str
    name: str
    skills: List['Skill']

@dataclass
class Skill:
    id: str
    name: str
    level: str

@dataclass
class Activity:
    id: str
    name: str
    questions: List['Question']

@dataclass
class Question:
    id: str
    text: str
    difficulty: str

###### 
###### 
###### 
###### 
import json
from typing import List

def generate_flashcards(activities: List[Activity], output_file: str):
    flashcards = []
    for activity in activities:
        for question in activity.questions:
            flashcards.append({
                "question": question.text,
                "answer": f"Answer to {question.text}",  # Replace with actual logic
                "difficulty": question.difficulty,
            })
    with open(output_file, "w") as f:
        json.dump(flashcards, f, indent=2)

###### 
###### 
###### 
###### 
activities = [
    Activity(
        id="1",
        name="Grammar Quiz",
        questions=[
            Question(id="1", text="What is a noun?", difficulty="Easy"),
            Question(id="2", text="What is a verb?", difficulty="Medium"),
        ],
    ),
    Activity(
        id="2",
        name="Math Quiz",
        questions=[
            Question(id="3", text="What is 2 + 2?", difficulty="Easy"),
            Question(id="4", text="What is 3 * 3?", difficulty="Medium"),
        ],
    ),
]

# Generate flashcards JSON file
generate_flashcards(activities, "../data/flashcards.json")
print("Flashcards generated successfully!")
