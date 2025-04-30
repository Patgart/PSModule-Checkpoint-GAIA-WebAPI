function Set-GaiaDhcp6Config {
    <#
    .SYNOPSIS
        Configures DHCPv6 client settings.
    .DESCRIPTION
        Calls 'set-dhcp6-config' to set client-mode and prefix-delegation options.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER ClientMode
        'normal' or 'prefix-delegation'.
    .PARAMETER Interface
        Interface name (required if ClientMode is 'prefix-delegation').
    .PARAMETER Method
        Prefix-delegation method (e.g. 'router-discovery').
    .PARAMETER SuffixPools
        Array of hashtables: @{ start='::100'; end='::200'; type='include' }.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter(Mandatory=$true)]
        [ValidateSet('normal','prefix-delegation')]
        [string]$ClientMode,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Interface,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Method,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable[]]$SuffixPools,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $body = @{ 'client-mode' = $ClientMode }

    if ($ClientMode -eq 'prefix-delegation') {
        $pdo = @{}
        if ($Interface)   { $pdo.interface   = $Interface }
        if ($Method)      { $pdo.method      = $Method }
        if ($SuffixPools) { $pdo.'suffix-pools' = $SuffixPools }
        $body.'prefix-delegation-options' = $pdo
    }

    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-dhcp6-config' -Body $body

    # Mirror Get-GaiaDhcp6Config output
    [PSCustomObject]@{
        ClientMode               = $resp.'client-mode'
        PrefixDelegationOptions  = [PSCustomObject]@{
            Interface   = $resp.'prefix-delegation-options'.interface
            Method      = $resp.'prefix-delegation-options'.method
            SuffixPools = $resp.'prefix-delegation-options'.'suffix-pools' | ForEach-Object {
                [PSCustomObject]@{
                    Start = $_.start
                    End   = $_.end
                    Type  = $_.type
                }
            }
        }
    }
}
