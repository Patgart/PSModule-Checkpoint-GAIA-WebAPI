function Set-GaiaAuthenticationOrder {
    <#
    .SYNOPSIS
        Configures authentication order for Local, RADIUS and TACACS+.
    .DESCRIPTION
        Calls 'set-authentication-order' with enabled flags and priorities.
    .PARAMETER Session
        PSCustomObject from Connect-GaiaSession.
    .PARAMETER RadiusEnabled
        $true to enable RADIUS authentication.
    .PARAMETER RadiusPriority
        Priority for RADIUS.
    .PARAMETER TacacsEnabled
        $true to enable TACACS+ authentication.
    .PARAMETER TacacsPriority
        Priority for TACACS+.
    .PARAMETER LocalEnabled
        $true to enable local authentication.
    .PARAMETER LocalPriority
        Priority for local.
    .PARAMETER MemberId
        (Optional) For multi-member gateways.
    .EXAMPLE
        Set-GaiaAuthenticationOrder -Session $s `
            -RadiusEnabled $true -RadiusPriority 3 `
            -TacacsEnabled $false -TacacsPriority 1 `
            -LocalEnabled $true -LocalPriority 2
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter(Mandatory=$true)]
        [bool]$RadiusEnabled,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int]$RadiusPriority,

        [Parameter(Mandatory=$true)]
        [bool]$TacacsEnabled,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int]$TacacsPriority,

        [Parameter(Mandatory=$true)]
        [bool]$LocalEnabled,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int]$LocalPriority,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    $body = @{
        radius = @{
            enabled  = $RadiusEnabled
            priority = $RadiusPriority
        }
        tacacs = @{
            enabled  = $TacacsEnabled
            priority = $TacacsPriority
        }
        local = @{
            enabled  = $LocalEnabled
            priority = $LocalPriority
        }
    }
    if ($MemberId) { $body.'member-id' = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'set-authentication-order' -Body $body

    [PSCustomObject]@{
        Local = [PSCustomObject]@{
            Enabled  = [bool]$resp.local.enabled
            Priority = [int]$resp.local.priority
        }
        Radius = [PSCustomObject]@{
            Enabled  = [bool]$resp.radius.enabled
            Priority = [int]$resp.radius.priority
            Servers  = $resp.radius.servers
        }
        Tacacs = [PSCustomObject]@{
            Enabled  = [bool]$resp.tacacs.enabled
            Priority = [int]$resp.tacacs.priority
            Servers  = $resp.tacacs.servers
        }
    }
}
