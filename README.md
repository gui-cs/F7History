![PowerShell Gallery Version (including pre-releases)](https://img.shields.io/powershellgallery/v/F7History)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/F7History)
![PowerShell Gallery](https://img.shields.io/powershellgallery/p/F7History)
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<table >
  <tbody style="border: 0px">
    <tr style="border: 0px">
      <td rowspan="2" style="border: 0px">
        <img src="https://gui-cs.github.io/F7History/F7HistoryIcon.png"
          alt="F7 History Icon"
          width="120px"/>
      </td>
      <td style="border: 0px">
        <span style="vertical-align:top;font-size: 1.5em;">F7History - Graphical Command History for PowerShell.</span>
        <br/>
        <span style="font-size: 1em">A PowerShell module providing a graphical Command History activated by the `F7` and `Shift-F7` keys.</span>
        <br/>
        <span style="font-size: .8em">Built with <a href="https://github.com/gui-cs/Terminal.Gui">Terminal.Gui</a> and <a href="https://github.com/PowerShell/GraphicalTools">Out-ConsoleGridView</a> by <a href="https://github.com/tig">Tig</a>.</span>
      </td>
    </tr>
  </tbody>
</table>

![Demo](https://gui-cs.github.io/F7History/F7History.gif)

Setup and usage is as easy as...

1. At a PowerShell prompt, use `Install-Module` to install `F7History` from the [PowerShell Gallery](https://www.powershellgallery.com/packages/F7History/):

```ps1
Install-Module -Name "F7History"
```

2. Import the module using `Import-Module`; adding this command to your PowerShell `$profile` will ensure the `F7History` is always available.

```ps1
Import-Module -Name "F7History"
```

3. Press `F7` or `Shift-F7` to invoke.

For more details see the [F7 History Documentation](https://gui-cs.github.io/F7History).
