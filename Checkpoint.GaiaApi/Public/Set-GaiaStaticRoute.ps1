function Set-GaiaStaticRoute {
    <#
    .SYNOPSIS
        Creates or updates a static route.

    .DESCRIPTION
        Calls the Gaia API 'set-static-route' to add or modify an IPv4 static route,
        including next-hop, metric, ping monitoring, scope, comments, etc.

    .PARAMETER Session
        The GaiaSession object from Connect-GaiaSession.

    .PARAMETER Address
        The destination network address, e.g. '1.2.3.0'.

    .PARAMETER MaskLength
        The network prefix length (0–32).

    .PARAMETER Type
        The static-route next-hop type: blackhole, gateway, or reject.

    .PARAMETER NextHop
        A hashtable or array of hashtables describing next-hop actions.
        E.g. @{ add = @{ gateway='1.1.1.1'; priority=2 } } or
        @(@{ gateway='eth2'; priority=3 }, @{ gateway='2.2.2.2'; priority=4 }).

    .PARAMETER Ping
        $true to enable ping monitoring (default $false).

    .PARAMETER Rank
        Route rank (0–255) or 'default'.

    .PARAMETER ScopeLocal
        $true to treat route as directly connected (default $false).

    .PARAMETER Comment
        Free-text comment for the route.

    .PARAMETER VirtualSystemId
        (Optional) Virtual System ID, relevant for VSNext setups.

    .EXAMPLE
        Set-GaiaStaticRoute -Session $s -Address '1.2.3.0' -MaskLength 24 `
            -Type gateway -NextHop @{ gateway='1.1.1.1'; priority=1 } -Ping $true -Rank 10
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

        [Parameter(Mandatory=$true)]
        [ValidateSet('blackhole','gateway','reject')]
        [string]$Type,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [object]$NextHop,

        [Parameter()]
        [bool]$Ping = $false,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [object]$Rank,

        [Parameter()]
        [bool]$ScopeLocal = $false,

        [Parameter()]
        [string]$Comment,

        [Parameter()]
        [int]$VirtualSystemId
    )

    $body = @{
        address       = $Address
        'mask-length'   = $MaskLength
        type          = $Type
    }
    if ($PSBoundParameters.ContainsKey('NextHop'))    { $body.'next-hop'     = $NextHop }
    if ($PSBoundParameters.ContainsKey('Ping'))       { $body.ping           = $Ping }
    if ($PSBoundParameters.ContainsKey('Rank'))       { $body.rank           = $Rank }
    if ($PSBoundParameters.ContainsKey('ScopeLocal')) { $body.'scope-local'  = $ScopeLocal }
    if ($PSBoundParameters.ContainsKey('Comment'))    { $body.comment        = $Comment }
    if ($PSBoundParameters.ContainsKey('VirtualSystemId')) {
        $body.'virtual-system-id' = $VirtualSystemId
    }

    Write-Verbose "Setting static route $Address/$MaskLength"
    $resp = Invoke-GaiaApi -Session $Session -Command 'set-static-route' -Body $body

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
