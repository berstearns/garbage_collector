#!/bin/bash

# Define project name and root directory
PROJECT_NAME="flashcards"
ROOT_DIR="./$PROJECT_NAME"

# Create root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

# Initialize Go module
go mod init flashcards

# Install Bubble Tea
go get github.com/charmbracelet/bubbletea@latest

# Create main.go file
cat <<EOL > main.go
package main

import (
	"fmt"
	"os"

	tea "github.com/charmbracelet/bubbletea"
)

// Flashcard represents a single flashcard with a question and answer.
type Flashcard struct {
	Question string
	Answer   string
	Flipped  bool // Whether the card is flipped to show the answer
}

// Model represents the application state.
type Model struct {
	Cards    []Flashcard // List of flashcards
	Position int         // Current card position
}

// InitialModel initializes the application with a set of flashcards.
func InitialModel() Model {
	return Model{
		Cards: []Flashcard{
			{Question: "What is the capital of France?", Answer: "Paris"},
			{Question: "What is 2 + 2?", Answer: "4"},
			{Question: "What is the largest planet in the solar system?", Answer: "Jupiter"},
		},
		Position: 0,
	}
}

// Init initializes the application.
func (m Model) Init() tea.Cmd {
	return nil
}

// Update handles user input and updates the model.
func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "q", "ctrl+c":
			return m, tea.Quit // Quit the application
		case " ":
			// Flip the current card
			m.Cards[m.Position].Flipped = !m.Cards[m.Position].Flipped
		case "n":
			// Move to the next card
			if m.Position < len(m.Cards)-1 {
				m.Position++
			}
		case "p":
			// Move to the previous card
			if m.Position > 0 {
				m.Position--
			}
		}
	}
	return m, nil
}

// View renders the UI.
func (m Model) View() string {
	card := m.Cards[m.Position]
	content := card.Question
	if card.Flipped {
		content = card.Answer
	}

	return fmt.Sprintf(
		"Flashcard %d/%d\n\n%s\n\n%s\n\n%s",
		m.Position+1,
		len(m.Cards),
		content,
		"Press [space] to flip, [n] for next, [p] for previous, [q] to quit.",
		"",
	)
}

func main() {
	// Initialize the Bubble Tea program
	p := tea.NewProgram(InitialModel())
	if _, err := p.Run(); err != nil {
		fmt.Printf("Error running program: %v\n", err)
		os.Exit(1)
	}
}
EOL

# Create README.md
cat <<EOL > README.md
# $PROJECT_NAME

Welcome to the $PROJECT_NAME project! This is a CLI-based flashcard application built using Go and Bubble Tea.

## Getting Started

1. Clone the repository:
   \`\`\`bash
   git clone https://github.com/yourusername/$PROJECT_NAME.git
   \`\`\`

2. Run the application:
   \`\`\`bash
   go run main.go
   \`\`\`

## Controls
- Press **[space]** to flip the current card.
- Press **[n]** to go to the next card.
- Press **[p]** to go to the previous card.
- Press **[q]** or **[Ctrl+C]** to quit.

## Contributing
Feel free to contribute to this project by opening issues or submitting pull requests.
EOL

# Create .gitignore
cat <<EOL > .gitignore
# Binaries
/bin

# Go workspace file
go.work

# Dependency directories
vendor/

# IDE files
.idea/
.vscode/
*.swp
*.swo
EOL

# Print success message
echo "Project setup complete! Your project is ready in the '$ROOT_DIR' directory."
echo "To run the application, use:"
echo "cd $ROOT_DIR && go run main.go"
