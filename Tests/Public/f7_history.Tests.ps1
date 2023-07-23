BeforeAll {
    Write-Host "BeforeAll - Importing F7History"
    Import-Module F7History
}

Describe "f7_history" {
    Context "The f7_history function" {
        $cmd = $null
        try {
            $cmd = get-item -path Function:\f7_history

        } catch {
            $cmd = $null
        }
        
        It "is defined" {
            $cmd | Should -Be "f7_history"
        }
    }

    Context "The f7_history function" {
        $parameters = (Get-Command f7_history).Parameters
        It "has a required string parameter for the global flag" {
            $parameters.ContainsKey("global") | Should -Be $true
            $parameters["global"].ParameterType | Should -Be ([boolean])
            $parameters["global"].Attributes.Where{$_ -is [Parameter]}.Mandatory | Should -Be $true
        }
    }

    Context "Default key bindings" {
        $Result = (Get-PSReadLineKeyHandler -Chord F7).Function
        It "defines F7 as the default key binding" {
            $Result | Should -Be "Show Matching Command History"
        }

        $Result = (Get-PSReadLineKeyHandler -Chord Shift-F7).Function
        It "defines Shift-F7 as the default key binding" {
            $Result | Should -Be "Show Matching Command History for All"
        }
    }
}
