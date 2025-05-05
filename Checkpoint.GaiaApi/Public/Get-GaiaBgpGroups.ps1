function Get-GaiaBgpGroups {
    <#
    .SYNOPSIS
        Displays summary information for all configured peer groups.

    .DESCRIPTION
        Calls the 'show-bgp-groups' API and returns paging information along with
        summary details for each BGP group.

    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.

    .PARAMETER Limit
        Maximum number of results to return. Valid values are 1–200.
        Default is 50.

    .PARAMETER Offset
        Number of results to skip before starting to collect the results.
        Default is 0.

    .PARAMETER Order
        Sort order by AS number. Valid values are 'ASC' or 'DESC'.
        Default is 'ASC'.

    .PARAMETER MemberId
        (Optional) For multi-member gateways. When specified, the command
        executes on the given member.

    .EXAMPLE
        # Get up to 100 BGP groups in descending AS order
        Get-GaiaBgpGroups -Session $session -Limit 100 -Order DESC
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

    # Build request body
    $body = @{
        limit  = $Limit
        offset = $Offset
        order  = $Order
    }
    if ($MemberId) {
        $body.'member-id' = $MemberId
    }

    Write-Verbose "Calling show-bgp-groups (limit=$Limit, offset=$Offset, order=$Order)"

    try {
        $resp = Invoke-GaiaApi -Session $Session -Command 'show-bgp-groups' -Body $body
    }
    catch {
        Write-Error "Failed to retrieve BGP groups: $_"
        throw
    }

    # Map each group object
    $groups = $resp.objects | ForEach-Object {
        [PSCustomObject]@{
            As             = $_.'as'
            NumPeers       = $_.'num-peers'
            NumPeersEst    = $_.'num-peers-est'
            ProtocolList   = $_.'protocol-list'
            RouteReflector = $_.'route-reflector'
            Type           = $_.'type'
        }
    }

    # Return a wrapper object with paging + groups
    [PSCustomObject]@{
        From   = $resp.from
        To     = $resp.to
        Total  = $resp.total
        Groups = $groups
    }
}
