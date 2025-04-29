function Set-GaiaRadius {
    <#
    .SYNOPSIS
        Configures RADIUS servers (set or add).
    .DESCRIPTION
        Calls 'set-radius'. Without -Add it replaces the server list; with -Add it appends.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER Address
        IP or hostname of the RADIUS server.
    .PARAMETER Secret
        Shared secret for RADIUS.
    .PARAMETER Port
        UDP port. Default = 1812.
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
        Set-GaiaRadius -Session $s -Address '1.2.1.2' -Secret '12345' -Port 56 -Priority 3 -Timeout 1
        # Add one more
        Set-GaiaRadius -Session $s -Address '10.23.1.147' -Secret 'password' -Port 55 -Priority 9 -Timeout 2 -Add
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

        [Parameter()]
        [ValidateRange(1,65535)]
        [int]$Port = 1812,

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
        port     = $Port
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-radius' -Body $body

    # Mirror Get output
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
