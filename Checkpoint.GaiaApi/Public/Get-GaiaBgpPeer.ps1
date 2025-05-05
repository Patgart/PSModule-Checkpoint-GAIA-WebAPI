function Get-GaiaBgpPeer {
    <#
    .SYNOPSIS
        Displays configuration and state information for a BGP peer.
    .DESCRIPTION
        Calls the 'show-bgp-peer' API to retrieve configuration and runtime state
        of a specified BGP peer.
    .PARAMETER Session
        PSCustomObject returned by Connect-GaiaSession, containing Sid, Url, WebApiVersion, etc.
    .PARAMETER Peer
        IPv4 or IPv6 address of the peer to query.
    .PARAMETER MemberId
        (Optional) For multi-member gateways: execute command on specified member.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$Session,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^(?:(?:25[0-5]|2[0-4]\d|[01]?\d?\d)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d?\d)$|^[0-9A-Fa-f:]+$')]
        [string]$Peer,

        [Parameter(Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId
    )

    Write-Verbose "Retrieving BGP peer information for peer '$Peer'"

    $body = @{ peer = $Peer }
    if ($MemberId) { $body['member-id'] = $MemberId }

    $resp = Invoke-GaiaApi -Session $Session -Command 'show-bgp-peer' -Body $body

    # ReachabilityDetection
    $reachability = $null
    if ($resp.'reachability-detection') {
        $rd = $resp.'reachability-detection'
        $reachability = [PSCustomObject]@{
            Type                  = $rd.type
            Monitoring            = $rd.monitoring
            MonitoringDescription = $rd.'monitoring-description'
            Reachable             = $rd.reachable
            ReachableDescription  = $rd.'reachable-description'
            LastReceived          = $rd.'last-received'
        }
    }

    # GracefulRestart
    $graceful = $null
    if ($resp.'graceful-restart') {
        $gr = $resp.'graceful-restart'
        $graceful = [PSCustomObject]@{
            Enabled                  = $gr.enabled
            EnabledDescription       = $gr.'enabled-description'
            State                    = $gr.state
            RestartHelperExpiryTime  = $gr.'restart-helper-expiry-time'
            StalepathExpiryTime      = $gr.'stalepath-expiry-time'
            StalepathTime            = $gr.'stalepath-time'
            RestartTimeAdvertised    = $gr.'restart-time-advertised'
            RestartTimeReceived      = $gr.'restart-time-received'
        }
    }

    # Keepalives
    $keepalives = $null
    if ($resp.keepalives) {
        $kp = $resp.keepalives
        $keepalives = [PSCustomObject]@{
            LastReceived = $kp.'last-received'
            LastSent     = $kp.'last-sent'
            Interval     = $kp.interval
            Holdtime     = $kp.holdtime
        }
    }

    # Received
    $received = $null
    if ($resp.received) {
        $rc = $resp.received
        $received = [PSCustomObject]@{
            RoutesReceived           = $rc.'routes-received'
            RoutesReceivedActive     = $rc.'routes-received-active'
            IPv6RoutesReceived       = $rc.'ipv6-routes-received'
            IPv6RoutesReceivedActive = $rc.'ipv6-routes-received-active'
            NotificationsList        = $rc.'notifications-list' | ForEach-Object {
                [PSCustomObject]@{
                    Code    = $_.code
                    SubCode = $_.'sub-code'
                    Time    = $_.time
                }
            }
        }
    }

    # Sent
    $sent = $null
    if ($resp.sent) {
        $st = $resp.sent
        $sent = [PSCustomObject]@{
            RoutesSent        = $st.'routes-sent'
            IPv6RoutesSent    = $st.'ipv6-routes-sent'
            NotificationsList = $st.'notifications-list' | ForEach-Object {
                [PSCustomObject]@{
                    Code    = $_.code
                    SubCode = $_.'sub-code'
                    Time    = $_.time
                }
            }
        }
    }

    # Capabilities lists (handle both API naming variants)
    $peerCaps = $resp.'peer-capabilities-list'
    if (-not $peerCaps) { $peerCaps = $resp.'peer-capabilities' }
    $ourCaps = $resp.'our-capabilities-list'
    if (-not $ourCaps)  { $ourCaps  = $resp.'our-capabilities' }

    [PSCustomObject]@{
        Peer                  = $resp.peer
        Type                  = $resp.type
        As                    = $resp.as
        State                 = $resp.state
        Uptime                = $resp.uptime
        RemoteAs              = $resp.'remote-as'
        LocalAs               = $resp.'local-as'
        PeerCapabilities      = $peerCaps
        OurCapabilities       = $ourCaps
        AuthType              = $resp.authtype
        AuthFailures          = $resp.'auth-failures'
        EnableMultihop        = $resp.'enable-multihop'
        MultihopTtl           = $resp.'multihop-ttl'
        ReachabilityDetection = $reachability
        GracefulRestart       = $graceful
        Keepalives            = $keepalives
        Received              = $received
        Sent                  = $sent
        MemberId              = $resp.'member-id'
    }
}
