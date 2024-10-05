package main

import (
	"fmt"
	"github.com/rivo/tview"
)

const (
	batchSize  = 80         // The number of rows loaded per batch.
	finderPage = "*finder*" // The name of the Finder page.
)

var (
	app         *tview.Application // The tview application.
	pages       *tview.Pages       // The application pages.
	finderFocus tview.Primitive    // The primitive in the Finder that last had focus.
)

// Main entry point.
func main() {
	// Start the application.
	app = tview.NewApplication()
	finder()
	if err := app.Run(); err != nil {
		fmt.Printf("Error running application: %s\n", err)
	}
}

// Sets up a "Finder" used to navigate the options in the language learning app.
func finder() {
	// Create the menu on the left side with language learning options.
	menu := tview.NewList().
		ShowSecondaryText(false).
		AddItem("View Fill the Gap Exercise", "", '1', func() {
			showExerciseContent()
		}).
		AddItem("Create Exercise", "", '2', func() {
			createExercise()
		}).
		AddItem("See My Profile Score", "", '3', func() {
			showProfileScore()
		})

	menu.SetBorder(true).SetTitle("Menu")

	// Create the main screen.
	mainScreen := tview.NewTextView().
		SetDynamicColors(true).
		SetRegions(true).
		SetWrap(true).
		SetText("Select an option from the menu.")

	// Create a Flex layout to arrange the menu and main screen.
	flex := tview.NewFlex().
		AddItem(menu, 0, 1, true).
		AddItem(mainScreen, 0, 3, false)

	// Set up the pages and show the Finder.
	pages = tview.NewPages().
		AddPage(finderPage, flex, true, true)
	app.SetRoot(pages, true)
}

// Shows the contents of the fill-the-gap exercise.
func showExerciseContent() {
	finderFocus = app.GetFocus()

	// Dummy data for exercise content.
	exerciseContent := `Fill the gap in the following sentence:
I ___ (like) playing tennis.

Options:
1. like
2. loves
3. liked`

	// Display the exercise content in a new page.
	content := tview.NewTextView().
		SetDynamicColors(true).
		SetRegions(true).
		SetWrap(true).
		SetText(exerciseContent)

	// Create a button to go back to the main menu.
	backButton := tview.NewButton("Back to Main Menu").SetSelectedFunc(func() {
		pages.SwitchToPage(finderPage)
		if finderFocus != nil {
			app.SetFocus(finderFocus)
		}
	})

	// Create a vertical layout with the content and back button.
	layout := tview.NewFlex().
		SetDirection(tview.FlexRow).
		AddItem(content, 0, 1, false).
		AddItem(backButton, 1, 1, true)

	frame := tview.NewFrame(layout).
		SetBorders(0, 0, 0, 0, 0, 0)
	frame.SetBorder(true).SetTitle("Fill the Gap Exercise")

	// Add a new page and show it.
	pages.AddPage("exercise", frame, true, true)
}

// Dummy function for creating an exercise.
func createExercise() {
	// Placeholder content for creating an exercise.
	content := tview.NewTextView().
		SetDynamicColors(true).
		SetRegions(true).
		SetWrap(true).
		SetText("This is a placeholder for creating an exercise.")

	// Create a button to go back to the main menu.
	backButton := tview.NewButton("Back to Main Menu").SetSelectedFunc(func() {
		pages.SwitchToPage(finderPage)
		if finderFocus != nil {
			app.SetFocus(finderFocus)
		}
	})

	// Create a vertical layout with the content and back button.
	layout := tview.NewFlex().
		SetDirection(tview.FlexRow).
		AddItem(content, 0, 1, false).
		AddItem(backButton, 1, 1, true)

	frame := tview.NewFrame(layout).
		SetBorders(0, 0, 0, 0, 0, 0)
	frame.SetBorder(true).SetTitle("Create Exercise")

	// Add a new page and show it.
	pages.AddPage("createExercise", frame, true, true)
}

// Shows the user's profile score and CEFR level classification.
func showProfileScore() {
	finderFocus = app.GetFocus()

	// Dummy data for profile score.
	profileScore := `Vocabulary Score: 1200
CEFR Level: B2 (Upper-Intermediate)`

	// Display the profile score in a new page.
	content := tview.NewTextView().
		SetDynamicColors(true).
		SetRegions(true).
		SetWrap(true).
		SetText(profileScore)

	// Create a button to go back to the main menu.
	backButton := tview.NewButton("Back to Main Menu").SetSelectedFunc(func() {
		pages.SwitchToPage(finderPage)
		if finderFocus != nil {
			app.SetFocus(finderFocus)
		}
	})

	// Create a vertical layout with the content and back button.
	layout := tview.NewFlex().
		SetDirection(tview.FlexRow).
		AddItem(content, 0, 1, false).
		AddItem(backButton, 1, 1, true)

	frame := tview.NewFrame(layout).
		SetBorders(0, 0, 0, 0, 0, 0)
	frame.SetBorder(true).SetTitle("My Profile Score")

	// Add a new page and show it.
	pages.AddPage("profile", frame, true, true)
}

