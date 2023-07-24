![PowerShell Gallery Version (including pre-releases)](https://img.shields.io/powershellgallery/v/F7History)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/F7History)
![PowerShell Gallery](https://img.shields.io/powershellgallery/p/F7History)
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)

## F7History - Graphical Command History for PowerShell

A PowerShell module that provides a graphical Command History activated by the `F7` and `Shift-F7` keys.

![Demo](https://i.imgur.com/GvX7LEL.gif)

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

## Dependencies

This module is dependent on these modules which will automatically be installed if they are not already present:

* [PSReadLine](https://github.com/PowerShell/PSReadLine)
* [Out-ConsoleGridView](https://github.com/PowerShell/GraphicalTools)

## Building and Deploying

To build:

```ps1
rm ./Output
Build-Module
``````

The module is published to the PowerShell Gallery using GitHub Actions. See the publish.yml GitHub Action for details.

We use `MainLine Development`. See https://gitversion.net/docs/reference/modes/mainline

### To push a new version to the PowerShell Gallery:

Merge your changes to the `main` branch, or push directly to `main`. The GitHub Action will build and publish the module to the PowerShell Gallery here: https://www.powershellgallery.com/packages/F7History

To increment the minor version ensure the merge message includes "+semver: minor". To increment the major version ensure the merge message includes "+semver: major". See https://gitversion.net/docs/reference/version-increments


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
