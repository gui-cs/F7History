## Use F7 as "Show Command History" in Powershell

## Setup

Requires `Out-ConsoleGridView` from [GraphicalTools](https://github.com/PowerShell/GraphicalTools). 

1. Install `GraphicalTools` by typing the command `Install-Module -Name Microsoft.PowerShell.ConsoleGuiTools`
2. Run the `F7History.ps1` script (optionally, run from `$profile` so it's always ready).

## Usage 

Press `F7` to see the history for the current PowerShell instance

Press `Shift-F7` to see the history for all PowerShell instances.

Whatever is selected within `Out-ConsoleGridView` will be inserted on the command line when `ENTER` is pressed.

Whatever was typed on the command line prior to hitting `F7` or `Shift-F7` will be used as a filter for `ocgv`.

![https://i.imgur.com/PMdhxPY.gif](https://i.imgur.com/EFYuNvB.gif)
