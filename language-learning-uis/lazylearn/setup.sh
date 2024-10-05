#!/bin/bash

# Create directories
mkdir -p lazylearn/{cmd/lazylearn,internal/{ui,commands,data},pkg/utils,assets/{lessons,translations},scripts}

# Create main.go in cmd/lazylearn
cat <<EOL > lazylearn/cmd/lazylearn/main.go
package main

import (
    "lazylearn/internal/ui"
)

func main() {
    ui.Start()
}
EOL

# Create ui.go in internal/ui
cat <<EOL > lazylearn/internal/ui/ui.go
package ui

import (
    "fmt"
)

func Start() {
    fmt.Println("Welcome to LazyLearn!")
    // Initialize UI components here
}
EOL

# Create commands.go in internal/commands
cat <<EOL > lazylearn/internal/commands/commands.go
package commands

import (
    "fmt"
)

func ExecuteCommand(cmd string) {
    fmt.Println("Executing command:", cmd)
    // Command logic here
}
EOL

# Create data.go in internal/data
cat <<EOL > lazylearn/internal/data/data.go
package data

func GetLessons() []string {
    return []string{"Lesson 1", "Lesson 2", "Lesson 3"}
}
EOL

# Create utils.go in pkg/utils
cat <<EOL > lazylearn/pkg/utils/utils.go
package utils

import "fmt"

func PrintMessage(msg string) {
    fmt.Println(msg)
}
EOL

# Create lesson1.md in assets/lessons
cat <<EOL > lazylearn/assets/lessons/lesson1.md
# Lesson 1: Basics of the Language

In this lesson, we will cover the basic grammar and vocabulary.
EOL

# Create en.json in assets/translations
cat <<EOL > lazylearn/assets/translations/en.json
{
    "welcome": "Welcome to LazyLearn!",
    "exit": "Goodbye!"
}
EOL

# Create setup.sh in scripts
cat <<EOL > lazylearn/scripts/setup.sh
#!/bin/bash

# Setup instructions for the project

echo "Setting up LazyLearn..."
# Any setup commands, like go mod init or dependencies installation, can go here

go mod init lazylearn
go mod tidy
EOL

# Create README.md in the root
cat <<EOL > lazylearn/README.md
# LazyLearn

LazyLearn is a terminal-based language learning tool inspired by Lazygit.

## Features
- Interactive terminal UI
- Lessons and quizzes
- Command-line navigation

## Setup
Run the following command to set up the project:

\`\`\`bash
bash scripts/setup.sh
\`\`\`

## Usage
Start the application with:

\`\`\`bash
go run cmd/lazylearn/main.go
\`\`\`
EOL

# Create go.mod in the root
cat <<EOL > lazylearn/go.mod
module lazylearn

go 1.20
EOL

echo "Project structure created successfully!"

