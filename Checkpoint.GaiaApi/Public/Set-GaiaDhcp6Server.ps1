function Set-GaiaDhcp6Server {
    <#
    .SYNOPSIS
        Configures DHCPv6 server settings.
    .DESCRIPTION
        Calls 'set-dhcp6-server' to enable/disable and set subnets.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER Enabled
        $true to enable, $false to disable the DHCPv6 server.
    .PARAMETER Subnets
        Array of hashtables matching API: 
        @{ subnet='…'; prefix=…; 'max-lease'=…; 'default-lease'=…; 'ip-pools'=…; dns=@{…}; enabled=$true }.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter(Mandatory=$true)]
        [bool]$Enabled,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [hashtable[]]$Subnets,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $body = @{
        enabled = $Enabled
        subnets = $Subnets
    }
    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-dhcp6-server' -Body $body

    # Mirror Get-GaiaDhcp6Server output
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
