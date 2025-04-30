function Get-GaiaDns {
    <#
    .SYNOPSIS
        Retrieves DNS configuration.
    .DESCRIPTION
        Calls 'show-dns' and returns primary, secondary, suffix, tertiary,
        forwarding domains and listening interfaces.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Get-GaiaDns -Session $session
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-dns' -Body $body

    $forwarding = $resp.'forwarding-domains' | ForEach-Object {
        [PSCustomObject]@{
            Suffix    = $_.suffix
            Primary   = $_.primary
            Secondary = $_.secondary
            Tertiary  = $_.tertiary
        }
    }

    [PSCustomObject]@{
        Primary             = $resp.primary
        Secondary           = $resp.secondary
        Suffix              = $resp.suffix
        Tertiary            = $resp.tertiary
        ForwardingDomains   = $forwarding
        ListeningInterfaces = $resp.'listening-interfaces'
    }
}
