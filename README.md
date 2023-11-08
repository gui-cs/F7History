![PowerShell Gallery Version (including pre-releases)](https://img.shields.io/powershellgallery/v/F7History)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/F7History)
![PowerShell Gallery](https://img.shields.io/powershellgallery/p/F7History)
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)

<div align="center">
  <img src="https://gui-cs.github.io/Terminal.Gui/images/F7HistoryIcon.png"
       alt="F7 History Icon"
       width="100px"
  />
</div>

## F7History - Graphical Command History for PowerShell

A PowerShell module that provides a graphical Command History activated by the `F7` and `Shift-F7` keys.

![Demo](https://gui-cs.github.io/Terminal.Gui/images/F7History.gif)

## Setup

Install `F7History` from the [PowerShell Gallery](https://www.powershellgallery.com/packages/F7History/).

```ps1
Install-Module -Name "F7History"
```

Add a line to import `F7History` in your PowerShell `$profile`:

```ps1
Import-Module -Name "F7History"
```

To change the key bindings, use the `-ArgumentList` parameter when importing the module. For example, to use `F6` and `Shift-F6` instead of `F7` and `Shift-F7`:

```ps1
Import-Module -Name "F7History" -ArgumentList  @{Key = "F6"; AllKey = "Shift-F6"}
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

### Forcing F7History to use NetDriver

[Terminal.Gui](https://github.com/gui-cs/Terminal.Gui), upon which F7History is built, has an abstraction layer for OS and terminal platforms called `ConsoleDrivers`.`CursesDriver` is the default for Linux and macOS. On Windows, the default is `WindowsDriver`. `NetDriver` is a pure .NET implementation that works on all platforms (but is not as fast or full-featured as the platform-specific drivers). 

To force F7History to use `NetDriver`, set the `$F7UseNetDriver` variable to `$true` in your PowerShell session. When `$F7UseNetDriver` is set to `$true`, F7History will display `NetDriver` on the status bar.

### Enabling Diagnostics Information

To enable diagnostics information, set the `$F7EnableDiagnostics` variable to `$true` in your PowerShell session. This will cause F7History to display version information in the status bar and sets both the `-Debug` and `-Verbose` parameters for `Out-ConsoleGridView`.

## Dependencies

This module is dependent on these modules which will automatically be installed if they are not already present:

* [PSReadLine](https://github.com/PowerShell/PSReadLine)
* [Out-ConsoleGridView](https://github.com/PowerShell/GraphicalTools)

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://www.kindel.com"><img src="https://avatars.githubusercontent.com/u/585482?v=4?s=100" width="100px;" alt="Tig"/><br /><sub><b>Tig</b></sub></a><br /><a href="#maintenance-tig" title="Maintenance">🚧</a> <a href="#infra-tig" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/gui-cs/F7History/pulls?q=is%3Apr+reviewed-by%3Atig" title="Reviewed Pull Requests">👀</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
