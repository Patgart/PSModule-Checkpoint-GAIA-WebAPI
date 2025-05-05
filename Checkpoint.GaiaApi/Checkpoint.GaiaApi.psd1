@{
    # Script module or binary module file name
    RootModule        = 'Checkpoint.GaiaApi.psm1'

    # Version number of this module.
    ModuleVersion     = '0.0.5'

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
        'Set-GaiaAllowedClients',
        # Network Management
        'Get-GaiaArp',
        'Set-GaiaArp',
        'Get-GaiaDhcp6Config',
        'Set-GaiaDhcp6Config',
        'Get-GaiaDhcp6Server',
        'Set-GaiaDhcp6Server',
        'Get-GaiaDhcpServer',
        'Set-GaiaDhcpServer',
        'Get-GaiaDns',
        'Set-GaiaDns',
        'Get-GaiaNtp',
        'Set-GaiaNtp',
        'Get-GaiaTimeAndDate',
        'Set-GaiaTimeAndDate',
        'Get-GaiaTimezones',
        'Get-GaiaProxy',
        'Set-GaiaProxy',
        'Remove-GaiaProxy',
        # Networking
        'Get-GaiaBgpErrors',
        'Get-GaiaBgpGroups',
        'Get-GaiaBgpPaths',
        'Get-GaiaBgpPeer',
        'Get-GaiaBgpPeers',
        'Get-GaiaBgpRouteIn',
        'Get-GaiaBgpRoutesIn',
        'Get-GaiaBgpRouteOut',
        'Get-GaiaBgpRoutesOut',
        'Get-GaiaBgpRoutemaps',
        'Get-GaiaBgpStats',
        'Get-GaiaBgpSummary',
        'Get-GaiaBgpConfiguration',
        'Get-GaiaBgpConfigurationInternal',
        'Get-GaiaBgpConfigurationInternalPeers',
        'Get-GaiaBgpConfigurationInternalPeer',
        'Get-GaiaBgpConfigurationExternal',
        'Get-GaiaBgpConfigurationExternalPeers',
        'Get-GaiaBgpConfigurationExternalPeer',
        'Get-GaiaBgpConfigurationConfederation',
        'Get-GaiaBgpConfigurationConfederationPeers',
        'Get-GaiaBgpConfigurationConfederationPeer',
        'Set-GaiaBgp',
        'Set-GaiaBgpInternal',
        'Add-GaiaBgpInternalPeer',
        'Set-GaiaBgpInternalPeer',
        'Remove-GaiaBgpInternalPeer',
        'Set-GaiaBgpExternal',
        'Add-GaiaBgpExternalPeer',
        'Set-GaiaBgpExternalPeer',
        'Remove-GaiaBgpExternalPeer',
        'Set-GaiaBgpConfederation',
        'Add-GaiaBgpConfederationPeer',
        'Set-GaiaBgpConfederationPeer',
        'Remove-GaiaBgpConfederationPeer'
        'Remove-GaiaProxy',
        'Remove-GaiaStaticRoute',
        'Set-GaiaStaticRoute',
        'Set-GaiaStaticRouteNextHopPriority',
        'Get-GaiaStaticRoute',
        'Get-GaiaStaticRoutes'
    )

    CmdletsToExport   = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags        = @(
                'Checkpoint','Gaia','API',
                'Network','ARP','DHCP','DHCPv6',
                'DNS','NTP','Time','Proxy'
            )
            LicenseUri  = 'https://opensource.org/licenses/MIT'
            ProjectUri  = 'https://github.com/Patgart/PSModule-Checkpoint-GAIA-WebAPI'
            ReleaseNotes= 'Added DNS, NTP, Time/Date, Timezones, Proxy cmdlets.'
        }
    }
}
