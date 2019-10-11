[CmdletBinding()]
param(
    [switch]
    $Publish
)

# Publish step
if ($Publish.IsPresent) {
    # Publish Module to PowerShell Gallery
    Try {
        $Splat = @{
            Path        = (Resolve-Path -Path $env:ArtifactDir\AzSpeedOps\AzSpeedOps)
            NuGetApiKey = $env:PSGallery
            ErrorAction = 'Stop'
        }
        Publish-Module @Splat

        Write-Output -InputObject ('AzSpeedOps PowerShell Module published to the PowerShell Gallery')
    } Catch {
        throw $_
    }
}
