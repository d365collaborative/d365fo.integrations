
function Get-IntegrationResponse {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [System.Net.WebRequest]$WebRequest
    )

    $integrationResponse = $null;
    $url = $null
    
    try {
        $url = $WebRequest.RequestURI.AbsoluteUri    
        $response = $WebRequest.GetResponse()
    }
    catch {
        
        Write-PSFMessage -Level Critical -Message "Request failed $url"  -Exception $_.Exception
        Stop-PSFFunction -StepsUpward 1 -Message "Stopping"
        return 
        
    }
    if ($response.StatusCode -eq [System.Net.HttpStatusCode]::Ok) {

        Write-PSFMessage -Message "Request Ok $url" -Level Verbose

        $stream = $response.GetResponseStream()
    
        $streamReader = New-Object System.IO.StreamReader($stream);
        
        $integrationResponse = $streamReader.ReadToEnd()
        $streamReader.Close();
    
    }
    else {
        $statusDescription = $response.StatusDescription
        Write-PSFMessage -Message "Request failed $url, Status : $statusDescription" -Level Critical
        Stop-PSFFunction -StepsUpward 1 -Message "Stopping"
    }

    $integrationResponse
}