function Remove-GaiaProxy {
    <#
    .SYNOPSIS
        Clears HTTP proxy settings.
    .DESCRIPTION
        Calls 'delete-proxy'.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Remove-GaiaProxy -Session $session
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

    Invoke-GaiaApi -Session $Session -Command 'delete-proxy' -Body $body
    Write-Verbose 'Proxy settings cleared.'
}
