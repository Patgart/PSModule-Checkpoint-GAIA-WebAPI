function Get-GaiaStatistics {
    <#
    .SYNOPSIS
        Retrieves CPView statistics data.

    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.

    .PARAMETER Filter
        Array of stat-IDs (ParameterSet: NewQuery).

    .PARAMETER ShowInfo
        $true to include metadata (ParameterSet: NewQuery).

    .PARAMETER IgnoreWarnings
        $true to suppress warnings (ParameterSet: NewQuery).

    .PARAMETER CursorId
        Existing cursor ID (ParameterSet: UseCursor).

    .PARAMETER MemberId
        (Optional) For multi-member gateways.

    .EXAMPLE
        Get-GaiaStatistics -Session $session -Filter 'fw.policy.last_install_time' -IgnoreWarnings $true
    #>
    [CmdletBinding(DefaultParameterSetName='NewQuery')]
    param(
        [Parameter(Mandatory=$true, ParameterSetName='NewQuery')]
        [string[]]$Filter,

        [Parameter(ParameterSetName='NewQuery')]
        [bool]$ShowInfo = $false,

        [Parameter(ParameterSetName='NewQuery')]
        [bool]$IgnoreWarnings = $false,

        [Parameter(Mandatory=$true, ParameterSetName='UseCursor')]
        [string]$CursorId,

        [string]$MemberId,

        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session
    )

    $body = @{}
    if ($PSCmdlet.ParameterSetName -eq 'NewQuery') {
        $body.'new-query' = @{
            filter          = $Filter
            'show-info'     = $ShowInfo
            'ignore-warnings' = $IgnoreWarnings
        }
    } else {
        $body.'use-cursor' = @{ 'cursor-id' = $CursorId }
    }

    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-statistics' -Body $body

    $data = $resp.result.data | ForEach-Object {
        [PSCustomObject]@{
            StatId  = $_.'stat-id'
            Records = $_.records
        }
    }

    [PSCustomObject]@{
        Data       = $data
        NextCursor = $resp.result.'next-cursor'
    }
}
