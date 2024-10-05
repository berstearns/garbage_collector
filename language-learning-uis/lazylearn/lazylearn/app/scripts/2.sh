#!/bin/bash

# Define the directory where main.go is located
MAIN_GO_FILE="./cmd/lazylearn/main.go"

# Ensure that the directory exists
if [ ! -f "$MAIN_GO_FILE" ]; then
    echo "Error: $MAIN_GO_FILE does not exist. Please make sure the project structure is set up correctly."
    exit 1
fi

# Write the new content to main.go
cat <<EOL > "$MAIN_GO_FILE"
package main

import (
    "fmt"
    "os"

    "github.com/rivo/tview"
    "github.com/gdamore/tcell/v2"
)

func main() {
    app := tview.NewApplication()

    // Create a text view to display the message
    textView := tview.NewTextView().
        SetDynamicColors(true).
        SetRegions(true).
        SetWrap(true)

    // Add instructions for the user
    textView.SetText("Press 'A' to see a message or 'Q' to quit.")

    // Set input capture for key events
    app.SetInputCapture(func(event *tcell.EventKey) *tcell.EventKey {
        switch event.Rune() {
        case 'a', 'A':
            textView.SetText("Hi Bernardo")
        case 'q', 'Q':
            app.Stop()
            os.Exit(0)
        }
        return event
    })

    // Create a Flex layout to center the text view
    flex := tview.NewFlex().
        AddItem(nil, 0, 1, false).
        AddItem(textView, 0, 3, true).
        AddItem(nil, 0, 1, false)

    // Set the root and start the application
    if err := app.SetRoot(flex, true).Run(); err != nil {
        fmt.Fprintf(os.Stderr, "Error running application: %v\\n", err)
        os.Exit(1)
    }
}
EOL

# Display a success message
echo "The main.go file has been updated successfully!"

# Instructions for installing dependencies
echo "Please make sure to run the following commands to install the required Go packages:"
echo "  go get github.com/rivo/tview"
echo "  go get github.com/gdamore/tcell/v2"

