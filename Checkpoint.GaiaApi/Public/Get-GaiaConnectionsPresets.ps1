function Get-GaiaConnectionsPresets {
    <#
    .SYNOPSIS
        Retrieves available presets for show-connections.

    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.

    .PARAMETER MemberId
        (Optional) For multi-member gateways.

    .EXAMPLE
        Get-GaiaConnectionsPresets -Session $session
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [string]$MemberId
    )

    $body = @{}
    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-connections-presets' -Body $body

    $resp.presets | ForEach-Object {
        [PSCustomObject]@{
            Name        = $_.name
            Description = $_.description
        }
    }
}
