function Get-GaiaTimezones {
    <#
    .SYNOPSIS
        Lists all available system timezones.
    .DESCRIPTION
        Calls 'show-timezones'.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Get-GaiaTimezones -Session $session
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-timezones' -Body $body

    $resp.timezones | ForEach-Object {
        [PSCustomObject]@{ Timezone = $_ }
    }
}
