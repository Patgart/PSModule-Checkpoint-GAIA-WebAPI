function Get-GaiaAuthenticationOrder {
    <#
    .SYNOPSIS
        Retrieves authentication order settings.
    .DESCRIPTION
        Calls 'show-authentication-order' and returns Local, RADIUS and TACACS+ order details.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Get-GaiaAuthenticationOrder -Session $session
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

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-authentication-order' -Body $body

    [PSCustomObject]@{
        Local = [PSCustomObject]@{
            Enabled  = [bool]$resp.local.enabled
            Priority = [int]$resp.local.priority
        }
        Radius = [PSCustomObject]@{
            Enabled  = [bool]$resp.radius.enabled
            Priority = [int]$resp.radius.priority
            Servers  = $resp.radius.servers | ForEach-Object {
                [PSCustomObject]@{
                    Priority = [int]$_.priority
                    Address  = $_.address
                    Port     = if ($_.port) { [int]$_.port } else { $null }
                    Timeout  = if ($_.timeout) { [int]$_.timeout } else { $null }
                }
            }
        }
        Tacacs = [PSCustomObject]@{
            Enabled  = [bool]$resp.tacacs.enabled
            Priority = [int]$resp.tacacs.priority
            Servers  = $resp.tacacs.servers | ForEach-Object {
                [PSCustomObject]@{
                    Priority = [int]$_.priority
                    Address  = $_.address
                    Timeout  = if ($_.timeout) { [int]$_.timeout } else { $null }
                }
            }
        }
    }
}
