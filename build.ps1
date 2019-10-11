[CmdletBinding()]
param(
    [switch]
    $Compile,

    [switch]
    $Test
)

# Compile step
if ($Compile.IsPresent) {
    if (Get-Module AzSpeedOps) {
        Remove-Module AzSpeedOps -Force
    }

    if ((Test-Path .\AzSpeedOps)) {
        Remove-Item -Path .\AzSpeedOps -Recurse -Force
    }

    if (-not (Test-Path .\AzSpeedOps)) {
        $null = New-Item -Path .\AzSpeedOps -ItemType Directory
    }

    Copy-Item -Path '.\src\*' -Filter '*.*' -Exclude '*.ps1', '*.psm1' -Destination .\AzSpeedOps -Force
    Remove-Item -Path .\AzSpeedOps\Private, .\AzSpeedOps\Public -Recurse -Force

    # Copy Module README file
    Copy-Item -Path '.\README.md' -Destination .\AzSpeedOps -Force

    Get-ChildItem -Path ".\src\Private\*.ps1" -Recurse | Get-Content | Add-Content .\AzSpeedOps\AzSpeedOps.psm1

    $Public  = @( Get-ChildItem -Path ".\src\Public\*.ps1" -ErrorAction SilentlyContinue )

    $Public | Get-Content | Add-Content .\AzSpeedOps\AzSpeedOps.psm1

    "`$PublicFunctions = '$($Public.BaseName -join "', '")'" | Add-Content .\AzSpeedOps\AzSpeedOps.psm1

    # Compress output, for GitHub release
    Compress-Archive -Path .\AzSpeedOps\* -DestinationPath .\AzSpeedOps.zip

    # Re-import module, extract release notes and version
    Import-Module .\AzSpeedOps\AzSpeedOps.psd1 -Force
    (Get-Module AzSpeedOps)[0].ReleaseNotes | Add-Content .\release-notes.txt
    (Get-Module AzSpeedOps)[0].Version.ToString() | Add-Content .\release-version.txt
}

# Test step
if($Test.IsPresent) {
    if (-not (Get-Module -Name Pester -ListAvailable) -or (Get-Module -Name Pester -ListAvailable)[0].Version -eq [Version]'3.4.0') {
        Write-Warning "Module 'Pester' is missing. Installing 'Pester' ..."
        Install-Module -Name Pester -Scope CurrentUser -Force
    }

    $Result = Invoke-Pester "./test" -OutputFormat NUnitXml -OutputFile TestResults.xml -PassThru

    if ($Result.FailedCount -gt 0) {
        throw "$($Result.FailedCount) tests failed."
    }
}
