
function Get-IntegrationResponse ($WebRequest) {

    $integrationResponse = $null;

    try {

        $response = $WebRequest.GetResponse()
    }
    catch {
        $url = $WebRequest.RequestURI.AbsoluteUri
        write-Error $_.Exception.Message
        Write-Error $_.Exception
        write-Error $url

        throw
        
    }
    if ($response.StatusCode -eq [System.Net.HttpStatusCode]::Ok) {

        $stream = $response.GetResponseStream()
    
        $streamReader = New-Object System.IO.StreamReader($stream);
        
        $integrationResponse = $streamReader.ReadToEnd()
        $streamReader.Close();
    
    }
    else {
        $statusDescription = $response.StatusDescription
        throw "Https status code : $statusDescription" 
    }

    $integrationResponse
    

}