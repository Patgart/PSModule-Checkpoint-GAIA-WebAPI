function Get-GaiaStaticRoute {
    <#
    .SYNOPSIS
        Retrieves the configuration of a single static route.

    .DESCRIPTION
        Calls the Gaia API 'show-static-route' to fetch details about a specific
        IPv4 static route.

    .PARAMETER Session
        The GaiaSession object from Connect-GaiaSession.

    .PARAMETER Address
        The destination network address, e.g. '1.2.3.0'.

    .PARAMETER MaskLength
        The network prefix length (0–32).

    .PARAMETER MemberId
        (Optional) Scalable/Elastic XL member ID.

    .PARAMETER VirtualSystemId
        (Optional) Virtual System ID, relevant for VSNext setups.

    .EXAMPLE
        Get-GaiaStaticRoute -Session $s -Address '1.2.3.0' -MaskLength 24
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Address,

        [Parameter(Mandatory=$true)]
        [ValidateRange(0,32)]
        [int]$MaskLength,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId,

        [Parameter()]
        [int]$VirtualSystemId
    )

    $body = @{
        address       = $Address
        'mask-length'   = $MaskLength
    }
    if ($PSBoundParameters.ContainsKey('MemberId'))       { $body.'member-id'         = $MemberId }
    if ($PSBoundParameters.ContainsKey('VirtualSystemId')) { $body.'virtual-system-id' = $VirtualSystemId }

    Write-Verbose "Fetching static route $Address/$MaskLength"
    $resp = Invoke-GaiaApi -Session $Session -Command 'show-static-route' -Body $body

    $next = $resp.'next-hop' | ForEach-Object {
        [PSCustomObject]@{
            Gateway  = $_.gateway
            Priority = [int]$_.priority
        }
    }

    [PSCustomObject]@{
        Address          = $resp.address
        MaskLength       = [int]$resp.'mask-length'
        Type             = $resp.type
        NextHop          = $next
        Ping             = ($resp.ping -eq 'true')
        Rank             = [int]$resp.rank
        ScopeLocal       = ($resp.'scope-local' -eq 'true')
        Comment          = $resp.comment
        VirtualSystemId  = $resp.'virtual-system-id'
    }
}
