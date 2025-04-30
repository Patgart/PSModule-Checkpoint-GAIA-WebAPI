function Set-GaiaNtp {
    <#
    .SYNOPSIS
        Configures NTP servers and enable state.
    .DESCRIPTION
        Calls 'set-ntp' with enabled, preferred and server definitions.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER Enabled
        $true to enable NTP, $false to disable.
    .PARAMETER Preferred
        Address or hostname to prefer.
    .PARAMETER Servers
        Array of hashtables: @{ address='1.2.3.4'; type='server'; version=4 }.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Set-GaiaNtp -Session $s -Enabled $true -Servers @{ address='2.2.2.2'; type='server'; version=4 }
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter(Mandatory=$true)]
        [bool]$Enabled,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Preferred,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable[]]$Servers,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $body = @{ enabled = $Enabled }
    if ($Preferred) { $body.preferred = $Preferred }
    if ($Servers)   { $body.servers   = $Servers }
    if ($MemberId)  { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-ntp' -Body $body

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
