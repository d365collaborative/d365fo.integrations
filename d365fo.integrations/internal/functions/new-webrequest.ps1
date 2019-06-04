
<#
    .SYNOPSIS
        Create a webrequest
        
    .DESCRIPTION
        Create a webrequest with the needed details handled
        
    .PARAMETER Url
        URL / URI for web endpoint you want to work against
        
    .PARAMETER Action
        HTTP action instructing the cmdlet how to build the request
        
    .PARAMETER AuthenticationToken
        The token value that should be used to authenticate against the URL / URI endpoint
        
    .PARAMETER ContentType
        HTTP valid content type value that the cmdlet should use while building the request
        
    .EXAMPLE
        PS C:\> New-WebRequest -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com/api/connector/dequeue/123456789" -Action "GET" -AuthenticationToken "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....."
        
        This will create a new webrequest.
        It will use the "https://usnconeboxax1aos.cloud.onebox.dynamics.com/api/connector/dequeue/123456789" as the webrequest endpoint address.
        It will use the "Get" as HTTP Action.
        It will use the "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....." as the bearer token for the HTTP Authorization header.
        
    .NOTES
        Tags: Request, DMF, Package, Packages
        
        Author: Mötz Jensen (@Splaxi)
#>

function New-WebRequest {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType([System.Net.WebRequest])]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Url,

        [Parameter(Mandatory = $true)]
        [string] $Action,

        [Parameter(Mandatory = $true)]
        [string] $AuthenticationToken,

        [Parameter(Mandatory = $false)]
        [string] $ContentType
    )

    Write-PSFMessage -Level Debug -Message "New Request $Url, $Action, $AuthenticationToken, $ContentType "
    
    $request = [System.Net.WebRequest]::Create($Url)
    $request.Headers["Authorization"] = $AuthenticationToken
    $request.Method = $Action

    if ($Action -eq 'POST') {
        $request.ContentType = $ContentType
    }

    $request
}