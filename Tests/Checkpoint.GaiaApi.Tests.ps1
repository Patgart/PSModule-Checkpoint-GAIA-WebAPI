Import-Module (Join-Path $PSScriptRoot '..\Checkpoint.GaiaApi\Checkpoint.GaiaApi.psm1')

Describe 'Checkpoint.GaiaApi module' {

    Context 'Cmdlet availability' {
        $cmdLets = @(
            'Connect-GaiaSession',
            'Disconnect-GaiaSession',
            'Get-GaiaConnectionsPresets',
            'Get-GaiaConnections',
            'Get-GaiaTask',
            'Set-GaiaOpenTelemetry',
            'Get-GaiaOpenTelemetry',
            'Get-GaiaStatisticsInfo',
            'Get-GaiaStatistics',
            'Get-GaiaStatisticsViewInfo',
            # New authentication servers
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
        foreach ($cmdLet in $cmdLets) {
            It "$cmdLet is available" {
                Get-Command $cmdLet -ErrorAction Stop | Should -Not -BeNullOrEmpty
            }
        }
    }

    Context 'Parameter validation' {
        It 'Get-GaiaAllowedClients throws without Session' {
            { Get-GaiaAllowedClients } | Should -Throw
        }
        It 'Set-GaiaAllowedClients throws without Session' {
            { Set-GaiaAllowedClients } | Should -Throw
        }

        It 'Set-GaiaAllowedClients requires at least one action parameter' {
            $session = [PSCustomObject]@{ sid='fake'; Url='https://x'; WebApiVersion='1.8' }
            { Set-GaiaAllowedClients -Session $session } | Should -Throw
        }
    }
}