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

  $title = "Command History"
 
  if ($global) {
    # Global history
    $historyItems = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems()
    [array]::Reverse($historyItems)

    $seen = @{}
    $history = $historyItems | Where-Object {
      $key = $_.CommandLine
      if (-not $seen.ContainsKey($key)) {
        $seen[$key] = $true
        return $true
      }
      return $false
    } | ForEach-Object { 
      $startTime = if ($_.StartTime -ne $null -and $_.StartTime -ne [datetime]::MinValue) { $_.StartTime.ToLocalTime() } else { $null }
      [PSCustomObject]@{ 'CommandLine' = $_.CommandLine; 'When' = $startTime }
    } 

    if ($historyItems -eq $null -or $historyItems.Count -eq 0) {
      Write-Host "The global (PSReadLine) history is empty."
      return 
    }
    $title = $title + " for All PowerShell Instances"
  }
  else {
    # Local history
    $history = Get-History | Sort-Object -Descending -Property Id | Select-Object @{Name = 'CommandLine'; Expression = { $_.CommandLine } } -Unique

    if ($history -eq $null -or $history.Count -eq 0) {
      Write-Host "The PowerShell history is empty."
      return 
    }
  }
  
  $selection = $history | Out-ConsoleGridView -OutputMode Single -Filter $Filter -Title $Title -Debug:$EnableDiagnostics UseNetDriver:$UseNetDriver

  [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()

  if ($selection.Count -gt 0) {
    $selection = $selection.'CommandLine'
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
}
else {
  $key = $args[0]["Key"]
}

# When F7 is pressed, show the local command line history in OCGV
$parameters = @{
  Chord             = $key
  BriefDescription = 'Show Matching Command History'
  Description  = 'Show Matching Command History using Out-ConsoleGridView'
  ScriptBlock      = {
    f7_history -Global $false
  }
}
Set-PSReadLineKeyHandler @parameters

if ($args.Count -eq 0 -or $null -eq $args[0]["AllKey"]) {
  $allkey = "Shift-F7"
}
else {
  $allkey = $args[0]["AllKey"]
}

# When Shift-F7 is pressed, show the local command line history in OCGV
$parameters = @{
  Chord              = $allkey
  BriefDescription = 'Show Matching Command History for All'
  Description  = 'Show Matching Command History for all PowerShell instances using Out-ConsoleGridView'
  ScriptBlock      = {
    f7_history -Global $true
  }
}
Set-PSReadLineKeyHandler @parameters