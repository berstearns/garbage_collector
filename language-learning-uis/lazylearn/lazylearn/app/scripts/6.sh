#!/bin/bash

MAIN_GO_FILE="./cmd/lazylearn/main.go"
EXERCISE_FILE="./assets/exercises/fill_the_gap.txt"

declare -a FILEPATHS=( $MAIN_GO_FILE $EXERCISE_FILE )

# Loop through the array
for FILEPATH in "${FILEPATHS[@]}"; do
	echo $FILEPATH
	if [ ! -d "$(dirname "FILEPATH")" ]; then
	    mkdir -p $(dirname $FILEPATH) 
	    if [ ! -d "$(dirname "$FILEPATH")" ]; then
		    echo "Error: Directory $(dirname "$FILEPATH") does not exist. Please create the exercises directory."
		    exit 1
	    fi
	fi
done

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
        AddItem("1. View Fill the Gap Exercise", "View the exercise", '1', nil).
        AddItem("2. Create an Exercise", "Create a new exercise", '2', nil).
        AddItem("3. Download Data", "Download data", '3', nil).
        SetTitle("Menu").
        SetBorder(true)

    // Create the main screen
    mainScreen := tview.NewTextView().
        SetDynamicColors(true).
        SetRegions(true).
        SetWrap(true).
        SetText("Welcome to the Main Screen!\\nPress '1' to view the fill the gap exercise, '2' to create an exercise, or '3' to download data.")

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
            mainScreen.SetText("Creating a new exercise (placeholder).")
        case '3':
            mainScreen.SetText("Downloading data (placeholder).")
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

# Create a sample exercise file if it doesn't exist
if [ ! -f "$EXERCISE_FILE" ]; then
    echo "Creating sample exercise file..."
    cat <<EOL > "$EXERCISE_FILE"
Fill the gap in the following sentence:
I ___ (like) playing tennis.

Options:
1. like
2. loves
3. liked
EOL
fi

# Display a success message
echo "The main.go file and exercise file have been updated successfully!"

# Instructions for installing dependencies
echo "Please make sure to run the following commands to install the required Go packages:"
echo "  go get github.com/rivo/tview"
echo "  go get github.com/gdamore/tcell/v2"

