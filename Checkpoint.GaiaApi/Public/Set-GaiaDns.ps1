function Set-GaiaDns {
    <#
    .SYNOPSIS
        Configures DNS servers, suffix, forwarding domains and listening interfaces.
    .DESCRIPTION
        Calls 'set-dns' with provided parameters and mirrors the updated configuration.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER Primary
        Primary DNS server IP or hostname.
    .PARAMETER Secondary
        Secondary DNS server IP or hostname.
    .PARAMETER Suffix
        DNS search suffix.
    .PARAMETER Tertiary
        Tertiary DNS server IP or hostname.
    .PARAMETER ForwardingDomains
        Array of hashtables: @{ suffix='domain'; primary='1.1.1.1'; secondary='2.2.2.2'; tertiary='4.4.2.2' }.
    .PARAMETER ListeningInterfaces
        Array of interface names (e.g. 'eth0').
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Set-GaiaDns -Session $s -Primary '1.2.3.4' -Suffix 'example.com'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter()][ValidateNotNullOrEmpty()]]
        [string]$Primary,

        [Parameter()][ValidateNotNullOrEmpty()]]
        [string]$Secondary,

        [Parameter()][ValidateNotNullOrEmpty()]]
        [string]$Suffix,

        [Parameter()][ValidateNotNullOrEmpty()]]
        [string]$Tertiary,

        [Parameter()][ValidateNotNullOrEmpty()]]
        [hashtable[]]$ForwardingDomains,

        [Parameter()][ValidateNotNullOrEmpty()]]
        [string[]]$ListeningInterfaces,

        [Parameter()][ValidateNotNullOrEmpty()]]
        [string]$MemberId
    )

    $body = @{}
    if ($Primary)             { $body.primary               = $Primary }
    if ($Secondary)           { $body.secondary             = $Secondary }
    if ($Suffix)              { $body.suffix                = $Suffix }
    if ($Tertiary)            { $body.tertiary              = $Tertiary }
    if ($ForwardingDomains)   { $body.'forwarding-domains'   = $ForwardingDomains }
    if ($ListeningInterfaces) { $body.'listening-interfaces' = $ListeningInterfaces }
    if ($MemberId)            { $body.'member-id'           = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-dns' -Body $body

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
