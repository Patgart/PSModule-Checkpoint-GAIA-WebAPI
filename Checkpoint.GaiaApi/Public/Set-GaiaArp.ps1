function Set-GaiaArp {
    <#
    .SYNOPSIS
        Configures ARP proxy entries, static entries, and settings.
    .DESCRIPTION
        Calls 'set-arp' to replace the proxy/static lists and adjust settings.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER Proxy
        Array of hashtables: @{ interface='eth0'; 'ipv4-address'='x.x.x.x'; 'mac-address'='yy:yy:yy:yy:yy:yy' }.
    .PARAMETER Static
        Array of hashtables: @{ 'ipv4-address'='x.x.x.x'; 'mac-address'='yy:yy:yy:yy:yy:yy' }.
    .PARAMETER AutoCacheSize
        $true to enable auto cache sizing.
    .PARAMETER CacheSize
        Numeric cache size to set.
    .PARAMETER RestrictionLevel
        Restriction level (numeric).
    .PARAMETER ValidityTimeout
        Validity timeout in seconds.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable[]]$Proxy,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable[]]$Static,

        [Parameter()]
        [bool]$AutoCacheSize,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$CacheSize,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$RestrictionLevel,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$ValidityTimeout,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $body = @{}
    if ($Proxy) { $body.proxy  = $Proxy }
    if ($Static) { $body.static = $Static }

    $settings = @{}
    if ($PSBoundParameters.ContainsKey('AutoCacheSize'))    { $settings.'auto-cache-size'    = $AutoCacheSize }
    if ($PSBoundParameters.ContainsKey('CacheSize'))        { $settings.'cache-size'         = $CacheSize }
    if ($PSBoundParameters.ContainsKey('RestrictionLevel')) { $settings.'restriction-level'  = $RestrictionLevel }
    if ($PSBoundParameters.ContainsKey('ValidityTimeout'))  { $settings.'validity-timeout'   = $ValidityTimeout }
    if ($settings.Count -gt 0) { $body.settings = $settings }

    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-arp' -Body $body

    # Mirror Get-GaiaArp output
    $dynamic = $resp.dynamic | ForEach-Object {
        [PSCustomObject]@{
            IPv4Address = $_.'ipv4-address'
            MacAddress  = $_.'mac-address'
        }
    }
    $proxyResp = $resp.proxy | ForEach-Object {
        [PSCustomObject]@{
            Interface       = $_.interface
            IPv4Address     = $_.'ipv4-address'
            MacAddress      = $_.'mac-address'
            RealIPv4Address = $_.'real-ipv4-address'
        }
    }
    $staticResp = $resp.static | ForEach-Object {
        [PSCustomObject]@{
            IPv4Address = $_.'ipv4-address'
            MacAddress  = $_.'mac-address'
        }
    }
    $s = $resp.settings
    $settingsObjResp = [PSCustomObject]@{
        AutoCacheSize    = [bool]$s.'auto-cache-size'
        CacheSize        = [int]$s.'cache-size'
        RestrictionLevel = [int]$s.'restriction-level'
        ValidityTimeout  = [int]$s.'validity-timeout'
    }

    [PSCustomObject]@{
        Dynamic  = $dynamic
        Proxy    = $proxyResp
        Static   = $staticResp
        Settings = $settingsObjResp
    }
}
