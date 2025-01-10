package main

import (
	"encoding/json"
	"fmt"
	"os"
	tea "github.com/charmbracelet/bubbletea"
)

// Flashcard represents a single flashcard.
type Flashcard struct {
	Question string `json:"question"`
	Answer   string `json:"answer"`
}

// Model represents the application state.
type Model struct {
	Cards    []Flashcard // List of flashcards
	Position int         // Current card position
}

// InitialModel initializes the application with flashcards from a JSON file.
func InitialModel() Model {
	// Read flashcards from JSON file
	file, err := os.ReadFile("data/flashcards.json")
	if err != nil {
		fmt.Printf("Error reading flashcards file: %v\n", err)
		os.Exit(1)
	}

	var cards []Flashcard
	if err := json.Unmarshal(file, &cards); err != nil {
		fmt.Printf("Error parsing flashcards: %v\n", err)
		os.Exit(1)
	}

	return Model{
		Cards:    cards,
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
			m.Cards[m.Position].Question, m.Cards[m.Position].Answer =
				m.Cards[m.Position].Answer, m.Cards[m.Position].Question
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
	return fmt.Sprintf(
		"Flashcard %d/%d\n\n%s\n\n%s\n\n%s",
		m.Position+1,
		len(m.Cards),
		card.Question,
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
