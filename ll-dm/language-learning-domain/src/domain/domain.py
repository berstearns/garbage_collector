from abc import ABC, abstractmethod
from typing import List

# ==============================================
# 1. Context and its Components
# ==============================================

class IContextComponent(ABC):
    @property
    @abstractmethod
    def id(self) -> str:
        pass

class Sentence(IContextComponent):
    def __init__(self, id: str, text: str):
        self._id = id
        self.text = text

    @property
    def id(self) -> str:
        return self._id

    def __str__(self):
        return f"Sentence(ID: {self.id}, Text: {self.text})"

class Word(IContextComponent):
    def __init__(self, id: str, value: str):
        self._id = id
        self.value = value

    @property
    def id(self) -> str:
        return self._id

    def __str__(self):
        return f"Word(ID: {self.id}, Value: {self.value})"

class WordPair(IContextComponent):
    def __init__(self, id: str, word1: Word, word2: Word):
        self._id = id
        self.word1 = word1
        self.word2 = word2

    @property
    def id(self) -> str:
        return self._id

    def __str__(self):
        return f"WordPair(ID: {self.id}, Words: {self.word1.value} + {self.word2.value})"

class Bigram(IContextComponent):
    def __init__(self, id: str, word1: str, word2: str):
        self._id = id
        self.word1 = word1
        self.word2 = word2

    @property
    def id(self) -> str:
        return self._id

    def __str__(self):
        return f"Bigram(ID: {self.id}, Words: {self.word1} + {self.word2})"

class Image(IContextComponent):
    def __init__(self, id: str, url: str):
        self._id = id
        self.url = url

    @property
    def id(self) -> str:
        return self._id

    def __str__(self):
        return f"Image(ID: {self.id}, URL: {self.url})"

class Context:
    def __init__(self, id: str, description: str):
        self.id = id
        self.description = description
        self.components: List[IContextComponent] = []

    def add_component(self, component: IContextComponent):
        self.components.append(component)

    def __str__(self):
        component_details = "\n".join([f"- {c}" for c in self.components])
        return f"Context(ID: {self.id}, Description: {self.description})\nComponents:\n{component_details}"

# ==============================================
# 2. Activity and its Relationship with Context
# ==============================================

class Activity:
    def __init__(self, id: str, name: str, context: Context):
        self.id = id
        self.name = name
        self.context = context
        self.skills: List["Skill"] = []

    def add_skill(self, skill: "Skill"):
        self.skills.append(skill)

    def __str__(self):
        skill_details = "\n".join([f"- {s}" for s in self.skills])
        return f"Activity(ID: {self.id}, Name: {self.name}, Context: {self.context.id})\nSkills:\n{skill_details}"

# ==============================================
# 3. WordPair as a Composition of Two Words
# ==============================================

# Already implemented in the `WordPair` class above.

# ==============================================
# 4. ActivityCollection as a Collection of Activities
# ==============================================

class ActivityCollection:
    def __init__(self, name: str, criteria: str):
        self.name = name
        self.criteria = criteria
        self.activities: List[Activity] = []

    def add_activity(self, activity: Activity):
        self.activities.append(activity)

    def __str__(self):
        activity_details = "\n".join([f"- {a}" for a in self.activities])
        return f"ActivityCollection(Name: {self.name}, Criteria: {self.criteria})\nActivities:\n{activity_details}"

# ==============================================
# 5. Skill and its Relationship with Words/WordPairs
# ==============================================

class Skill:
    def __init__(self, id: str, description: str, is_correct: bool):
        self.id = id
        self.description = description
        self.is_correct = is_correct
        self.words: List[Word] = []
        self.word_pairs: List[WordPair] = []
        self.positive_examples: List["PositiveExample"] = []
        self.negative_examples: List["NegativeExample"] = []

    def add_word(self, word: Word):
        self.words.append(word)

    def add_word_pair(self, word_pair: WordPair):
        self.word_pairs.append(word_pair)

    def add_positive_example(self, example: "PositiveExample"):
        self.positive_examples.append(example)

    def add_negative_example(self, example: "NegativeExample"):
        self.negative_examples.append(example)

    def __str__(self):
        word_details = "\n".join([f"- {w}" for w in self.words])
        word_pair_details = "\n".join([f"- {wp}" for wp in self.word_pairs])
        positive_example_details = "\n".join([f"- {pe}" for pe in self.positive_examples])
        negative_example_details = "\n".join([f"- {ne}" for ne in self.negative_examples])
        return (
            f"Skill(ID: {self.id}, Description: {self.description}, Is Correct: {self.is_correct})\n"
            f"Words:\n{word_details}\n"
            f"Word Pairs:\n{word_pair_details}\n"
            f"Positive Examples:\n{positive_example_details}\n"
            f"Negative Examples:\n{negative_example_details}"
        )

