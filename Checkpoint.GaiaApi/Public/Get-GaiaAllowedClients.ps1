function Get-GaiaAllowedClients {
    <#
    .SYNOPSIS
        Retrieves the current allowed-clients configuration.
    .DESCRIPTION
        Calls 'show-allowed-clients' and returns whether any host is allowed,
        the list of allowed network subnets, and the list of allowed individual hosts.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Get-GaiaAllowedClients -Session $session
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-allowed-clients' -Body $body

    [PSCustomObject]@{
        AllowedAnyHost  = [bool]$resp.'allowed-any-host'
        AllowedNetworks = $resp.'allowed-networks' | ForEach-Object {
            [PSCustomObject]@{
                Subnet     = $_.subnet
                MaskLength = [int]$_. 'mask-length'
            }
        }
        AllowedHosts   = $resp.'allowed-hosts'
    }
}
