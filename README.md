# Checkpoint.GaiaApi

PowerShell module wrapping the CheckPoint Gaia REST API.

## Installation

```powershell
Install-Module -Name Checkpoint.GaiaApi
```

## Usage

### 1. Connect
```powershell
$session = Connect-GaiaSession -Server 'fw.example.com' `
                               -Username 'admin' `
                               -PlainPassword 'P@ssw0rd'
```

### 2. Diagnostics
```powershell
Get-GaiaConnectionsPresets -Session $session
$task = Get-GaiaConnections -Session $session -MaxResults 100 -Filter @{ source='1.2.3.4' }
Get-GaiaTask -Session $session -TaskId $task.TaskId
```

#### Telemetry
```powershell
Get-GaiaOpenTelemetry -Session $session
Set-GaiaOpenTelemetry -Session $session -Enabled $true -ExportTargets @{
  add = @(@{ type='prometheus-remote-write'; url='https://...' ; enabled=$true })
}
```

#### CPView statistics
```powershell
Get-GaiaStatisticsInfo -Session $session -Filter 'UM_STAT.UM_CPU.num_of_cores'
Get-GaiaStatistics -Session $session -Filter 'fw.policy.last_install_time' -IgnoreWarnings $true
Get-GaiaStatisticsViewInfo -Session $session -Filter 'CPVIEW.Hardware-Health'
```

### 3. Disconnect
```powershell
Disconnect-GaiaSession -Session $session
```