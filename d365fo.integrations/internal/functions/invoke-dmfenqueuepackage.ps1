
<#
    .SYNOPSIS
        Invoke enqueueing of a DMF Package
        
    .DESCRIPTION
        Enqueue a DMF package to the Dynamics 365 for Finance & Operations environment
        
    .PARAMETER Path
        Path of the file that you want to import into D365FO
        
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
        PS C:\> Invoke-DmfEnqueuePackage -Path "c:\temp\d365fo.tools\dmfpackage.zip" -JobId "db5e719a-8db3-4fe5-9c78-7be479ce85a2" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -AuthenticationToken "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....."
        
        This will upload the dmfpackage to the D365FO DMF endpoint.
        It will use "c:\temp\d365fo.tools\dmfpackage.zip" as the location from where to load the file.
        It will use "db5e719a-8db3-4fe5-9c78-7be479ce85a2" as the jobid parameter passed to the DMF endpoint.
        It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the base D365FO environment url.
        It will use the "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....." as the bearer token for the endpoint.
        
    .NOTES
        Tags: Download, DMF, Package, Packages
        
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-DmfEnqueuePackage {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [String] $JobId,

        [Parameter(Mandatory = $true)]
        [string] $AuthenticationToken,

        [Parameter(Mandatory = $true)]
        [string] $Url,

        [switch] $EnableException
    )

    Write-PSFMessage -Level Verbose -Message "Building request for the DMF Package enqueue endpoint." -Target $JobId

    $requestUrl = "$Url/api/connector/enqueue/$JobId"

    $request = New-WebRequest -Url $requestUrl -Action "POST" -AuthenticationToken $AuthenticationToken -ContentType "application/zip"

    Add-WebRequestContentFromFile -WebRequest $request -Path $Path

    try {
        Write-PSFMessage -Level Verbose -Message "Executing the request against the DMF Package enqueue endpoint."

        $response = $request.GetResponse()

        Write-PSFMessage -Level Verbose -Message "Response completed ($($request.ContentLength))."
    }
    catch {
        $messageString = "Something went wrong while enqueueing through the DMF Package endpoint for the JobId: $JobId"
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $JobId
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_ -StepsUpward 1
        return
    }

    Write-PSFMessage -Level Verbose -Message "Status code was: $($response.StatusCode)" -Target $response.StatusCode
    
    #Might need another status code to be correct
    if ($response.StatusCode -ne [System.Net.HttpStatusCode]::Ok) {
        Write-PSFMessage -Level Verbose -Message "Status code not Ok, Description $($response.StatusDescription)"
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1 -EnableException:$false
        return
    }

    $stream = $response.GetResponseStream()
    
    $streamReader = New-Object System.IO.StreamReader($stream);
        
    $res = $streamReader.ReadToEnd()
    $streamReader.Close();
        
    $res
}