class PositiveExample:
    def __init__(self, id: str, example_text: str):
        self.id = id
        self.example_text = example_text

    def __str__(self):
        return f"PositiveExample(ID: {self.id}, Text: {self.example_text})"

class NegativeExample:
    def __init__(self, id: str, example_text: str):
        self.id = id
        self.example_text = example_text

    def __str__(self):
        return f"NegativeExample(ID: {self.id}, Text: {self.example_text})"

# ==============================================
# 7. Session as a Collection of Activities
# ==============================================

class Session:
    def __init__(self, id: str, name: str):
        self.id = id
        self.name = name
        self.activities: List[Activity] = []

    def add_activity(self, activity: Activity):
        self.activities.append(activity)

    def __str__(self):
        activity_details = "\n".join([f"- {a}" for a in self.activities])
        return f"Session(ID: {self.id}, Name: {self.name})\nActivities:\n{activity_details}"

# ==============================================
# 9. Assessment as a Collection of Activities and Sessions
# ==============================================

class Assessment:
    def __init__(self, id: str, name: str):
        self.id = id
        self.name = name
        self.activities: List[Activity] = []
        self.sessions: List[Session] = []

    def add_activity(self, activity: Activity):
        self.activities.append(activity)

    def add_session(self, session: Session):
        self.sessions.append(session)

    def __str__(self):
        activity_details = "\n".join([f"- {a}" for a in self.activities])
        session_details = "\n".join([f"- {s}" for s in self.sessions])
        return (
            f"Assessment(ID: {self.id}, Name: {self.name})\n"
            f"Activities:\n{activity_details}\n"
            f"Sessions:\n{session_details}"
        )

# ==============================================
# Main Program to Test the Implementation
# ==============================================

if __name__ == "__main__":
    # Create components
    word1 = Word(id="word1", value="hello")
    word2 = Word(id="word2", value="world")
    word_pair = WordPair(id="wp1", word1=word1, word2=word2)
    bigram = Bigram(id="bg1", word1="hello", word2="world")
    sentence = Sentence(id="sent1", text="This is a sentence.")
    image = Image(id="img1", url="https://example.com/image.png")

    # Create a context and add components
    context = Context(id="ctx1", description="A sample context")
    context.add_component(word1)
    context.add_component(word2)
    context.add_component(word_pair)
    context.add_component(bigram)
    context.add_component(sentence)
    context.add_component(image)

    # Create an activity with the context
    activity = Activity(id="act1", name="Sample Activity", context=context)

    # Create a skill
    skill = Skill(id="skill1", description="Using 'hello' and 'world' correctly", is_correct=True)
    skill.add_word(word1)
    skill.add_word(word2)
    skill.add_word_pair(word_pair)

    # Add positive and negative examples
    positive_example = PositiveExample(id="pe1", example_text="Hello world!")
    negative_example = NegativeExample(id="ne1", example_text="World hello!")
    skill.add_positive_example(positive_example)
    skill.add_negative_example(negative_example)

    # Add the skill to the activity
    activity.add_skill(skill)

    # Create an activity collection and add the activity
    activity_collection = ActivityCollection(name="Sample Collection", criteria="All activities")
    activity_collection.add_activity(activity)

    # Create a session and add the activity
    session = Session(id="sess1", name="Sample Session")
    session.add_activity(activity)

    # Create an assessment and add the activity and session
    assessment = Assessment(id="assess1", name="Sample Assessment")
    assessment.add_activity(activity)
    assessment.add_session(session)

    # Print everything
    print("===== Context =====")
    print(context)
    print("\n===== Activity =====")
    print(activity)
    print("\n===== Activity Collection =====")
    print(activity_collection)
    print("\n===== Skill =====")
    print(skill)
    print("\n===== Session =====")
    print(session)
    print("\n===== Assessment =====")
    print(assessment)
