function Set-GaiaAllowedClients {
    <#
    .SYNOPSIS
        Configures allowed clients (networks and hosts).
    .DESCRIPTION
        Calls 'set-allowed-clients' to replace or adjust the list of allowed networks,
        individual hosts, and/or the any-host flag.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER AllowedAnyHost
        $true to allow any host, $false otherwise.
    .PARAMETER AllowedNetworks
        Full list of network hashtables: @{ subnet = 'x.x.x.x'; 'mask-length' = <int> }.
    .PARAMETER AddAllowedNetworks
        Networks to add to the existing allowed-networks list.
    .PARAMETER RemoveAllowedNetworks
        Networks to remove from the existing allowed-networks list.
    .PARAMETER AllowedHosts
        Full list of individual host IP strings.
    .PARAMETER AddAllowedHosts
        Individual host IPs to add.
    .PARAMETER RemoveAllowedHosts
        Individual host IPs to remove.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        # Replace entire lists
        $nets = @(
          @{ subnet = '44.4.44.0'; 'mask-length' = 24 },
          @{ subnet = '55.4.55.0'; 'mask-length' = 24 }
        )
        Set-GaiaAllowedClients -Session $session `
            -AllowedNetworks $nets `
            -AllowedHosts @('1.2.3.4','8.9.1.1') `
            -AllowedAnyHost $true
    .EXAMPLE
        # Add just one network
        $addNet = @{ subnet = '66.6.66.0'; 'mask-length' = 24 }
        Set-GaiaAllowedClients -Session $session -AddAllowedNetworks $addNet
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter()]
        [bool]$AllowedAnyHost,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable[]]$AllowedNetworks,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable[]]$AddAllowedNetworks,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable[]]$RemoveAllowedNetworks,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$AllowedHosts,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$AddAllowedHosts,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$RemoveAllowedHosts,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $body = @{}

    if ($PSBoundParameters.ContainsKey('AllowedAnyHost')) {
        $body.'allowed-any-host' = $AllowedAnyHost
    }
    if ($PSBoundParameters.ContainsKey('AllowedNetworks')) {
        $body.'allowed-networks' = $AllowedNetworks
    }
    if ($PSBoundParameters.ContainsKey('AddAllowedNetworks')) {
        $body.'allowed-networks' = @{ add = $AddAllowedNetworks }
    }
    if ($PSBoundParameters.ContainsKey('RemoveAllowedNetworks')) {
        $body.'allowed-networks' = @{ remove = $RemoveAllowedNetworks }
    }
    if ($PSBoundParameters.ContainsKey('AllowedHosts')) {
        $body.'allowed-hosts' = $AllowedHosts
    }
    if ($PSBoundParameters.ContainsKey('AddAllowedHosts')) {
        $body.'allowed-hosts' = @{ add = $AddAllowedHosts }
    }
    if ($PSBoundParameters.ContainsKey('RemoveAllowedHosts')) {
        $body.'allowed-hosts' = @{ remove = $RemoveAllowedHosts }
    }
    if ($MemberId) {
        $body.'member-id' = $MemberId
    }

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-allowed-clients' -Body $body

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
