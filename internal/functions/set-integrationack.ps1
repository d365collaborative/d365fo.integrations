function Set-IntegrationAck ($WebRequest) {

    $response = $null
    try {

        $response = $WebRequest.GetResponse()
    }
    catch {
        $url = $WebRequest.RequestURI.AbsoluteUri
        write-Error $_.Exception.Message
        Write-Error $_.Exception
        Write-Error $url

        throw 
        #throw "Tried to Ack, Unable to invoke $url"
    }

        if ($response.StatusCode -eq [System.Net.HttpStatusCode]::Ok) {
    
            $stream = $response.GetResponseStream()

            $streamReader = New-Object System.IO.StreamReader($stream);
    
            $result = $streamReader.ReadToEnd()

            $result
        }
        else {
            $statusDescription = $response.StatusDescription
            throw "Https status code : $statusDescription" 
        }

  
}