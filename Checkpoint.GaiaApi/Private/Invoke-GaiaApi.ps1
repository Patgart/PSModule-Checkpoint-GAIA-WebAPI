function Invoke-GaiaApi {
    <#
    .SYNOPSIS
        Internal: Calls the Gaia API.

    .DESCRIPTION
        Constructs the full URL from the session object, serializes the body to JSON,
        issues a POST, and returns the parsed response. Errors are thrown as
        RuntimeException with context.

    .PARAMETER Session
        PSCustomObject returned by Connect-GaiaSession, containing Sid, Url,
        WebApiVersion, etc.

    .PARAMETER Command
        The API command name (e.g. 'show-connections').

    .PARAMETER Body
        Hashtable representing the JSON body.

    .OUTPUTS
        The deserialized JSON response as PSCustomObject.

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [PSCustomObject]$Session,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Command,

        [Parameter()]
        [hashtable]$Body = @{}
    )

    $baseUrl = $Session.Url.TrimEnd('/')
    $version = $Session.WebApiVersion
    $url     = "$baseUrl/v$version/$Command"

    $json = $Body | ConvertTo-Json -Depth 10

    $headers = @{
        'Content-Type' = 'application/json'
        'X-chkp-sid'   = $Session.sid
    }

    Write-Verbose "POST $url -Body: $($json)"

    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $json -ErrorAction Stop
        return $response
    } catch {
        Write-Error "Gaia API '$Command' failed: $_"
        throw [System.Management.Automation.RuntimeException] "Error calling Gaia API '$Command': $_"
    }
}
