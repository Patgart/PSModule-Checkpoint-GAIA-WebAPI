function Set-GaiaTimeAndDate {
    <#
    .SYNOPSIS
        Sets system time, date and timezone.
    .DESCRIPTION
        Calls 'set-time-and-date' and returns a task ID for the async operation.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER Time
        Time in HH:mm:ss format.
    .PARAMETER Date
        Date in YYYY-MM-DD format.
    .PARAMETER Timezone
        Timezone string (e.g. 'Asia/Jerusalem').
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Set-GaiaTimeAndDate -Session $s -Time '16:32:56' -Date '2019-07-22' -Timezone 'Asia/Jerusalem'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Time,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Date,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Timezone,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $body = @{
        time     = $Time
        date     = $Date
        timezone = $Timezone
    }
    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-time-and-date' -Body $body
    [PSCustomObject]@{ TaskId = $resp.'task-id' }
}
