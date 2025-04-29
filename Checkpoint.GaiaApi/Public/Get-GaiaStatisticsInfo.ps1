function Get-GaiaStatisticsInfo {
    <#
    .SYNOPSIS
        Shows CPView statistics specifications.

    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.

    .PARAMETER Filter
        Array of stat-id or label filters.

    .PARAMETER MemberId
        (Optional) For multi-member gateways.

    .EXAMPLE
        Get-GaiaStatisticsInfo -Session $session -Filter 'UM_STAT.UM_CPU.num_of_cores'
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-statistics-info' -Body $body

    $resp.stats | ForEach-Object {
        [PSCustomObject]@{
            Name              = $_.name
            StatId            = $_.'stat-id'
            Description       = $_.description
            Type              = $_.type
            Labels            = $_.labels
            MaximumRowNumber  = $_.'maximum-row-number'
            TableColumns      = $_.'table-columns'
        }
    }
}
