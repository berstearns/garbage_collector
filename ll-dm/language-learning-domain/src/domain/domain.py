from abc import ABC, abstractmethod
from typing import List

# ==============================================
# 0. TargetLanguage and TargetObjective
# ==============================================

class TargetLanguage:
    def __init__(self, id: str, name: str):
        self.id = id
        self.name = name

    def __str__(self):
        return f"TargetLanguage(ID: {self.id}, Name: {self.name})"

class TargetObjective:
    def __init__(self, id: str, name: str):
        self.id = id
        self.name = name

    def __str__(self):
        return f"TargetObjective(ID: {self.id}, Name: {self.name})"

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
    def __init__(self, id: str, name: str, context: Context, target_objective: TargetObjective):
        self.id = id
        self.name = name
        self.context = context
        self.target_objective = target_objective
        self.skills: List["Skill"] = []

    def add_skill(self, skill: "Skill"):
        self.skills.append(skill)

    def __str__(self):
        skill_details = "\n".join([f"- {s}" for s in self.skills])
        return (
            f"Activity(ID: {self.id}, Name: {self.name}, Context: {self.context.id}, "
            f"TargetObjective: {self.target_objective.name})\nSkills:\n{skill_details}"
        )

# ==============================================
# 3. WordPair as a Composition of Two Words
# ==============================================

# Already implemented in the `WordPair` class above.

# ==============================================
# 4. ActivityCollection as a Collection of Activities
# ==============================================

class ActivityCollection:
    def __init__(self, id: str, name: str, target_objective: TargetObjective):
        self.id = id
        self.name = name
        self.target_objective = target_objective
        self.activities: List[Activity] = []

    def add_activity(self, activity: Activity):
        self.activities.append(activity)

    def __str__(self):
        activity_details = "\n".join([f"- {a}" for a in self.activities])
        return (
            f"ActivityCollection(ID: {self.id}, Name: {self.name}, "
            f"TargetObjective: {self.target_objective.name})\nActivities:\n{activity_details}"
        )

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
# 10. Learner Entity
# ==============================================

class Learner:
    def __init__(self, id: str, name: str, target_language: TargetLanguage):
        self.id = id
        self.name = name
        self.target_language = target_language
        self.activities: List[Activity] = []
        self.topics_of_interest: List["TopicOfInterest"] = []

    def add_activity(self, activity: Activity):
        self.activities.append(activity)

    def add_topic_of_interest(self, topic: "TopicOfInterest"):
        self.topics_of_interest.append(topic)

    def __str__(self):
        activity_details = "\n".join([f"- {a}" for a in self.activities])
        topic_details = "\n".join([f"- {t}" for t in self.topics_of_interest])
        return (
            f"Learner(ID: {self.id}, Name: {self.name}, "
            f"TargetLanguage: {self.target_language.name})\n"
            f"Activities:\n{activity_details}\n"
            f"Topics of Interest:\n{topic_details}"
        )

# ==============================================
# 11. TopicOfInterest and TopicContentItem
# ==============================================

class TopicOfInterest:
    def __init__(self, id: str, name: str):
        self.id = id
        self.name = name
        self.content_items: List["TopicContentItem"] = []

    def add_content_item(self, content_item: "TopicContentItem"):
        self.content_items.append(content_item)

    def __str__(self):
        content_details = "\n".join([f"- {c}" for c in self.content_items])
        return f"TopicOfInterest(ID: {self.id}, Name: {self.name})\nContent Items:\n{content_details}"

class TopicContentItem:
    def __init__(self, id: str, title: str, description: str, url: str):
        self.id = id
        self.title = title
        self.description = description
        self.url = url

    def __str__(self):
        return f"TopicContentItem(ID: {self.id}, Title: {self.title}, URL: {self.url})"

# ==============================================
# Main Program to Test the Implementation
# ==============================================

if __name__ == "__main__":
    # Create TargetLanguage and TargetObjective
    target_language = TargetLanguage(id="lang1", name="English")
    target_objective = TargetObjective(id="obj1", name="Improve Vocabulary")

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

    # Create an activity with the context and target objective
    activity = Activity(id="act1", name="Sample Activity", context=context, target_objective=target_objective)

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
    activity_collection = ActivityCollection(id="coll1", name="Sample Collection", target_objective=target_objective)
    activity_collection.add_activity(activity)

    # Create a session and add the activity
    session = Session(id="sess1", name="Sample Session")
    session.add_activity(activity)

    # Create an assessment and add the activity and session
    assessment = Assessment(id="assess1", name="Sample Assessment")
    assessment.add_activity(activity)
    assessment.add_session(session)

    # Create a learner and add the activity
    learner = Learner(id="learner1", name="John Doe", target_language=target_language)
    learner.add_activity(activity)

    # Create a topic of interest and add content items
    topic = TopicOfInterest(id="topic1", name="Technology")
    content_item1 = TopicContentItem(id="content1", title="AI in Education", description="How AI is transforming education", url="https://example.com/ai-education")
    content_item2 = TopicContentItem(id="content2", title="Programming Basics", description="Learn the basics of programming", url="https://example.com/programming-basics")
    topic.add_content_item(content_item1)
    topic.add_content_item(content_item2)

    # Add the topic of interest to the learner
    learner.add_topic_of_interest(topic)

    # Print everything
    print("===== Target Language =====")
    print(target_language)
    print("\n===== Target Objective =====")
    print(target_objective)
    print("\n===== Context =====")
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
    print("\n===== Learner =====")
    print(learner)
    print("\n===== Topic of Interest =====")
    print(topic)

