function Set-GaiaTacacs {
    <#
    .SYNOPSIS
        Configures TACACS+ servers (set or add).
    .DESCRIPTION
        Calls 'set-tacacs'. Without -Add it replaces the server list; with -Add it appends.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER Address
        IP or hostname of the TACACS+ server.
    .PARAMETER Secret
        Shared secret for TACACS+.
    .PARAMETER Priority
        Server priority.
    .PARAMETER Timeout
        Timeout in seconds.
    .PARAMETER Add
        Switch to add this server rather than replacing all.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        # Replace entire list
        Set-GaiaTacacs -Session $s -Address '1.2.1.2' -Secret '56' -Priority 3 -Timeout 1
        # Add one more
        Set-GaiaTacacs -Session $s -Address '10.0.0.5' -Secret 'abcdef' -Priority 5 -Timeout 2 -Add
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
        [string]$Secret,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int]$Priority,

        [Parameter()]
        [ValidateRange(1,60)]
        [int]$Timeout = 5,

        [Parameter()]
        [Switch]$Add,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $serverBlock = @{
        priority = $Priority
        address  = $Address
        timeout  = $Timeout
        secret   = $Secret
    }

    $body = @{}
    if ($Add) {
        $body.servers = @{ add = $serverBlock }
    } else {
        $body.servers = $serverBlock
    }
    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-tacacs' -Body $body

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
