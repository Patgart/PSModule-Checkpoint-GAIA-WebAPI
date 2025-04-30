function Get-GaiaNtp {
    <#
    .SYNOPSIS
        Retrieves NTP configuration.
    .DESCRIPTION
        Calls 'show-ntp' and returns current, enabled, preferred and server list.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Get-GaiaNtp -Session $session
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-ntp' -Body $body

    $servers = $resp.servers | ForEach-Object {
        [PSCustomObject]@{
            Address = $_.address
            Type    = $_.type
            Version = [int]$_.version
        }
    }

    [PSCustomObject]@{
        Current   = $resp.current
        Enabled   = [bool]$resp.enabled
        Preferred = $resp.preferred
        Servers   = $servers
    }
}
