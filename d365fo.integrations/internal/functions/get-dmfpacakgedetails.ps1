<#
.SYNOPSIS
Get DMF Package details

.DESCRIPTION
Get all the needed details about a DMF package, so you can download it from the Dynamics 365 for Finance & Operations

.PARAMETER JobId
The GUID from the recurring data job

.PARAMETER AuthenticationToken
The token value that should be used to authenticate against the URL / URI endpoint

.PARAMETER Url
URL / URI for the D365FO environment you want to access through DMF

    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts

.EXAMPLE
PS C:\> Get-DmfPackageDetails -JobId "db5e719a-8db3-4fe5-9c78-7be479ce85a2" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -AuthenticationToken "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....."

This will fetch the available DMF package details.
It will use "db5e719a-8db3-4fe5-9c78-7be479ce85a2" as the jobid parameter passed to the DMF endpoint.
It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the base D365FO environment url.
It will use the "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....." as the bearer token for the endpoint.

.NOTES
        Tags: Download, DMF, Package, Packages
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-DmfPackageDetails {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory = $true)]
        [String] $JobId,

        [Parameter(Mandatory = $true)]
        [string] $AuthenticationToken,

        [Parameter(Mandatory = $true)]
        [string] $Url,

        [switch] $EnableException
    )

    $requestUrl = "$Url/api/connector/dequeue/$JobId"

    $request = New-WebRequest -Url $requestUrl -Action "GET" -AuthenticationToken $AuthenticationToken

    try {
        $response = $request.GetResponse()
            
        $stream = $response.GetResponseStream()
    
        $streamReader = New-Object System.IO.StreamReader($stream)
        
        $res = $streamReader.ReadToEnd()
        $streamReader.Close()

        $res
    }
    catch {
        $messageString = "Something went wrong while importing data through the OData endpoint for the entity: $EntityName"
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_ -StepsUpward 1
        return
    }
}
