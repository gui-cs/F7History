## F7History - Use F7 as a graphical "Show Command History" in PowerShell

A PowerShell module that provides a graphical "Show Command History" using `F7` and `Shift-F7`.

## Setup

1. Install `F7History` from the [PowerShell Gallery](https://www.powershellgallery.com/packages/F7History/).

```ps1
Install-Module F7History
```

2. Add a line to import `F7History` in your PowerShell `$profile`:

```ps1
Import-Module F7History
```

## Usage 

At the PowerShell command line:

* Press `F7` to see the history for the current PowerShell instance.
* Press `Shift-F7` to see the history for all PowerShell instances.

Whatever was typed on the command line before hitting `F7` or `Shift-F7` will be used for the `Out-ConsoleGridView` `-Filter`` parameter.

When the `Command Line History` window is displayed:

* Use the arrow keys or mouse to select an item.
* Use `ENTER` to insert the selected item on the command line.
* Use `ESC` to close the window without inserting anything on the command line.

![https://i.imgur.com/PMdhxPY.gif](https://i.imgur.com/EFYuNvB.gif)

## More info

This module is dependent on these modules which will automatically be installed if they are not already present:

* [PSReadLine](https://github.com/PowerShell/PSReadLine)
* [Out-ConsoleGridView](https://github.com/PowerShell/GraphicalTools)

## Building and Deploying

The module is published to the PowerShell Gallery using GitHub Actions. See the publish.yml GitHub Action for details.
