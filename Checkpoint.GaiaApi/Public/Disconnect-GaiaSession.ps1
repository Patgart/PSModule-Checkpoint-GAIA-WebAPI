function Disconnect-GaiaSession {
    <#
    .SYNOPSIS
        Logs out from a Gaia session.

    .PARAMETER Session
        PSCustomObject returned by Connect-GaiaSession.

    .EXAMPLE
        Disconnect-GaiaSession -Session $session
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session
    )

    Write-Verbose "Logging out session $($Session.sid)"
    Invoke-GaiaApi -Session $Session -Command 'logout' -Body @{}
    Write-Verbose 'Logged out successfully.'
}
