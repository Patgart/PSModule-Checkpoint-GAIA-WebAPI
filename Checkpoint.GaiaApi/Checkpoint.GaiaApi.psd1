@{
    # Script module or binary module file name
    RootModule        = 'Checkpoint.GaiaApi.psm1'

    # Version number of this module.
    ModuleVersion     = '0.0.3'

    # ID used to uniquely identify this module
    GUID              = '2ef225a9-057e-47ca-8a94-3b559091e0e7'

    Author            = 'Patrick Zander'
    Copyright         = '(c) 2025'
    Description       = 'PowerShell module for CheckPoint Gaia API.'
    PowerShellVersion = '5.1'
    RequiredModules   = @()

    # Functions to export
    FunctionsToExport = @(
        # Session Management
        'Connect-GaiaSession',
        'Disconnect-GaiaSession',
        # Diagnostics
        'Get-GaiaConnectionsPresets',
        'Get-GaiaConnections',
        'Get-GaiaTask',
        'Set-GaiaOpenTelemetry',
        'Get-GaiaOpenTelemetry',
        'Get-GaiaStatisticsInfo',
        'Get-GaiaStatistics',
        'Get-GaiaStatisticsViewInfo',
        # Authentication Servers
        'Get-GaiaRadius',
        'Set-GaiaRadius',
        'Get-GaiaTacacs',
        'Set-GaiaTacacs',
        'Get-GaiaAuthenticationOrder',
        'Set-GaiaAuthenticationOrder',
        # Allowed Clients
        'Get-GaiaAllowedClients',
        'Set-GaiaAllowedClients'
    )

    CmdletsToExport   = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags        = @('Checkpoint','Gaia','API','Authentication','AllowedClients')
            LicenseUri  = 'https://opensource.org/licenses/MIT'
            ProjectUri  = 'https://github.com/Patgart/PSModule-Checkpoint-GAIA-WebAPI'
            ReleaseNotes= 'Added Allowed Clients (show-allowed-clients, set-allowed-clients).'
        }
    }
}
