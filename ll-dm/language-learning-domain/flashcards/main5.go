package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"time"

	"github.com/charmbracelet/huh"
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

// MainPageView renders the main page UI.
func MainPageView() {
	fmt.Println("Welcome to the Flashcard App!")
	fmt.Println("1. Start a new session")
	fmt.Println("2. Resume a session")
	fmt.Println("q. Quit")
}

// FlashcardView renders the flashcard UI.
func FlashcardView(state SessionState) {
	card := state.Cards[state.Position]
	content := card.Question
	if state.Flipped {
		content = card.Answer
	}

	fmt.Printf(
		"Flashcard %d/%d\n\n%s\n\n%s\n\n%s",
		state.Position+1,
		len(state.Cards),
		content,
		"Press [space] to flip, [n] for next, [p] for previous, [w] to write answer, [s] to save and quit.",
		"",
	)

	// Display all user answers for the current question
	if len(card.Answers) > 0 {
		fmt.Println("\nYour answers:")
		for i, answer := range card.Answers {
			fmt.Printf("%d. %s\n", i+1, answer)
		}
	}
}

// WriteAnswerForm displays a Huh form for writing an answer.
func WriteAnswerForm() (string, error) {
	var answer string
	form := huh.NewForm(
		huh.NewGroup(
			huh.NewText().
				Title("Write your answer:").
				Value(&answer),
		),
	)

	err := form.Run()
	return answer, err
}

func main() {
	// Load flashcards from JSON file
	cards, err := LoadCards("data/flashcards.json")
	if err != nil {
		fmt.Printf("Error loading flashcards: %v\n", err)
		os.Exit(1)
	}

	// Initialize the session state
	sessionState := SessionState{
		Cards:    cards,
		Position: 0,
		Flipped:  false,
		Log:      []LogEntry{},
	}

	// Handle user input
	scanner := bufio.NewScanner(os.Stdin)
	for {
		if sessionState.WriteAnswer {
			// Use Huh form to write an answer
			answer, err := WriteAnswerForm()
			if err != nil {
				fmt.Printf("Error: %v\n", err)
				os.Exit(1)
			}

			// Append the user's answer to the array
			sessionState.Cards[sessionState.Position].Answers = append(
				sessionState.Cards[sessionState.Position].Answers,
				answer,
			)
			sessionState.WriteAnswer = false
			sessionState.Log = append(sessionState.Log, LogEntry{
				Action:    "WRITE_ANSWER",
				Timestamp: time.Now(),
			})
			fmt.Printf("Your answer: %s\n", answer)
		} else {
			// Render the current view
			FlashcardView(sessionState)

			// Read user input
			scanner.Scan()
			input := scanner.Text()

			switch input {
			case " ":
				// Flip the card
				sessionState.Flipped = !sessionState.Flipped
				sessionState.Log = append(sessionState.Log, LogEntry{Action: "FLIP_CARD", Timestamp: time.Now()})
			case "n":
				// Next card
				if sessionState.Position < len(sessionState.Cards)-1 {
					sessionState.Position++
					sessionState.Flipped = false
					sessionState.Log = append(sessionState.Log, LogEntry{Action: "NEXT_CARD", Timestamp: time.Now()})
				}
			case "p":
				// Previous card
				if sessionState.Position > 0 {
					sessionState.Position--
					sessionState.Flipped = false
					sessionState.Log = append(sessionState.Log, LogEntry{Action: "PREV_CARD", Timestamp: time.Now()})
				}
			case "w":
				// Write answer
				sessionState.WriteAnswer = true
			case "s":
				// Save and quit
				if err := SaveSession(sessionState); err != nil {
					fmt.Printf("Error saving session: %v\n", err)
				} else {
					fmt.Println("Session saved successfully!")
				}
				return
			case "q":
				// Quit
				return
			}
		}
	}
}
