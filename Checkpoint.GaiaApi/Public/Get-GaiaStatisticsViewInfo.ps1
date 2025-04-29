function Get-GaiaStatisticsViewInfo {
    <#
    .SYNOPSIS
        Shows CPView view specifications.

    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.

    .PARAMETER Filter
        Array of view-IDs to filter.

    .PARAMETER MemberId
        (Optional) For multi-member gateways.

    .EXAMPLE
        Get-GaiaStatisticsViewInfo -Session $session -Filter 'CPVIEW.Hardware-Health'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [string[]]$Filter,

        [string]$MemberId
    )

    $body = @{}
    if ($Filter)   { $body.filter = $Filter }
    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-statistics-view-info' -Body $body

    $resp.views | ForEach-Object {
        [PSCustomObject]@{
            ViewId      = $_.'view-id'
            Name        = $_.name
            Description = $_.description
            Parent      = $_.parent
            Children    = $_.children
            StatIds     = $_.'stat-id'
        }
    }
}
