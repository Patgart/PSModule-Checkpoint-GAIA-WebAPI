function Get-GaiaDhcp6Server {
    <#
    .SYNOPSIS
        Retrieves DHCPv6 server configuration.
    .DESCRIPTION
        Calls 'show-dhcp6-server' and returns enabled flag and list of subnets.
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-dhcp6-server' -Body $body

    $subnets = $resp.subnets | ForEach-Object {
        [PSCustomObject]@{
            Subnet       = $_.subnet
            Prefix       = [int]$_.prefix
            MaxLease     = [int]$_. 'max-lease'
            DefaultLease = [int]$_. 'default-lease'
            IpPools      = $_.'ip-pools' | ForEach-Object {
                [PSCustomObject]@{
                    Start   = $_.start
                    End     = $_.end
                    Enabled = [bool]$_.enabled
                    Include = $_.include
                }
            }
            Dns = [PSCustomObject]@{
                DomainName = $_.dns.'domain-name'
                Primary    = $_.dns.primary
                Secondary  = $_.dns.secondary
                Tertiary   = $_.dns.tertiary
            }
            Enabled     = [bool]$_.enabled
        }
    }

    [PSCustomObject]@{
        Enabled = [bool]$resp.enabled
        Subnets = $subnets
    }
}
