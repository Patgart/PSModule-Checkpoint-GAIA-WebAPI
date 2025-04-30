function Get-GaiaProxy {
    <#
    .SYNOPSIS
        Retrieves current HTTP proxy settings.
    .DESCRIPTION
        Calls 'show-proxy'.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Get-GaiaProxy -Session $session
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $body = @{}
    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-proxy' -Body $body
    [PSCustomObject]@{
        Address = $resp.address
        Port    = [int]$resp.port
    }
}
