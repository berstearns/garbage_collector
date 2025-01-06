from abc import ABC, abstractmethod
from typing import List
from src.domain.learner.learner import Learner

class LearnerRepository(ABC):
    @abstractmethod
    def find(self, learner_id: str) -> Learner:
        pass

    @abstractmethod
    def save(self, learner: Learner) -> None:
        pass

