function Get-GaiaBgpPaths {
    <#
    .SYNOPSIS
        Displays information regarding BGP Autonomous System paths.
    .DESCRIPTION
        Calls 'show-bgp-paths' API and returns AS path details with paging metadata.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER Limit
        Maximum number of results to return (1–200). Default is 50.
    .PARAMETER Offset
        Number of results to skip. Default is 0.
    .PARAMETER Order
        Sort order: 'ASC' or 'DESC'. Default is 'ASC'.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Get-GaiaBgpPaths -Session $session -Limit 100 -Offset 0 -Order 'DESC'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Session,

        [Parameter()]
        [ValidateRange(1, 200)]
        [int]$Limit = 50,

        [Parameter()]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Offset = 0,

        [Parameter()]
        [ValidateSet('ASC', 'DESC')]
        [string]$Order = 'ASC',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $body = @{
        limit  = $Limit
        offset = $Offset
        order  = $Order
    }
    if ($MemberId) {
        $body.'member-id' = $MemberId
    }

    Write-Verbose "Invoking show-bgp-paths with body: $($body | ConvertTo-Json -Depth 3)"

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-bgp-paths' -Body $body

    $paths = $resp.objects | ForEach-Object {
        [PSCustomObject]@{
            PathName       = $_.'path-name'
            NextHop        = $_.nexthop
            LocalAs        = $_.'local-as'
            NeighborAs     = $_.'neighbor-as'
            ReferenceCount = [int]$.'reference-count'
            AsNum          = [int]$.'as-num'
            Segments       = [int]$segments
            Overhead       = [int]$overhead
            AggregatorId   = $_.'aggregator-id'
            AggregatorAs   = $_.'aggregator-as'
        }
    }

    [PSCustomObject]@{
        From     = [int]$resp.from
        To       = [int]$resp.to
        Total    = [int]$resp.total
        MemberId = $resp.'member-id'
        Paths    = $paths
    }
}