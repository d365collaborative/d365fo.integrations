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
    
        Write-PSFMessage -Level Verbose -Message "Creating file stream for $Path." -Target $Path
        $fileStream = [System.IO.File]::Create($Path)

        $stream.CopyTo($fileStream)

        Write-PSFMessage -Level Verbose -Message "Close file stream."

        # $fileStream.Flush()
        $fileStream.Close()
    }
    else {
        Write-PSFMessage -Level Verbose -Message "Status code not Ok, Description $($response.StatusDescription)"
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1 -EnableException:$false
        return
    }
}