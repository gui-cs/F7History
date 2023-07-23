#requires -Module F7History
Describe "f7_history" {
    Context "Parameter Binding" {
        $Parameters = (Get-Command f7_history).Parameters
        It "has a required string parameter for the global flag" {
            $parameters.ContainsKey("global") | Should -Be $true
            $parameters["global"].ParameterType | Should -Be ([string])
            $parameters["global"].Attributes.Where{$_ -is [Parameter]}.Mandatory | Should -Be $true
        }
    }
}