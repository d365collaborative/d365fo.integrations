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
PS C:\> New-WebRequest -Url api/connector/dequeue/123456789 -Action "GET" -AuthenticationToken ""

.NOTES
General notes
#>

function New-WebRequest {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]

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

    Write-PSFMessage -Level Verbose -Message "New Request $RequestUrl, $Action, $AuthenticationToken, $ContentType "
    
    $request = [System.Net.WebRequest]::Create($RequestUrl)
    $request.Headers["Authorization"] = $AuthenticationToken
    $request.Method = $Action

    if ($Action -eq 'POST') {
        $request.ContentType = $ContentType
    }

    $request
}