function Get-GaiaConnections {
    <#
    .SYNOPSIS
        Starts a show-connections task and returns its task-id.

    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.

    .PARAMETER MaxResults
        Max number to retrieve or 'all'. Default = 10.

    .PARAMETER UsePreset
        Switch to use presets.

    .PARAMETER Preset
        Array of preset names to apply.

    .PARAMETER Filter
        Hashtable of filter criteria (e.g. @{ source='1.2.3.4' }).

    .PARAMETER MemberId
        (Optional) For multi-member gateways.

    .EXAMPLE
        Get-GaiaConnections -Session $session -MaxResults 50 -Filter @{ source='1.2.3.4' }
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $_ -is [int] -or $_ -eq 'all' })]
        [Parameter()]
        [object]$MaxResults = 10,

        [Parameter()]
        [bool]$UsePreset,

        [Parameter()]
        [string[]]$Preset,

        [Parameter()]
        [hashtable]$Filter,

        [string]$MemberId
    )

    $body = @{}
    if ($MaxResults -eq 'all') { $body.'max-results' = 'all' }
    elseif ($MaxResults)       { $body.'max-results' = [int]$MaxResults }
    if ($UsePreset)            { $body.'use-preset' = $true }
    if ($Preset)               { $body.preset = $Preset }
    if ($Filter)               { $body.filter = $Filter }
    if ($MemberId)             { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-connections' -Body $body

    [PSCustomObject]@{ TaskId = $resp.'task-id' }
}
