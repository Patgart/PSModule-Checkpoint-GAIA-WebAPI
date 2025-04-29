function Set-GaiaOpenTelemetry {
    <#
    .SYNOPSIS
        Configures OpenTelemetry export targets and/or enables telemetry.

    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.

    .PARAMETER Enabled
        $true to enable, $false to disable.

    .PARAMETER ExportTargets
        Hashtable matching the API structure for 'export-targets' (add/remove/etc.).

    .EXAMPLE
        $targets = @{ add = @(@{ type='prometheus-remote-write'; url='https://...'; enabled=$true }) }
        Set-GaiaOpenTelemetry -Session $session -Enabled $true -ExportTargets $targets
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter(Mandatory=$true)]
        [bool]$Enabled,

        [Parameter()]
        [hashtable]$ExportTargets
    )

    $body = @{ enabled = $Enabled }
    if ($ExportTargets) { $body.'export-targets' = $ExportTargets }

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-open-telemetry' -Body $body

    [PSCustomObject]@{
        Enabled       = $resp.enabled
        ExportTargets = $resp.'export-targets'
        Warnings      = $resp.warnings
    }
}
