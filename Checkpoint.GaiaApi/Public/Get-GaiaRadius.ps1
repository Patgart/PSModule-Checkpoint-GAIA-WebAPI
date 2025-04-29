function Get-GaiaRadius {
    <#
    .SYNOPSIS
        Retrieves the RADIUS server configuration.
    .DESCRIPTION
        Calls 'show-radius' and returns enabled flag, super-user UID, default shell, NAS IP and the list of RADIUS servers.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Get-GaiaRadius -Session $session
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $body = @{}
    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-radius' -Body $body

    [PSCustomObject]@{
        Enabled       = [bool]$resp.enabled
        SuperUserUid  = $resp.'super-user-uid'
        DefaultShell  = $resp.'default-shell'
        NasIp         = $resp.'nas-ip'
        Servers       = $resp.servers | ForEach-Object {
            [PSCustomObject]@{
                Priority = [int]$_.priority
                Address  = $_.address
                Port     = [int]$_.port
                Timeout  = [int]$_.timeout
            }
        }
    }
}
