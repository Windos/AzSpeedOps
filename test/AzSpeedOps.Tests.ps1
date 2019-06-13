if (Get-Module -Name 'AzSpeedOps') {
    Remove-Module -Name 'AzSpeedOps'
}

if (Test-Path -Path "$PSScriptRoot/../AzSpeedOps") {
    Import-Module "$PSScriptRoot/../AzSpeedOps/AzSpeedOps.psd1" -Force
} else {
    Import-Module "$PSScriptRoot/../src/AzSpeedOps.psd1" -Force
}

Describe 'AzSpeedOps Module' {
    Context 'Import Correctly' {
        It 'should be a script module' {
            (Get-Module AzSpeedOps).ModuleType | Should -Be 'Script'
        }

        It 'should export two functions' {
            (Get-Command -Module AzSpeedOps).Count | Should -Be 2
        }
    }
}

Describe 'Get-NumberTrivia' {
    Context 'Standard Execution' {
        Mock Invoke-RestMethod { '8 is the number of planets in the Solar System.' } -ModuleName AzSpeedOps -ParameterFilter {
            $Method -eq 'Get'
            $Uri -eq 'http://numbersapi.com/random/trivia'
        }

        It 'returns expected string' {
            Get-NumberTrivia | Should -Be '8 is the number of planets in the Solar System.'
        }

        It 'called Invoke-RestMethod once' {
            Assert-MockCalled Invoke-RestMethod -Times 1 -ModuleName AzSpeedOps
        }
    }
}

Describe 'Measure-RandomNumbers' {
    Context 'Standard Execution' {
        Mock Get-RandomNumberOfNumbers { @(1, 2, 3, 4, 5) } -ModuleName AzSpeedOps

        It 'returns expected sum' {
            Measure-RandomNumbers -Sum | Should -Be 15
        }

        It 'returns expected average' {
            Measure-RandomNumbers -Average | Should -Be 3
        }

        It 'called Invoke-RestMethod once' {
            Measure-RandomNumbers
            Assert-MockCalled Get-RandomNumberOfNumbers -Times 1 -ModuleName AzSpeedOps -Scope It
        }
    }
}
