################################################################################
# ocgv_history -Global $true | $false
#
# Uses Out-ConsoleGridView to display either the local or global command history
# If an item is selected in OCGV, it will be returned as output and placed on 
# the command line.
# 
# Anything on the command line when this function is executed will be used as the 
# -Filter for OCGV. E.g. to search the command line for all commands starting 
# with "git", type "git" on the command line and press F7 or Shift-F7.
#
# Run this script from your Powershell Profile
#
# See https://github.com/gui-cs/F7History
# 
function ocgv_history {
  param(
    [parameter(Mandatory=$true)]
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
    $selection = $history | Select-Object -Unique | Out-ConsoleGridView -OutputMode Single -Filter $line -Title "Global Command Line History"

  } else {
    # Local history
    $history = Get-History | Sort-Object -Descending -Property Id -Unique | Select-Object CommandLine -ExpandProperty CommandLine 
    $selection = $history | Out-ConsoleGridView -OutputMode Single -Filter $line -Title "Command Line History"
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

# When F7 is pressed, show the local command line history in OCGV
$parameters = @{
  Key = 'F7'
  BriefDescription = 'Show Matching History'
  LongDescription = 'Show Matching History using Out-ConsoleGridView'
  ScriptBlock = {
    ocgv_history -Global $false 
  }
}
Set-PSReadLineKeyHandler @parameters

# When Shift-F7 is pressed, show the local command line history in OCGV
$parameters = @{
  Key = 'Shift-F7'
  BriefDescription = 'Show Matching Global History'
  LongDescription = 'Show Matching History for all PowerShell instances using Out-ConsoleGridView'
  ScriptBlock = {
    ocgv_history -Global $true
  }
}
Set-PSReadLineKeyHandler @parameters
