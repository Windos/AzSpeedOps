if (Get-Module -Name 'SpeedRun') {
    Remove-Module -Name 'SpeedRun'
}

if (Test-Path -Path "$PSScriptRoot/../SpeedRun") {
    Import-Module "$PSScriptRoot/../SpeedRun/SpeedRun.psd1" -Force
} else {
    Import-Module "$PSScriptRoot/../src/SpeedRun.psd1" -Force
}

Describe 'SpeedRun Module' {
    Context 'Import Correctly' {
        It 'should be a script module' {
            (Get-Module SpeedRun).ModuleType | Should -Be 'Script'
        }

        It 'should export two functions' {
            (Get-Command -Module SpeedRun).Count | Should -Be 2
        }
    }
}

Describe 'Get-NumberTrivia' {
    Context 'Standard Execution' {
        Mock Invoke-RestMethod { '8 is the number of planets in the Solar System.' } -ModuleName SpeedRun -ParameterFilter {
            $Method -eq 'Get'
            $Uri -eq 'http://numbersapi.com/random/trivia'
        }

        It 'returns expected string' {
            Get-NumberTrivia | Should -Be '8 is the number of planets in the Solar System.'
        }

        It 'called Invoke-RestMethod once' {
            Assert-MockCalled Invoke-RestMethod -Times 1 -ModuleName SpeedRun
        }
    }
}

Describe 'Measure-RandomNumbers' {
    Context 'Standard Execution' {
        Mock Get-RandomNumberOfNumbers { @(1, 2, 3, 4, 5) } -ModuleName SpeedRun

        It 'returns expected sum' {
            Measure-RandomNumbers -Sum | Should -Be 15
        }

        It 'returns expected average' {
            Measure-RandomNumbers -Average | Should -Be 3
        }

        It 'called Invoke-RestMethod once' {
            Measure-RandomNumbers
            Assert-MockCalled Get-RandomNumberOfNumbers -Times 1 -ModuleName SpeedRun -Scope It
        }
    }
}
