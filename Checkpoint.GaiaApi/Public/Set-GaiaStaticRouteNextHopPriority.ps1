function Set-GaiaStaticRouteNextHopPriority {
    <#
    .SYNOPSIS
        Adjusts the priority of a next-hop entry on a static route.

    .DESCRIPTION
        Calls the Gaia API 'set-static-route-next-hop-priority' to change the
        priority for a specified gateway on an IPv4 static route.

    .PARAMETER Session
        The GaiaSession object from Connect-GaiaSession.

    .PARAMETER Address
        The destination network address, e.g. '1.2.3.0'.

    .PARAMETER MaskLength
        The network prefix length (0–32).

    .PARAMETER NextHopGateway
        IP address or interface name of the next-hop gateway.

    .PARAMETER Priority
        New priority (1–8) or 'default'.

    .PARAMETER VirtualSystemId
        (Optional) Virtual System ID, relevant for VSNext setups.

    .EXAMPLE
        Set-GaiaStaticRouteNextHopPriority -Session $s -Address '1.2.3.0' `
            -MaskLength 24 -NextHopGateway '1.1.1.1' -Priority 3
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
        [ValidateNotNullOrEmpty()]
        [string]$NextHopGateway,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [object]$Priority,

        [Parameter()]
        [int]$VirtualSystemId
    )

    $body = @{
        address            = $Address
        'mask-length'        = $MaskLength
        'next-hop-gateway' = $NextHopGateway
        priority           = $Priority
    }
    if ($PSBoundParameters.ContainsKey('VirtualSystemId')) {
        $body.'virtual-system-id' = $VirtualSystemId
    }

    Write-Verbose "Changing next-hop priority for $NextHopGateway on $Address/$MaskLength"
    $resp = Invoke-GaiaApi -Session $Session -Command 'set-static-route-next-hop-priority' -Body $body

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
