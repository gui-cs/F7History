################################################################################
# f7_history -Global $true | $false -Diagnostic -UseNetDriver
################################################################################
function f7_history {
  param(
    [parameter(Mandatory = $true)]
    [Boolean]
    $global,
    [parameter(Mandatory = $false)]
    [System.Management.Automation.SwitchParameter]
    $Diagnostic,
    [parameter(Mandatory = $false)]
    [System.Management.Automation.SwitchParameter]
    $UseNetDriver
  )

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

  $title = "Command History"

  if ($global) {
    # Global history
    Write-Progress -Activity "Getting global (PSReadLine) command history" -PercentComplete -1
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
      $startTime = if ($null -ne $_.StartTime  -and $_.StartTime -ne [datetime]::MinValue) { $_.StartTime.ToLocalTime() } else { $null }
      [PSCustomObject]@{ 'CommandLine' = $_.CommandLine; 'When' = $startTime }
    }

    if ($null -eq $historyItems -or $historyItems.Count -eq 0) {
      Write-Output "The global (PSReadLine) history is empty."
      return
    }
    $title = $title + " for All PowerShell Instances"
  }
  else {
    # Local history
    $history = Get-History | Sort-Object -Descending -Property Id | Select-Object @{Name = 'CommandLine'; Expression = { $_.CommandLine } } -Unique

    if ($null -eq $history -or $history.Count -eq 0) {
      Write-Output "The PowerShell history is empty."
      return
    }
  }

  # Invoke OCGV to show the history
  $params = @{
    OutputMode = "Single"
    Title      = $Title
    Filter     = $line
  }

  if ($Diagnostic.IsPresent) { $params["Debug"] = $true }
  if ($UseNetDriver.IsPresent) { $params["UseNetDriver"] = $true }
  $selection = $history | Out-ConsoleGridView @params

  if ($global) {
    Write-Progress -Activity "Launching `Out-ConsoleGridView" -Completed
  }

  # Delete the current line and insert the selected line
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

# Set the PSReadLine key handlers for F7 and Shift-F7

# When F7 is pressed, show the local command line history in OCGV
$parameters = @{
  Chord            = if ($args.Count -eq 0 -or $null -eq $args[0]["Key"]) { "F7" } else { $args[0]["Key"] }
  BriefDescription = 'Show Matching Command History'
  Description      = 'Show Matching Command History using Out-ConsoleGridView'
  ScriptBlock      = {
    $params = @{ Global = $false }
    if ($F7Diagnostic) { $params["Diagnostic"] = $true }
    if ($F7UseNetDriver) { $params["UseNetDriver"] = $true }
    f7_history @params
  }
}
Set-PSReadLineKeyHandler @parameters

# When Shift-F7 is pressed, show the global command line history in OCGV
$parameters = @{
  Chord            = if ($args.Count -eq 0 -or $null -eq $args[0]["AllKey"]) { "Shift-F7" } else { $args[0]["AllKey"] }
  BriefDescription = 'Show Matching Command History for All'
  Description      = 'Show Matching Command History for all PowerShell instances using Out-ConsoleGridView'
  ScriptBlock      = {
    $params = @{ Global = $true }
    if ($F7Diagnostic) { $params["Diagnostic"] = $true }
    if ($F7UseNetDriver) { $params["UseNetDriver"] = $true }
    f7_history @params
  }
}
Set-PSReadLineKeyHandler @parameters