function Get-GaiaDhcp6Config {
    <#
    .SYNOPSIS
        Retrieves DHCPv6 client configuration.
    .DESCRIPTION
        Calls 'show-dhcp6-config' and returns client-mode and prefix-delegation options.
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-dhcp6-config' -Body $body

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
