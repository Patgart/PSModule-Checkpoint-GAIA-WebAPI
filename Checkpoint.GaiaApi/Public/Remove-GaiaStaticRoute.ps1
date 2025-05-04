function Remove-GaiaStaticRoute {
    <#
    .SYNOPSIS
        Deletes a static route.

    .DESCRIPTION
        Calls the Gaia API 'delete-static-route' to remove a configured IPv4 static route.

    .PARAMETER Session
        The GaiaSession object from Connect-GaiaSession.

    .PARAMETER Address
        The destination network address of the static route, e.g. '1.2.3.0'.

    .PARAMETER MaskLength
        The network prefix length (0–32) of the static route.

    .PARAMETER VirtualSystemId
        (Optional) Virtual System ID, relevant for VSNext setups.

    .EXAMPLE
        Remove-GaiaStaticRoute -Session $s -Address '1.2.3.0' -MaskLength 24
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
        [int]$VirtualSystemId
    )

    $body = @{
        address     = $Address
        'mask-length' = $MaskLength
    }
    if ($PSBoundParameters.ContainsKey('VirtualSystemId')) {
        $body.'virtual-system-id' = $VirtualSystemId
    }

    Write-Verbose "Deleting static route $Address/$MaskLength"
    Invoke-GaiaApi -Session $Session -Command 'delete-static-route' -Body $body | Out-Null
    Write-Verbose "Static route deleted."
}
