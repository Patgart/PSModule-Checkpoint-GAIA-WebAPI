function Get-GaiaOpenTelemetry {
    <#
    .SYNOPSIS
        Retrieves current OpenTelemetry configuration.

    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.

    .PARAMETER MemberId
        (Optional) For multi-member gateways.

    .EXAMPLE
        Get-GaiaOpenTelemetry -Session $session
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [string]$MemberId
    )

    $body = @{}
    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-open-telemetry' -Body $body

    [PSCustomObject]@{
        Enabled       = $resp.enabled
        ExportTargets = $resp.'export-targets'
        Warnings      = $resp.warnings
    }
}
