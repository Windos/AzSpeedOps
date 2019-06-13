@{
    RootModule        = 'SpeedRun.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '42303cf2-7ea5-4ea0-bb18-c7897cc42e0b'
    Author            = 'Joshua (Windos) King'
    CompanyName       = 'ToastIT.dev'
    Copyright         = '(c) 2019 Joshua (Windos) King. All rights reserved.'
    Description       = 'Module for PS Power Hour demo.'
    PowerShellVersion = '5.0'
    FunctionsToExport = 'Get-NumberTrivia',
                        'Measure-RandomNumbers'
    CmdletsToExport   = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags         = @('Demo', 'PSPowerHour')
            LicenseUri   = 'https://github.com/Windos/SpeedRun/blob/master/LICENSE'
            ProjectUri   = 'https://github.com/Windos/SpeedRun'
            ReleaseNotes = '# 0.0.1

* Added new functions!
* Made sure module is super useful!
'
        }
    }
}
