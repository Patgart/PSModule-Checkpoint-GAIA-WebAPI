function Get-GaiaArp {
    <#
    .SYNOPSIS
        Retrieves ARP configuration (dynamic, proxy, static entries, and settings).
    .DESCRIPTION
        Calls 'show-arp' and returns the four sections of ARP table: 
        Dynamic entries, Proxy entries, Static entries, and Settings.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-arp' -Body $body

    $dynamic = $resp.dynamic | ForEach-Object {
        [PSCustomObject]@{
            IPv4Address = $_.'ipv4-address'
            MacAddress  = $_.'mac-address'
        }
    }

    $proxy = $resp.proxy | ForEach-Object {
        [PSCustomObject]@{
            Interface       = $_.interface
            IPv4Address     = $_.'ipv4-address'
            MacAddress      = $_.'mac-address'
            RealIPv4Address = $_.'real-ipv4-address'
        }
    }

    $static = $resp.static | ForEach-Object {
        [PSCustomObject]@{
            IPv4Address = $_.'ipv4-address'
            MacAddress  = $_.'mac-address'
        }
    }

    $settings = $resp.settings
    $settingsObj = [PSCustomObject]@{
        AutoCacheSize    = [bool]$settings.'auto-cache-size'
        CacheSize        = [int]$settings.'cache-size'
        RestrictionLevel = [int]$settings.'restriction-level'
        ValidityTimeout  = [int]$settings.'validity-timeout'
    }

    [PSCustomObject]@{
        Dynamic  = $dynamic
        Proxy    = $proxy
        Static   = $static
        Settings = $settingsObj
    }
}
