<table >
  <tbody style="border: 0px">
    <tr style="border: 0px">
      <td rowspan="2" style="border: 0px">
        <img src="https://gui-cs.github.io/Terminal.Gui/images/F7HistoryIcon.png"
          alt="F7 History Icon"
          width="120px"/>
      </td>
      <td style="border: 0px">
        <span style="vertical-align:top;font-size: 1.5em;">F7History - Graphical Command History for PowerShell.</span>
        <br/>
        <span style="font-size: 1em">A PowerShell module providing a graphical Command History activated by the `F7` and `Shift-F7` keys.</span>
        <br/>
        <span style="font-size: .8em">Built with <a href="https://github.com/gui-cs/Terminal.Gui">Terminal.Gui</a> and <a href="https://github.com/PowerShell/GraphicalTools">Terminal.Gui</a> by <a href="https://github.com/tig">Tig</a>.</span>
      </td>
    </tr>
  </tbody>
</table>

![Demo](https://gui-cs.github.io/Terminal.Gui/images/F7History.gif)

## Setup

1. At a PowerShell prompt, use `Install-Module` to install `F7History` from the [PowerShell Gallery](https://www.powershellgallery.com/packages/F7History/):

```ps1
Install-Module -Name "F7History"
```

2. Import the module using `Import-Module`; adding this command to your PowerShell `$profile` will ensure the `F7History` is always available.

```ps1
Import-Module -Name "F7History"
```

3. Press `F7` or `Shift-F7` to invoke.

## Usage 

At the PowerShell command line:

* Press `F7` to see the history for the current PowerShell instance.
* Press `Shift-F7` to see the history for all PowerShell instances.

Whatever was typed on the command line before hitting `F7` or `Shift-F7` will be used for the `Out-ConsoleGridView` `-Filter`` parameter.

When the `Command Line History` window is displayed:

* Use the arrow keys or mouse to select an item.
* Use `ENTER` to insert the selected item on the command line.
* Use `ESC` to close the window without inserting anything on the command line.

## Configuration

To change the key bindings, use the `-ArgumentList` parameter when importing the module. For example, to use `F6` and `Shift-F6` instead of `F7` and `Shift-F7`:

```ps1
Import-Module -Name "F7History" -ArgumentList  @{Key = "F6"; AllKey = "Shift-F6"}
```

### Forcing F7History to use NetDriver

[Terminal.Gui](https://github.com/gui-cs/Terminal.Gui), upon which F7History is built, has an abstraction layer for OS and terminal platforms called `ConsoleDrivers`.`CursesDriver` is the default for Linux and macOS. On Windows, the default is `WindowsDriver`. `NetDriver` is a pure .NET implementation that works on all platforms (but is not as fast or full-featured as the platform-specific drivers). 

To force F7History to use `NetDriver`, set the `$F7UseNetDriver` variable to `$true` in your PowerShell session. When `$F7UseNetDriver` is set to `$true`, F7History will display `NetDriver` on the status bar.

### Enabling Diagnostics Information

To enable diagnostics information, set the `$F7EnableDiagnostics` variable to `$true` in your PowerShell session. This will cause F7History to display version information in the status bar and sets both the `-Debug` and `-Verbose` parameters for `Out-ConsoleGridView`.

## Dependencies

`F7History` is dependent on these modules which will automatically be installed if they are not already present:

* [PSReadLine](https://www.powershellgallery.com/packages/PSReadLine)
* [Out-ConsoleGridView](https://www.powershellgallery.com/packages/Microsoft.PowerShell.ConsoleGuiTools)

## More Information

* [F7History on Github](https://github.com/gui-cs/F7History)
* [Terminal.Gui](https://github.com/gui-cs/Terminal.Gui)
* [Out-ConsoleGridView on GitHub](https://github.com/PowerShell/GraphicalTools)