function Save-IntegrationResult {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [System.Net.WebRequest]$WebRequest,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$FileName
    )

    Write-PSFMessage -Level Verbose -Message "Saving to file $FileName"

    $response = $null
    
    try {

        $response = $WebRequest.GetResponse()
    }
    catch {
        Write-PSFMessage -Level Verbose -Message "Error getting response from $($webRequest.RequestURI.AbsoluteUri)" -Exception $_.Exception
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1gget
        return
    }
    if ($response.StatusCode -eq [System.Net.HttpStatusCode]::Ok) {

        $stream = $response.GetResponseStream()
    
        $fileStream = [System.IO.File]::Create($FileName)

        $stream.CopyTo($fileStream)

        $fileStream.Close()
        
    }
    else {
        
        Write-PSFMessage -Level Verbose -Message "Status code not Ok, Description $($response.StatusDescription)"
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1
        return 
    }
    
    
}