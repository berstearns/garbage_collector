package main

import (
	"fmt"
	"github.com/gdamore/tcell/v2"
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

// Sets up a "Finder" used to navigate the databases, tables, and columns.
func finder() {
	// Create the basic objects with dummy text.
	databases := tview.NewList().ShowSecondaryText(false)
	databases.SetBorder(true).SetTitle("Databases")
	columns := tview.NewTable().SetBorders(true)
	columns.SetBorder(true).SetTitle("Columns")
	tables := tview.NewList()
	tables.ShowSecondaryText(false).
		SetDoneFunc(func() {
			tables.Clear()
			columns.Clear()
			app.SetFocus(databases)
		})
	tables.SetBorder(true).SetTitle("Tables")

	// Create the layout.
	flex := tview.NewFlex().
		AddItem(databases, 0, 1, true).
		AddItem(tables, 0, 1, false).
		AddItem(columns, 0, 3, false)

	// Dummy data for demonstration.
	dummyDatabases := []string{"Fill the gap exercise", "Database2", "Database3"}
	dummyTables := map[string][]string{
		"Database1": {"Table1", "Table2"},
		"Database2": {"Table3"},
		"Database3": {"Table4", "Table5", "Table6"},
	}
	dummyColumns := map[string][]string{
		"Table1": {"Column1", "Column2"},
		"Table2": {"Column3", "Column4"},
		"Table3": {"Column5", "Column6"},
		"Table4": {"Column7", "Column8"},
		"Table5": {"Column9", "Column10"},
		"Table6": {"Column11", "Column12"},
	}

	// Populate the database list.
	for _, dbName := range dummyDatabases {
		databases.AddItem(dbName, "", 0, func() {
			// A database was selected. Show all of its tables.
			columns.Clear()
			tables.Clear()
			dbName := dbName // Capture the database name.
			for _, tableName := range dummyTables[dbName] {
				tables.AddItem(tableName, "", 0, nil)
			}
			app.SetFocus(tables)

			// When the user navigates to a table, show its columns.
			tables.SetChangedFunc(func(i int, tableName string, t string, s rune) {
				// A table was selected. Show its columns.
				columns.Clear()
				columns.SetCell(0, 0, &tview.TableCell{Text: "Column", Align: tview.AlignCenter, Color: tcell.ColorYellow})
				for index, columnName := range dummyColumns[tableName] {
					columns.SetCell(index+1, 0, &tview.TableCell{Text: columnName, Align: tview.AlignLeft})
				}
			})
			tables.SetCurrentItem(0) // Trigger the initial selection.

			// When the user selects a table, show its content.
			tables.SetSelectedFunc(func(i int, tableName string, t string, s rune) {
				content(tableName)
			})
		})
	}

	// Set up the pages and show the Finder.
	pages = tview.NewPages().
		AddPage(finderPage, flex, true, true)
	app.SetRoot(pages, true)
}

// Shows the contents of the given table.
func content(tableName string) {
	finderFocus = app.GetFocus()

	// If this page already exists, just show it.
	if pages.HasPage(tableName) {
		pages.SwitchToPage(tableName)
		return
	}

	// We display the data in a table embedded in a frame.
	table := tview.NewTable().
		SetFixed(1, 0).
		SetSeparator(tview.BoxDrawingsLightHorizontal).
		SetBordersColor(tcell.ColorYellow)
	frame := tview.NewFrame(table).
		SetBorders(0, 0, 0, 0, 0, 0)
	frame.SetBorder(true).
		SetTitle(fmt.Sprintf(`Contents of table "%s"`, tableName))

	// Dummy data for table content.
	tableContent := []string{"Row1", "Row2", "Row3", "Row4", "Row5"}

	// Load a batch of rows.
	loadRows := func(offset int) {
		// Clear previous data
		table.Clear()

		// The first row in the table is the list of column names.
		table.SetCell(0, 0, &tview.TableCell{Text: "Data", Align: tview.AlignCenter, Color: tcell.ColorYellow})

		// Read the rows.
		for index, row := range tableContent {
			if index+offset >= len(tableContent) {
				break
			}
			table.SetCell(index+1, 0, &tview.TableCell{Text: row})
		}

		// Show how much we've loaded.
		frame.Clear()
		loadMore := ""
		if len(tableContent)-1 > offset {
			loadMore = " - press Enter to load more"
		}
		loadMore = fmt.Sprintf("Loaded %d rows%s", len(tableContent), loadMore)
		frame.AddText(loadMore, false, tview.AlignCenter, tcell.ColorYellow)
	}

	// Load the first batch of rows.
	loadRows(0)

	// Handle key presses.
	table.SetDoneFunc(func(key tcell.Key) {
		switch key {
		case tcell.KeyEscape:
			// Go back to Finder.
			pages.SwitchToPage(finderPage)
			if finderFocus != nil {
				app.SetFocus(finderFocus)
			}
		case tcell.KeyEnter:
			// Load the next batch of rows.
			loadRows(table.GetRowCount() - 1)
			table.ScrollToEnd()
		}
	})

	// Add a new page and show it.
	pages.AddPage(tableName, frame, true, true)
}
