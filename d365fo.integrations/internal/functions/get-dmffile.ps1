
<#
    .SYNOPSIS
        Get the DMF Package file
        
    .DESCRIPTION
        Get / Download the DMF package file from the Dynamics 365 for Finance & Operations environment
        
    .PARAMETER DownloadLocation
        The URI / URL where the DMF package file is available
        
    .PARAMETER Path
        Path where you want to store the file on your local infrastructure
        
    .PARAMETER AuthenticationToken
        The token value that should be used to authenticate against the URL / URI endpoint
        
    .PARAMETER Retries
        Number of retries the module should use to download the file
        
    .EXAMPLE
        PS C:\> Get-DmfFile -Path "c:\temp\d365fo.tools\dmfpackage.zip" -AuthenticationToken "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....." -DownloadLocation "https://usnconeboxax1aos.cloud.onebox.dynamics.com/api/connector/download/%7Bb0b5401e-56ca-4dc8-b566-84389a001236%7D?correlation-id=5acd8121-d4e1-4cf8-b31f-9713de3e3627&blob=c5fbcc38-4f1e-4a81-af27-e6684d9fc217"
        
        This will download the DMF Package from D365FO.
        It will use "c:\temp\d365fo.tools\dmfpackage.zip" as the location to save the file.
        It will use the "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....." as the bearer token for the endpoint.
        It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com/api/connector/download/%7Bb0b5401e-56ca-4dc8-b566-84389a001236%7D?correlation-id=5acd8121-d4e1-4cf8-b31f-9713de3e3627&blob=c5fbcc38-4f1e-4a81-af27-e6684d9fc217" as the request URL / URI to download the DMF Package from.
        
    .NOTES
        Tags: Download, DMF, Package, Packages
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-DmfFile {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Url')]
        [Alias('Uri')]
        [string] $DownloadLocation,

        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $AuthenticationToken,

        [int] $Retries = $Script:DmfDownloadRetries
    )

    process {
        if ($DownloadLocation.StartsWith("http://")) {
            $DownloadLocation = $DownloadLocation.Replace("http://", "https://").Replace(":80", "")
        }

        Write-PSFMessage -Level Verbose -Message "Download URI / URL for the DMF Package is: $DownloadLocation" -Target $DownloadLocation

        $retriesLocal = $Retries

        while ($retriesLocal -gt 0 ) {
            $attemptNo = ($Retries - $retriesLocal) + 1
            Write-PSFMessage -Level Verbose -Message "($attemptNo) - Building request for downloading the DMF Package." -Target $DownloadLocation

            $request = New-WebRequest -Url $DownloadLocation -Action "GET" -AuthenticationToken $AuthenticationToken

            Get-FileFromWebRequest -WebRequest $request -Path $Path

            if (Test-PSFFunctionInterrupt) {
                Write-PSFMessage -Level Verbose -Message "($attemptNo) - Downloading the DMF Package failed."
            
                $retriesLocal = $retriesLocal - 1;

                if ($retriesLocal -lt 0) {
                    Write-PSFMessage -Level Critical "Number of retries exhausted for JobId: $JobId"
                    Stop-PSFFunction -Message "Stopping" -StepsUpward 1
                    return
                }
            }
            else {
                $retriesLocal = 0
            }
        }
    }
}