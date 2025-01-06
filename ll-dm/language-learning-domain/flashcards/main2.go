package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"time"
)

// Flashcard represents a single flashcard.
type Flashcard struct {
	Question string `json:"question"`
	Answer   string `json:"answer"`
}

// LogEntry represents a single entry in the session log.
type LogEntry struct {
	Action    string    `json:"action"`
	Timestamp time.Time `json:"timestamp"`
}

// SessionState represents the state of a flashcard session.
type SessionState struct {
	Cards    []Flashcard `json:"cards"`
	Position int         `json:"position"`
	Flipped  bool        `json:"flipped"`
	Log      []LogEntry  `json:"log"` // Log of all actions performed
}

// State represents the application state.
type State struct {
	SessionState
	InSession bool
}

// Action represents a Redux-like action.
type Action struct {
	Type    string
	Payload interface{}
}

// Define action types
const (
	ActionFlipCard     = "FLIP_CARD"
	ActionNextCard     = "NEXT_CARD"
	ActionPrevCard     = "PREV_CARD"
	ActionLoadCards    = "LOAD_CARDS"
	ActionStartSession = "START_SESSION"
	ActionResumeSession = "RESUME_SESSION"
	ActionSaveSession  = "SAVE_SESSION"
)

// Store represents a Redux-like store.
type Store struct {
	state    State
	reducer  func(State, Action) State
	listeners []func(State)
}

// NewStore creates a new store.
func NewStore(reducer func(State, Action) State, initialState State) *Store {
	return &Store{
		state:    initialState,
		reducer:  reducer,
		listeners: []func(State){},
	}
}

// GetState returns the current state.
func (s *Store) GetState() State {
	return s.state
}

// Dispatch dispatches an action to the store.
func (s *Store) Dispatch(action Action) {
	s.state = s.reducer(s.state, action)
	for _, listener := range s.listeners {
		listener(s.state)
	}
}

// Subscribe adds a listener to the store.
func (s *Store) Subscribe(listener func(State)) {
	s.listeners = append(s.listeners, listener)
}

// Reducer handles state transitions based on actions.
func Reducer(state State, action Action) State {
	newState := state
	switch action.Type {
	case ActionFlipCard:
		newState = State{
			SessionState: SessionState{
				Cards:    state.Cards,
				Position: state.Position,
				Flipped:  !state.Flipped,
				Log:      append(state.Log, LogEntry{Action: ActionFlipCard, Timestamp: time.Now()}),
			},
			InSession: state.InSession,
		}
	case ActionNextCard:
		if state.Position < len(state.Cards)-1 {
			newState = State{
				SessionState: SessionState{
					Cards:    state.Cards,
					Position: state.Position + 1,
					Flipped:  false,
					Log:      append(state.Log, LogEntry{Action: ActionNextCard, Timestamp: time.Now()}),
				},
				InSession: state.InSession,
			}
		}
	case ActionPrevCard:
		if state.Position > 0 {
			newState = State{
				SessionState: SessionState{
					Cards:    state.Cards,
					Position: state.Position - 1,
					Flipped:  false,
					Log:      append(state.Log, LogEntry{Action: ActionPrevCard, Timestamp: time.Now()}),
				},
				InSession: state.InSession,
			}
		}
	case ActionLoadCards:
		cards := action.Payload.([]Flashcard)
		newState = State{
			SessionState: SessionState{
				Cards:    cards,
				Position: 0,
				Flipped:  false,
				Log:      state.Log,
			},
			InSession: state.InSession,
		}
	case ActionStartSession:
		newState = State{
			SessionState: SessionState{
				Cards:    state.Cards,
				Position: 0,
				Flipped:  false,
				Log:      []LogEntry{},
			},
			InSession: true,
		}
	case ActionResumeSession:
		sessionState := action.Payload.(SessionState)
		newState = State{
			SessionState: sessionState,
			InSession:    true,
		}
	case ActionSaveSession:
		sessionState := state.SessionState
		file, err := json.MarshalIndent(sessionState, "", "  ")
		if err != nil {
			fmt.Printf("Error saving session: %v\n", err)
			return state
		}
		if err := os.WriteFile("session.json", file, 0644); err != nil {
			fmt.Printf("Error saving session: %v\n", err)
			return state
		}
		fmt.Println("Session saved successfully!")
		newState = State{
			SessionState: SessionState{},
			InSession:    false,
		}
	}
	return newState
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

// MainPageView renders the main page UI.
func MainPageView() {
	fmt.Println("Welcome to the Flashcard App!")
	fmt.Println("1. Start a new session")
	fmt.Println("2. Resume a session")
	fmt.Println("q. Quit")
}

// FlashcardView renders the flashcard UI.
func FlashcardView(state State) {
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
		"Press [space] to flip, [n] for next, [p] for previous, [s] to save and quit.",
		"",
	)
}

func main() {
	// Load flashcards from JSON file
	cards, err := LoadCards("data/flashcards.json")
	if err != nil {
		fmt.Printf("Error loading flashcards: %v\n", err)
		os.Exit(1)
	}

	// Initialize the store
	initialState := State{
		SessionState: SessionState{
			Cards:    cards,
			Position: 0,
			Flipped:  false,
			Log:      []LogEntry{},
		},
		InSession: false,
	}
	store := NewStore(Reducer, initialState)

	// Subscribe to state changes
	store.Subscribe(func(state State) {
		if state.InSession {
			FlashcardView(state)
		} else {
			MainPageView()
		}
	})

	// Initial render
	MainPageView()

	// Handle user input
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		input := scanner.Text()
		if store.GetState().InSession {
			switch input {
			case " ":
				store.Dispatch(Action{Type: ActionFlipCard})
			case "n":
				store.Dispatch(Action{Type: ActionNextCard})
			case "p":
				store.Dispatch(Action{Type: ActionPrevCard})
			case "s":
				store.Dispatch(Action{Type: ActionSaveSession})
				return
			case "q":
				return
			}
		} else {
			switch input {
			case "1":
				store.Dispatch(Action{Type: ActionStartSession})
			case "2":
				sessionState, err := LoadSession("session.json")
				if err != nil {
					fmt.Printf("Error loading session: %v\n", err)
				} else {
					store.Dispatch(Action{Type: ActionResumeSession, Payload: sessionState})
				}
			case "q":
				return
			}
		}
	}
}
