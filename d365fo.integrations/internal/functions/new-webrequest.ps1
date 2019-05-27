function New-WebRequest {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]

    param(
        [Parameter(Mandatory = $true)]
        [string] $RequestUrl,

        [Parameter(Mandatory = $true)]
        [string] $Action,

        [Parameter(Mandatory = $true)]
        [string] $AuthenticationToken,

        [Parameter(Mandatory = $false)]
        [string] $ContentType
    )

    Write-PSFMessage -Level Verbose -Message "New Request $RequestUrl, $Action, $AuthenticationToken, $ContentType "
    
    $request = [System.Net.WebRequest]::Create($RequestUrl)
    $request.Headers["Authorization"] = $AuthenticationToken
    $request.Method = $Action

    if ($Action -eq 'POST') {
        $request.ContentType = $ContentType
    }

    $request
}