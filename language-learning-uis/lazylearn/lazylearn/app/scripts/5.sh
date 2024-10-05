#!/bin/bash

# Define the directory where main.go is located
MAIN_GO_FILE="./cmd/lazylearn/main.go"
EXERCISE_FILE="./assets/fill_the_gap.txt"

# Ensure that the directory exists
if [ ! -d "$(dirname "$MAIN_GO_FILE")" ]; then
    echo "Error: Directory $(dirname "$MAIN_GO_FILE") does not exist. Please make sure the project structure is set up correctly."
    exit 1
fi

# Ensure the assets directory exists
if [ ! -d "$(dirname "$EXERCISE_FILE")" ]; then
    echo "Creating assets directory..."
    mkdir -p "$(dirname "$EXERCISE_FILE")"
fi

# Write the new content to main.go
cat <<EOL > "$MAIN_GO_FILE"
package main

import (
    "fmt"
    "io/ioutil"
    "os"

    "github.com/rivo/tview"
    "github.com/gdamore/tcell/v2"
)

func main() {
    app := tview.NewApplication()

    // Create the left-side menu
    menu := tview.NewList().
        AddItem("1. Fill the Gap Exercise", "Complete the exercise", '1', nil).
        AddItem("2. View Item 2", "Description for item 2", '2', nil).
        AddItem("3. View Item 3", "Description for item 3", '3', nil).
        SetTitle("Menu").
        SetBorder(true)

    // Create the main screen
    mainScreen := tview.NewTextView().
        SetDynamicColors(true).
        SetRegions(true).
        SetWrap(true).
        SetText("Welcome to the Main Screen!\\nPress '1' to view the fill the gap exercise, '2' for item 2, or '3' for item 3.")

    // Read exercise content from file
    exerciseContent, err := ioutil.ReadFile("$EXERCISE_FILE")
    if err != nil {
        fmt.Fprintf(os.Stderr, "Error reading exercise file: %v\\n", err)
        os.Exit(1)
    }

    // Create a Flex layout to arrange the menu and main screen
    flex := tview.NewFlex().
        AddItem(menu, 0, 1, false).
        AddItem(mainScreen, 0, 3, true)

    // Set input capture to handle key presses
    app.SetInputCapture(func(event *tcell.EventKey) *tcell.EventKey {
        switch event.Rune() {
        case '1':
            mainScreen.SetText(string(exerciseContent))
        case '2':
            mainScreen.SetText("You selected Item 2")
        case '3':
            mainScreen.SetText("You selected Item 3")
        case 'q', 'Q':
            app.Stop()
            os.Exit(0)
        }
        return event
    })

    // Set the root and start the application
    if err := app.SetRoot(flex, true).Run(); err != nil {
        fmt.Fprintf(os.Stderr, "Error running application: %v\\n", err)
        os.Exit(1)
    }
}
EOL

# Create a sample exercise file
cat <<EOL > "$EXERCISE_FILE"
Fill the gap in the following sentence:
I ___ (like) playing tennis.

Options:
1. like
2. loves
3. liked
EOL

# Display a success message
echo "The main.go file and exercise file have been updated successfully!"

# Instructions for installing dependencies
echo "Please make sure to run the following commands to install the required Go packages:"
echo "  go get github.com/rivo/tview"
echo "  go get github.com/gdamore/tcell/v2"

