function Set-GaiaProxy {
    <#
    .SYNOPSIS
        Configures HTTP proxy settings.
    .DESCRIPTION
        Calls 'set-proxy' with address and port.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER Address
        Proxy server IP or hostname.
    .PARAMETER Port
        Proxy port number.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Set-GaiaProxy -Session $s -Address '1.1.1.1' -Port 89
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Address,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int]$Port,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $body = @{
        address = $Address
        port    = $Port
    }
    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-proxy' -Body $body
    [PSCustomObject]@{
        Address = $resp.address
        Port    = [int]$resp.port
    }
}
