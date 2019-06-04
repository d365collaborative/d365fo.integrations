
<#
    .SYNOPSIS
        Get file from Web Request
        
    .DESCRIPTION
        Extract the file from the Web Request object
        
    .PARAMETER WebRequest
        The Web Request object that you want to add the content to
        
    .PARAMETER Path
        Path where you want to store the file on your local infrastructure
        
    .EXAMPLE
        PS C:\> $request = New-WebRequest -Action "GET" -AuthenticationToken "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....." -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com/api/connector/download/%7Bb0b5401e-56ca-4dc8-b566-84389a001236%7D?correlation-id=5acd8121-d4e1-4cf8-b31f-9713de3e3627&blob=c5fbcc38-4f1e-4a81-af27-e6684d9fc217"
        PS C:\> Get-FileFromWebRequest -WebRequest $request -Path "c:\temp\d365fo.tools\dmfpackage.zip"
        
        This will extract the file the Web Request.
        It will create a new Web Request.
        It will pass the $request variable to the function.
        It will use "c:\temp\d365fo.tools\dmfpackage.zip" as the path where the file should be stored.
        
    .NOTES
        Tags: DMF, Download
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-FileFromWebRequest {
    param(
        [Parameter(Mandatory = $true)]
        [System.Net.WebRequest] $WebRequest,

        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [string] $Path
    )

    Write-PSFMessage -Level Verbose -Message "Saving to file $FileName"

    $response = $null
    
    try {
        $response = $WebRequest.GetResponse()
    }
    catch {
        Write-PSFMessage -Level Verbose -Message "Error getting response from $($webRequest.RequestURI.AbsoluteUri)" -Exception $_.Exception
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1 -EnableException:$false
        return
    }

    if ($response.StatusCode -eq [System.Net.HttpStatusCode]::Ok) {
        Write-PSFMessage -Level Verbose -Message "Status code was 'OK' - Extracting the stream."

        $stream = $response.GetResponseStream()
    
        Write-PSFMessage -Level Debug -Message "Creating file stream for $Path." -Target $Path
        $fileStream = [System.IO.File]::Create($Path)

        $stream.CopyTo($fileStream)

        Write-PSFMessage -Level Debug -Message "Close file stream."

        # $fileStream.Flush()
        $fileStream.Close()
    }
    else {
        Write-PSFMessage -Level Verbose -Message "Status code not Ok, Description $($response.StatusDescription)"
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1 -EnableException:$false
        return
    }
}