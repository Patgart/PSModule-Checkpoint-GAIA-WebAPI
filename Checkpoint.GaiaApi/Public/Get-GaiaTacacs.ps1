function Get-GaiaTacacs {
    <#
    .SYNOPSIS
        Retrieves the TACACS+ server configuration.
    .DESCRIPTION
        Calls 'show-tacacs' and returns enabled flag, super-user UID and the list of TACACS+ servers.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Get-GaiaTacacs -Session $session
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-tacacs' -Body $body

    [PSCustomObject]@{
        Enabled       = [bool]$resp.enabled
        SuperUserUid  = $resp.'super-user-uid'
        Servers       = $resp.servers | ForEach-Object {
            [PSCustomObject]@{
                Priority = [int]$_.priority
                Address  = $_.address
                Timeout  = [int]$_.timeout
            }
        }
    }
}
