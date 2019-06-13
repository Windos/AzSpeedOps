@{
    RootModule        = 'AzSpeedOps.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = 'e79f270e-4bfa-4619-9a59-193b4178cbe3'
    Author            = 'Joshua (Windos) King'
    CompanyName       = 'ToastIT.dev'
    Copyright         = '(c) 2019 Joshua (Windos) King. All rights reserved.'
    Description       = 'Demo Module for Azure Pipelines Speed Run during PS Power Hour.'
    PowerShellVersion = '5.0'
    FunctionsToExport = 'Get-NumberTrivia',
                        'Measure-RandomNumbers'
    CmdletsToExport   = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags         = @('Demo', 'PSPowerHour')
            LicenseUri   = 'https://github.com/Windos/AzSpeedOps/blob/master/LICENSE'
            ProjectUri   = 'https://github.com/Windos/AzSpeedOps'
            ReleaseNotes = '# 0.0.1

* Added new functions!
* Made sure module is super useful!
'
        }
    }
}
