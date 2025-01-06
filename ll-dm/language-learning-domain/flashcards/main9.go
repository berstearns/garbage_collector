package main

import (
	"encoding/json"
	"fmt"
	"os"
	"time"

	"github.com/charmbracelet/bubbles/key"
	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
)

// Flashcard represents a single flashcard.
type Flashcard struct {
	Question string   `json:"question"`
	Answer   string   `json:"answer"`
	Answers  []string `json:"answers"` // Array of user answers
}

// SessionState represents the state of a flashcard session.
type SessionState struct {
	Cards       []Flashcard `json:"cards"`
	Position    int         `json:"position"`
	Flipped     bool        `json:"flipped"`
	Log         []LogEntry  `json:"log"` // Log of all actions performed
	WriteAnswer bool        // Whether the app is in "write answer" mode
}

// LogEntry represents a single entry in the session log.
type LogEntry struct {
	Action    string    `json:"action"`
	Timestamp time.Time `json:"timestamp"`
}

// AppState represents the overall state of the application.
type AppState struct {
	InSession   bool        // Whether the app is in a flashcard session
	Session     SessionState // Current session state
	ShowMainMenu bool        // Whether to show the main menu
}

// Model represents the Bubble Tea model.
type Model struct {
	AppState    AppState
	TextInput   textinput.Model // For writing answers
}

// Init initializes the Bubble Tea model.
func (m Model) Init() tea.Cmd {
	return nil
}

// Update handles user input and updates the model.
func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd

	switch msg := msg.(type) {
	case tea.KeyMsg:
		if m.AppState.ShowMainMenu {
			// Main menu keybindings
			switch {
			case key.Matches(msg, keys.StartNewSession):
				// Start a new session
				m.AppState.ShowMainMenu = false
				m.AppState.InSession = true
				m.AppState.Session = SessionState{
					Cards:    m.AppState.Session.Cards,
					Position: 0,
					Flipped:  false,
					Log:      []LogEntry{},
				}
			case key.Matches(msg, keys.ResumeSession):
				// Resume a session
				sessionState, err := LoadSession("session.json")
				if err != nil {
					fmt.Printf("Error loading session: %v\n", err)
				} else {
					m.AppState.ShowMainMenu = false
					m.AppState.InSession = true
					m.AppState.Session = sessionState
				}
			case key.Matches(msg, keys.Quit):
				// Quit
				return m, tea.Quit
			}
		} else if m.AppState.InSession {
			if m.AppState.Session.WriteAnswer {
				// Handle "write answer" mode
				switch {
				case key.Matches(msg, keys.SubmitAnswer):
					// Append the user's answer to the array
					answer := m.TextInput.Value()
					m.AppState.Session.Cards[m.AppState.Session.Position].Answers = append(
						m.AppState.Session.Cards[m.AppState.Session.Position].Answers,
						answer,
					)
					m.AppState.Session.WriteAnswer = false
					m.AppState.Session.Log = append(m.AppState.Session.Log, LogEntry{Action: "WRITE_ANSWER", Timestamp: time.Now()})
					m.TextInput.Reset() // Clear the input
				case key.Matches(msg, keys.CancelAnswer):
					// Cancel "write answer" mode
					m.AppState.Session.WriteAnswer = false
					m.TextInput.Reset() // Clear the input
				default:
					// Update the text input
					m.TextInput, cmd = m.TextInput.Update(msg)
				}
			} else {
				// Flashcard session keybindings
				switch {
				case key.Matches(msg, keys.Flip):
					// Flip the card
					m.AppState.Session.Flipped = !m.AppState.Session.Flipped
					m.AppState.Session.Log = append(m.AppState.Session.Log, LogEntry{Action: "FLIP_CARD", Timestamp: time.Now()})
				case key.Matches(msg, keys.Next):
					// Next card
					if m.AppState.Session.Position < len(m.AppState.Session.Cards)-1 {
						m.AppState.Session.Position++
						m.AppState.Session.Flipped = false
						m.AppState.Session.Log = append(m.AppState.Session.Log, LogEntry{Action: "NEXT_CARD", Timestamp: time.Now()})
					}
				case key.Matches(msg, keys.Prev):
					// Previous card
					if m.AppState.Session.Position > 0 {
						m.AppState.Session.Position--
						m.AppState.Session.Flipped = false
						m.AppState.Session.Log = append(m.AppState.Session.Log, LogEntry{Action: "PREV_CARD", Timestamp: time.Now()})
					}
				case key.Matches(msg, keys.WriteAnswer):
					// Enter "write answer" mode
					m.AppState.Session.WriteAnswer = true
					m.TextInput.Focus() // Focus the text input
				case key.Matches(msg, keys.Save):
					// Save and quit
					if err := SaveSession(m.AppState.Session); err != nil {
						fmt.Printf("Error saving session: %v\n", err)
					} else {
						fmt.Println("Session saved successfully!")
					}
					m.AppState.ShowMainMenu = true
					m.AppState.InSession = false
				case key.Matches(msg, keys.Quit):
					// Quit to main menu
					m.AppState.ShowMainMenu = true
					m.AppState.InSession = false
				}
			}
		}
	}
	return m, cmd
}

