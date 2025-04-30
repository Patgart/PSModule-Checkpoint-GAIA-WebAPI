function Get-GaiaTimeAndDate {
    <#
    .SYNOPSIS
        Retrieves current system time, date and timezone.
    .DESCRIPTION
        Calls 'show-time-and-date'.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Get-GaiaTimeAndDate -Session $session
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-time-and-date' -Body $body

    [PSCustomObject]@{
        Date     = $resp.date
        Iso8601  = $resp.iso8601
        Posix    = [double]$resp.posix
        Time     = $resp.time
        Timezone = $resp.timezone
    }
}
