
BeforeAll {
    Get-Location | Out-Host
    Get-Location | Out-Host
    Import-Module '..\Checkpoint.GaiaApi\Checkpoint.GaiaApi.psm1'
}

Describe 'Checkpoint.GaiaApi module' {

    Context 'Cmdlet availability' {
        $cmdLets = @(
            @{cmdLet = 'Connect-GaiaSession';}
            @{cmdLet = 'Disconnect-GaiaSession';}
            # Diagnostics
            @{cmdLet = 'Get-GaiaConnectionsPresets';}
            @{cmdLet = 'Get-GaiaConnections';}
            @{cmdLet = 'Get-GaiaTask';}
            @{cmdLet = 'Set-GaiaOpenTelemetry';}
            @{cmdLet = 'Get-GaiaOpenTelemetry';}
            @{cmdLet = 'Get-GaiaStatisticsInfo';}
            @{cmdLet = 'Get-GaiaStatistics';}
            @{cmdLet = 'Get-GaiaStatisticsViewInfo';}
            # Authentication servers
            @{cmdLet = 'Get-GaiaRadius';}
            @{cmdLet = 'Set-GaiaRadius';}
            @{cmdLet = 'Get-GaiaTacacs';}
            @{cmdLet = 'Set-GaiaTacacs';}
            @{cmdLet = 'Get-GaiaAuthenticationOrder';}
            @{cmdLet = 'Set-GaiaAuthenticationOrder';}
            # Allowed Clients
            @{cmdLet = 'Get-GaiaAllowedClients';}
            @{cmdLet = 'Set-GaiaAllowedClients;'}
        )
        foreach ($cmdLet in $cmdLets) {
            It "Testing for cmdlet <cmdlet>" -ForEach $cmdLets {
                Get-Command -Name $cmdLet -ErrorAction Stop | Should -Not -BeNullOrEmpty
            }
        }
    }
}