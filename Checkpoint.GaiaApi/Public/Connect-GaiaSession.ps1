function Connect-GaiaSession {
    <#
    .SYNOPSIS
        Logs in to a CheckPoint Gaia device and returns a session object.

    .DESCRIPTION
        Calls the 'login' API, receives SID, URL, version, etc., and wraps them
        into a PSCustomObject for use in subsequent cmdlets.

    .PARAMETER Server
        Hostname or IP of the Gaia device.

    .PARAMETER Username
        Administrative username.

    .PARAMETER PlainPassword
        Plain-text password.

    .EXAMPLE
        $session = Connect-GaiaSession -Server 'fw.example.com' -Username 'admin' -PlainPassword 'P@ssw0rd'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Server,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Username,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$PlainPassword
    )

    Write-Verbose "Logging in to Gaia server $Server"

    $loginUrl = "https://$Server:443/gaia_api/v1.8/login"
    $body     = @{ user = $Username; password = $PlainPassword } | ConvertTo-Json

    try {
        $resp = Invoke-RestMethod -Uri $loginUrl -Method Post `
                  -Headers @{ 'Content-Type' = 'application/json' } `
                  -Body $body -ErrorAction Stop
    } catch {
        Write-Error "Login to Gaia server $Server failed: $_"
        throw [System.Management.Automation.RuntimeException] "Login failed: $_"
    }

    $session = [PSCustomObject]@{
        sid               = $resp.sid
        Url               = $resp.url
        SessionTimeout    = $resp.'session-timeout'
        LastLoginWasAt    = $resp.'last-login-was-at'
        LastLoginFrom     = $resp.'last-login-from'
        WebApiVersion     = $resp.'web-api-version'
    }

    Write-Verbose "Logged in; SID = $($session.sid)"
    return $session
}