// View renders the UI.
func (m Model) View() string {
	if m.AppState.ShowMainMenu {
		return `
Welcome to the Flashcard App!

  1. Start a new session
  2. Resume a session
  q. Quit

Press the corresponding key to choose an option.
`
	} else if m.AppState.InSession {
		if m.AppState.Session.WriteAnswer {
			// Render the "write answer" view
			return fmt.Sprintf(
				"Flashcard %d/%d\n\n%s\n\n%s\n\n%s",
				m.AppState.Session.Position+1,
				len(m.AppState.Session.Cards),
				"Write your answer:",
				m.TextInput.View(),
				"Press [Enter] to submit, [Esc] to cancel.",
			)
		} else {
			// Render the flashcard view
			card := m.AppState.Session.Cards[m.AppState.Session.Position]
			content := card.Question
			if m.AppState.Session.Flipped {
				content = card.Answer
			}

			view := fmt.Sprintf(
				"Flashcard %d/%d\n\n%s\n\n%s\n\n%s",
				m.AppState.Session.Position+1,
				len(m.AppState.Session.Cards),
				content,
				"Press [space] to flip, [n] for next, [p] for previous, [w] to write answer, [s] to save and quit.",
				"",
			)

			// Display all user answers for the current question
			if len(card.Answers) > 0 {
				view += "\n\nYour answers:"
				for i, answer := range card.Answers {
					view += fmt.Sprintf("\n%d. %s", i+1, answer)
				}
			}

			return view
		}
	}
	return ""
}

// LoadCards loads flashcards from a JSON file.
func LoadCards(filename string) ([]Flashcard, error) {
	file, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	var cards []Flashcard
	if err := json.Unmarshal(file, &cards); err != nil {
		return nil, err
	}

	return cards, nil
}

// LoadSession loads a saved session from a JSON file.
func LoadSession(filename string) (SessionState, error) {
	file, err := os.ReadFile(filename)
	if err != nil {
		return SessionState{}, err
	}

	var sessionState SessionState
	if err := json.Unmarshal(file, &sessionState); err != nil {
		return SessionState{}, err
	}

	return sessionState, nil
}

// SaveSession saves the current session state to a JSON file.
func SaveSession(sessionState SessionState) error {
	file, err := json.MarshalIndent(sessionState, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile("session.json", file, 0644)
}

// Key bindings
var keys = keyMap{
	StartNewSession: key.NewBinding(
		key.WithKeys("1"),
		key.WithHelp("1", "start new session"),
	),
	ResumeSession: key.NewBinding(
		key.WithKeys("2"),
		key.WithHelp("2", "resume session"),
	),
	Flip: key.NewBinding(
		key.WithKeys(" "),
		key.WithHelp("space", "flip card"),
	),
	Next: key.NewBinding(
		key.WithKeys("n"),
		key.WithHelp("n", "next card"),
	),
	Prev: key.NewBinding(
		key.WithKeys("p"),
		key.WithHelp("p", "previous card"),
	),
	WriteAnswer: key.NewBinding(
		key.WithKeys("w"),
		key.WithHelp("w", "write answer"),
	),
	SubmitAnswer: key.NewBinding(
		key.WithKeys("enter"),
		key.WithHelp("enter", "submit answer"),
	),
	CancelAnswer: key.NewBinding(
		key.WithKeys("esc"),
		key.WithHelp("esc", "cancel answer"),
	),
	Save: key.NewBinding(
		key.WithKeys("s"),
		key.WithHelp("s", "save and quit"),
	),
	Quit: key.NewBinding(
		key.WithKeys("q", "ctrl+c"),
		key.WithHelp("q", "quit"),
	),
}

// Key map
type keyMap struct {
	StartNewSession key.Binding
	ResumeSession   key.Binding
	Flip            key.Binding
	Next            key.Binding
	Prev            key.Binding
	WriteAnswer     key.Binding
	SubmitAnswer    key.Binding
	CancelAnswer    key.Binding
	Save            key.Binding
	Quit            key.Binding
}

func main() {
	// Load flashcards from JSON file
	cards, err := LoadCards("data/flashcards.json")
	if err != nil {
		fmt.Printf("Error loading flashcards: %v\n", err)
		os.Exit(1)
	}

	// Initialize the app state
	appState := AppState{
		ShowMainMenu: true,
		InSession:    false,
		Session: SessionState{
			Cards:    cards,
			Position: 0,
			Flipped:  false,
			Log:      []LogEntry{},
		},
	}

	// Initialize the text input for writing answers
	textInput := textinput.New()
	textInput.Placeholder = "Type your answer here..."

	// Start the Bubble Tea program
	model := Model{
		AppState:  appState,
		TextInput: textInput,
	}
	if _, err := tea.NewProgram(model).Run(); err != nil {
		fmt.Printf("Error running program: %v\n", err)
		os.Exit(1)
	}
}
