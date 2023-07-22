## F7History - Use F7 as a graphical "Show Command History" in PowerShell

## Setup

1. Install `F7History` from the [PowerShell Gallery](https://www.powershellgallery.com/packages/F7History/).

```ps1
Install-Module -Name OcgvHistory
```

2. Import `F7History` in your PowerShell `$profile`:

```ps1
Import-Module F7History
```


## Usage 

Press `F7` to see the history for the current PowerShell instance.

Press `Shift-F7` to see the history for all PowerShell instances.

Whatever is selected within `Out-ConsoleGridView` will be inserted on the command line when `ENTER` is pressed.

Whatever was typed on the command line prior to hitting `F7` or `Shift-F7` will be used as a filter for `ocgv`.

![https://i.imgur.com/PMdhxPY.gif](https://i.imgur.com/EFYuNvB.gif)

## More info

This script utilizes [PSReadLine](https://github.com/PowerShell/PSReadLine)

## Building and Deploying

### Publishing to PowerShell Gallery:

```ps1
Publish-Module -Path . -NuGetApiKey <F7HISTORY_GALLERY_KEY>
```