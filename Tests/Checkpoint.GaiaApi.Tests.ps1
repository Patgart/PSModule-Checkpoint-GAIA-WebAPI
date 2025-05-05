BeforeAll {
    $ImportPath = (Join-Path (Get-Location).Path '\Checkpoint.GaiaApi\Checkpoint.GaiaApi.psm1')
    Write-Output "Importing module from $ImportPath"
    Import-Module $ImportPath -ErrorAction Stop
}

Describe 'Checkpoint.GaiaApi module' {
    Context 'Module availability' {
        It "Testing for module Checkpoint.GaiaApi" {
            Get-Module Checkpoint.GaiaApi -ErrorAction Stop | Should -Not -BeNullOrEmpty
        }
    }
    Context 'Cmdlet availability' {
        $cmdLets = @(
            @{cmdLet = 'Connect-GaiaSession';},
            @{cmdLet = 'Disconnect-GaiaSession';},
            # Diagnostics
            @{cmdLet = 'Get-GaiaConnectionsPresets';},
            @{cmdLet = 'Get-GaiaConnections';},
            @{cmdLet = 'Get-GaiaTask';},
            @{cmdLet = 'Set-GaiaOpenTelemetry';},
            @{cmdLet = 'Get-GaiaOpenTelemetry';},
            @{cmdLet = 'Get-GaiaStatisticsInfo';},
            @{cmdLet = 'Get-GaiaStatistics';},
            @{cmdLet = 'Get-GaiaStatisticsViewInfo';},
            # Authentication servers
            @{cmdLet = 'Get-GaiaRadius';},
            @{cmdLet = 'Set-GaiaRadius';},
            @{cmdLet = 'Get-GaiaTacacs';},
            @{cmdLet = 'Set-GaiaTacacs';},
            @{cmdLet = 'Get-GaiaAuthenticationOrder';},
            @{cmdLet = 'Set-GaiaAuthenticationOrder';},
            # Allowed Clients
            @{cmdLet = 'Get-GaiaAllowedClients';},
            @{cmdLet = 'Set-GaiaAllowedClients';},
            # Network Management
            @{cmdLet = 'Get-GaiaArp';},
            @{cmdLet = 'Set-GaiaArp';},
            @{cmdLet = 'Get-GaiaDhcp6Config';},
            @{cmdLet = 'Set-GaiaDhcp6Config';},
            @{cmdLet = 'Get-GaiaDhcp6Server';},
            @{cmdLet = 'Set-GaiaDhcp6Server';},
            @{cmdLet = 'Get-GaiaDhcpServer';},
            @{cmdLet = 'Set-GaiaDhcpServer';},
            @{cmdLet = 'Get-GaiaDns';},
            @{cmdLet = 'Set-GaiaDns';},
            @{cmdLet = 'Get-GaiaNtp';},
            @{cmdLet = 'Set-GaiaNtp';},
            @{cmdLet = 'Get-GaiaTimeAndDate';},
            @{cmdLet = 'Set-GaiaTimeAndDate';},
            @{cmdLet = 'Get-GaiaTimezones';},
            @{cmdLet = 'Get-GaiaProxy';},
            @{cmdLet = 'Set-GaiaProxy';},
            @{cmdLet = 'Remove-GaiaProxy';},
            # Networking
            @{cmdLet = 'Get-GaiaBgpErrors';},
            @{cmdLet = 'Get-GaiaBgpGroups';},
            @{cmdLet = 'Get-GaiaBgpPaths';},
            @{cmdLet = 'Get-GaiaBgpPeer';},
            @{cmdLet = 'Get-GaiaBgpPeers';},
            @{cmdLet = 'Get-GaiaBgpRouteIn';},
            @{cmdLet = 'Get-GaiaBgpRoutesIn';},
            @{cmdLet = 'Get-GaiaBgpRouteOut';},
            @{cmdLet = 'Get-GaiaBgpRoutesOut';},
            @{cmdLet = 'Get-GaiaBgpRoutemaps';},
            @{cmdLet = 'Get-GaiaBgpStats';},
            @{cmdLet = 'Get-GaiaBgpSummary';},
            @{cmdLet = 'Get-GaiaBgpConfiguration';},
            @{cmdLet = 'Get-GaiaBgpConfigurationInternal';},
            @{cmdLet = 'Get-GaiaBgpConfigurationInternalPeers';},
            @{cmdLet = 'Get-GaiaBgpConfigurationInternalPeer';},
            @{cmdLet = 'Get-GaiaBgpConfigurationExternal';},
            @{cmdLet = 'Get-GaiaBgpConfigurationExternalPeers';},
            @{cmdLet = 'Get-GaiaBgpConfigurationExternalPeer';},
            @{cmdLet = 'Get-GaiaBgpConfigurationConfederation';},
            @{cmdLet = 'Get-GaiaBgpConfigurationConfederationPeers';},
            @{cmdLet = 'Get-GaiaBgpConfigurationConfederationPeer';},
            @{cmdLet = 'Set-GaiaBgp';},
            @{cmdLet = 'Set-GaiaBgpInternal';},
            @{cmdLet = 'Add-GaiaBgpInternalPeer';},
            @{cmdLet = 'Set-GaiaBgpInternalPeer';},
            @{cmdLet = 'Remove-GaiaBgpInternalPeer';},
            @{cmdLet = 'Set-GaiaBgpExternal';},
            @{cmdLet = 'Add-GaiaBgpExternalPeer';},
            @{cmdLet = 'Set-GaiaBgpExternalPeer';},
            @{cmdLet = 'Remove-GaiaBgpExternalPeer';},
            @{cmdLet = 'Set-GaiaBgpConfederation';},
            @{cmdLet = 'Add-GaiaBgpConfederationPeer';},
            @{cmdLet = 'Set-GaiaBgpConfederationPeer';},
            @{cmdLet = 'Remove-GaiaBgpConfederationPeer';},
            @{cmdLet = 'Remove-GaiaStaticRoute';},
            @{cmdLet = 'Set-GaiaStaticRoute';},
            @{cmdLet = 'Set-GaiaStaticRouteNextHopPriority';},
            @{cmdLet = 'Get-GaiaStaticRoute';},
            @{cmdLet = 'Get-GaiaStaticRoutes';}
        )
        It "Testing for cmdlet <cmdlet>" -ForEach $cmdLets {
            Get-Command -Name $cmdLet -ErrorAction Stop | Should -Not -BeNullOrEmpty
        }
    }
}
