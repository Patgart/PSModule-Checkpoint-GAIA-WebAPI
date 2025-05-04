function Get-GaiaStaticRoutes {
    <#
    .SYNOPSIS
        Retrieves all configured static routes.

    .DESCRIPTION
        Calls the Gaia API 'show-static-routes' to list IPv4 static routes, with
        optional paging, sorting, and member/VS filters.

    .PARAMETER Session
        The GaiaSession object from Connect-GaiaSession.

    .PARAMETER Limit
        Maximum number of results (1–200).

    .PARAMETER Offset
        Number of results to skip (0–65535).

    .PARAMETER Order
        Sort order: ASC or DESC.

    .PARAMETER MemberId
        (Optional) Scalable/Elastic XL member ID.

    .PARAMETER VirtualSystemId
        (Optional) Virtual System ID, relevant for VSNext setups.

    .EXAMPLE
        Get-GaiaStaticRoutes -Session $s -Limit 100 -Order DESC
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Session,

        [Parameter()]
        [ValidateRange(1,200)]
        [int]$Limit,

        [Parameter()]
        [ValidateRange(0,65535)]
        [int]$Offset,

        [Parameter()]
        [ValidateSet('ASC','DESC')]
        [string]$Order,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MemberId,

        [Parameter()]
        [int]$VirtualSystemId
    )

    $body = @{}
    if ($PSBoundParameters.ContainsKey('Limit'))          { $body.limit              = $Limit }
    if ($PSBoundParameters.ContainsKey('Offset'))         { $body.offset             = $Offset }
    if ($PSBoundParameters.ContainsKey('Order'))          { $body.order              = $Order }
    if ($PSBoundParameters.ContainsKey('MemberId'))       { $body.'member-id'        = $MemberId }
    if ($PSBoundParameters.ContainsKey('VirtualSystemId')) { $body.'virtual-system-id' = $VirtualSystemId }

    Write-Verbose "Fetching static routes (limit=$Limit, offset=$Offset, order=$Order)"
    $resp = Invoke-GaiaApi -Session $Session -Command 'show-static-routes' -Body $body

    $resp.objects | ForEach-Object {
        $nh = $_.'next-hop' | ForEach-Object {
            [PSCustomObject]@{
                Gateway  = $_.gateway
                Priority = [int]$_.priority
            }
        }
        [PSCustomObject]@{
            Address     = $_.address
            MaskLength  = [int]$_.‘mask-length’
            Type        = $_.type
            NextHop     = $nh
            Ping        = ($_.ping -eq 'true')
            Rank        = [int]$_.rank
            ScopeLocal  = ($_.‘scope-local’ -eq 'true')
            Comment     = $_.comment
        }
    }
}
