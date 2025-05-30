function Set-GaiaDhcpServer {
    <#
    .SYNOPSIS
        Configures DHCP (IPv4) server settings.
    .DESCRIPTION
        Calls 'set-dhcp-server' to enable/disable and set subnets.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER Enabled
        $true to enable, $false to disable the DHCP server.
    .PARAMETER Subnets
        Array of hashtables matching API:
        @{ subnet='4.5.6.0'; netmask=24; 'max-lease'=…; 'default-lease'=…; 'default-gateway'='x.x.x.x';
           'ip-pools'=@(...); dns=@{…}; enabled=$true }.
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-dhcp-server' -Body $body

    # Mirror Get-GaiaDhcpServer output
    $subnets = $resp.subnets | ForEach-Object {
        [PSCustomObject]@{
            Subnet         = $_.subnet
            Netmask        = [int]$_.netmask
            MaxLease       = [int]$_. 'max-lease'
            DefaultLease   = [int]$_. 'default-lease'
            DefaultGateway = $_.'default-gateway'
            IpPools        = $_.'ip-pools' | ForEach-Object {
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
            Enabled = [bool]$_.enabled
        }
    }

    [PSCustomObject]@{
        Enabled = [bool]$resp.enabled
        Subnets = $subnets
    }
}
