function Get-GaiaBgpErrors {
    <#
    .SYNOPSIS
        Displays any BGP error notifications received from connected peers.

    .DESCRIPTION
        Calls the 'show-bgp-errors' API and returns paging information along with
        detailed error notifications for each peer.

    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.

    .PARAMETER Limit
        Maximum number of results to return. Valid values are 1–200.
        Default is 50.

    .PARAMETER Offset
        Number of results to skip before starting to collect the results.
        Default is 0.

    .PARAMETER Order
        Sort order by peer IP. Valid values are 'ASC' or 'DESC'.
        Default is 'ASC'.

    .PARAMETER MemberId
        (Optional) For multi-member gateways. When specified, the command
        executes on the given member.

    .EXAMPLE
        # Get up to 100 BGP errors in descending peer order
        Get-GaiaBgpErrors -Session $session -Limit 100 -Order DESC
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

    Write-Verbose "Calling show-bgp-errors (limit=$Limit, offset=$Offset, order=$Order)"

    try {
        $resp = Invoke-GaiaApi -Session $Session -Command 'show-bgp-errors' -Body $body
    }
    catch {
        Write-Error "Failed to retrieve BGP errors: $_"
        throw
    }

    # Map each error object
    $errors = $resp.objects | ForEach-Object {
        [PSCustomObject]@{
            Peer      = $_.peer
            LastError = $_.'last-error'
            LastEvent = $_.'last-event'
            LastState = $_.'last-state'
        }
    }

    # Return a wrapper object with paging + errors
    [PSCustomObject]@{
        From   = $resp.from
        To     = $resp.to
        Total  = $resp.total
        Errors = $errors
    }
}
