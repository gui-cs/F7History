################################################################################
# f7_history -Global $true | $false
#
function f7_history {
  param(
    [parameter(Mandatory = $true)]
    [Boolean]
    $global
  )

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

  if ($global) {
    # Global history
    $history = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems().CommandLine
    # reverse the items so most recent is on top
    [array]::Reverse($history)
    $selection = $history | Select-Object -Unique | Out-ConsoleGridView -OutputMode Single -Filter $line -Title "Command History for All Powershell Instances"
  }
  else {
    # Local history
    $history = Get-History | Sort-Object -Descending -Property Id -Unique | Select-Object CommandLine -ExpandProperty CommandLine
    $selection = $history | Out-ConsoleGridView -OutputMode Single -Filter $line -Title "Command History"
  }

  if ($selection) {
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($selection)
    if ($selection.StartsWith($line)) {
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor)
    }
    else {
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selection.Length)
    }
  }
}

if ($args.Count -eq 0 -or $null -eq $args[0]["Key"]) {
  $key = "F7"
} else {
  $key = $args[0]["Key"]
}

# When F7 is pressed, show the local command line history in OCGV
$parameters = @{
  Key              = $key
  BriefDescription = 'Show Matching Command History'
  LongDescription  = 'Show Matching Command History using Out-ConsoleGridView'
  ScriptBlock      = {
    f7_history -Global $false
  }
}
Set-PSReadLineKeyHandler @parameters

if ($args.Count -eq 0 -or $null -eq $args[0]["AllKey"]) {
  $allkey = "Shift-F7"
} else {
  $allkey = $args[0]["AllKey"]
}

# When Shift-F7 is pressed, show the local command line history in OCGV
$parameters = @{
  Key              = $allkey
  BriefDescription = 'Show Matching Command History for All'
  LongDescription  = 'Show Matching Command History for all PowerShell instances using Out-ConsoleGridView'
  ScriptBlock      = {
    f7_history -Global $true
  }
}
Set-PSReadLineKeyHandler @parameters