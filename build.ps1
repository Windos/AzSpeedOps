[CmdletBinding()]
param(
    [switch]
    $Compile,

    [switch]
    $Test
)

# Compile step
if ($Compile.IsPresent) {
    if (Get-Module SpeedRun) {
        Remove-Module SpeedRun -Force
    }

    if ((Test-Path .\SpeedRun)) {
        Remove-Item -Path .\SpeedRun -Recurse -Force
    }

    if (-not (Test-Path .\SpeedRun)) {
        $null = New-Item -Path .\SpeedRun -ItemType Directory
    }

    Copy-Item -Path '.\src\*' -Filter '*.*' -Exclude '*.ps1', '*.psm1' -Destination .\SpeedRun -Force
    Remove-Item -Path .\SpeedRun\Private, .\SpeedRun\Public -Recurse -Force

    # Copy Module README file
    Copy-Item -Path '.\README.md' -Destination .\SpeedRun -Force

    Get-ChildItem -Path ".\src\Private\*.ps1" -Recurse | Get-Content | Add-Content .\SpeedRun\SpeedRun.psm1

    $Public  = @( Get-ChildItem -Path ".\src\Public\*.ps1" -ErrorAction SilentlyContinue )

    $Public | Get-Content | Add-Content .\SpeedRun\SpeedRun.psm1

    "`$PublicFunctions = '$($Public.BaseName -join "', '")'" | Add-Content .\SpeedRun\SpeedRun.psm1

    # Compress output, for GitHub release
    Compress-Archive -Path .\SpeedRun\* -DestinationPath .\SpeedRun.zip

    # Re-import module, extract release notes and version
    Import-Module .\SpeedRun\SpeedRun.psd1 -Force
    (Get-Module SpeedRun)[0].ReleaseNotes | Add-Content .\release-notes.txt
    (Get-Module SpeedRun)[0].Version.ToString() | Add-Content .\release-version.txt
}

# Test step
if($Test.IsPresent) {
    if (-not (Get-Module -Name Pester -ListAvailable) -or (Get-Module -Name Pester -ListAvailable)[0].Version -eq [Version]'3.4.0') {
        Write-Warning "Module 'Pester' is missing. Installing 'Pester' ..."
        Install-Module -Name Pester -Scope CurrentUser -Force
    }

    $Result = Invoke-Pester "./test" -OutputFormat NUnitXml -OutputFile TestResults.xml -PassThru

    if ($Result.FailedCount -gt 0) {
        throw "$($res.FailedCount) tests failed."
    }
}
