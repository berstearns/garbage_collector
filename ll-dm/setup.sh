Copy

#!/bin/bash

# Define project name and root directory
PROJECT_NAME="language-learning-domain"
ROOT_DIR="./$PROJECT_NAME"

# Create root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

# Create .github directory and files
mkdir -p .github/workflows .github/ISSUE_TEMPLATE
echo "name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.9'
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
      - name: Run tests
        run: |
          pytest
" > .github/workflows/ci.yml

# Create docs directory and files
mkdir -p docs/domain docs/tutorials docs/api
echo "# Project Documentation
Welcome to the $PROJECT_NAME documentation!
" > docs/index.md

# Create src directory and subdirectories
mkdir -p src/domain/learner src/domain/skill src/domain/activity src/domain/question src/domain/services src/domain/aggregates
mkdir -p src/application/commands src/application/queries src/application/services
mkdir -p src/infrastructure/persistence src/infrastructure/serialization src/infrastructure/external
mkdir -p src/interfaces/api src/interfaces/cli

# Create tests directory and subdirectories
mkdir -p tests/domain tests/application tests/infrastructure tests/interfaces

# Create examples directory and files
mkdir -p examples
echo "# Basic Usage Example
This is an example notebook for basic usage of the $PROJECT_NAME project.
" > examples/basic_usage.ipynb

# Create data directory and sample data file
mkdir -p data
echo "learner_id,skill_id,activity_id,question_id,score
1,1,1,1,0.8
1,1,1,2,0.6
" > data/sample_data.csv

# Create requirements.txt
echo "fastapi
pytest
pandas
dataclasses
" > requirements.txt

# Create pyproject.toml
echo "[build-system]
requires = [\"setuptools>=42\", \"wheel\"]
build-backend = \"setuptools.build_meta\"
" > pyproject.toml

# Create LICENSE (MIT License)
echo "MIT License

Copyright (c) $(date +%Y) Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
" > LICENSE

# Create README.md
echo "# $PROJECT_NAME

Welcome to the $PROJECT_NAME project! This project is designed to model the relationships between learners, skills, activities, and questions using Domain-Driven Design (DDD).

## Getting Started

1. Clone the repository:
   \`\`\`bash
   git clone https://github.com/yourusername/$PROJECT_NAME.git
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   pip install -r requirements.txt
   \`\`\`

3. Run tests:
   \`\`\`bash
   pytest
   \`\`\`

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.
" > README.md

# Create CONTRIBUTING.md
echo "# Contributing to $PROJECT_NAME

Thank you for your interest in contributing to $PROJECT_NAME! Here are some guidelines to help you get started.

## How to Contribute

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes and write tests if applicable.
4. Submit a pull request.

## Code Style

Please follow PEP 8 guidelines for Python code.
" > CONTRIBUTING.md

# Create initial Python files with content
echo "from dataclasses import dataclass
from typing import List

@dataclass
class Learner:
    id: str
    name: str
    skills: List['Skill']
" > src/domain/learner/learner.py

echo "from dataclasses import dataclass

@dataclass
class Skill:
    id: str
    name: str
    level: str
" > src/domain/skill/skill.py

echo "from dataclasses import dataclass

@dataclass
class Activity:
    id: str
    name: str
    questions: List['Question']
" > src/domain/activity/activity.py

echo "from dataclasses import dataclass

@dataclass
class Question:
    id: str
    text: str
    difficulty: str
" > src/domain/question/question.py

# Create a repository interface for decoupled persistence
echo "from abc import ABC, abstractmethod
from typing import List
from src.domain.learner.learner import Learner

class LearnerRepository(ABC):
    @abstractmethod
    def find(self, learner_id: str) -> Learner:
        pass

    @abstractmethod
    def save(self, learner: Learner) -> None:
        pass
" > src/infrastructure/persistence/learner_repository.py

# Print success message
echo "Project setup complete! Your project is ready in the '$ROOT_DIR' directory."
