function Get-GaiaTask {
    <#
    .SYNOPSIS
        Retrieves task details for a given task-id.

    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.

    .PARAMETER TaskId
        The task-id returned by operations like show-connections.

    .EXAMPLE
        Get-GaiaTask -Session $session -TaskId '1234-...'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$TaskId
    )

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-task' -Body @{ 'task-id' = $TaskId }
    return $resp.tasks
}
