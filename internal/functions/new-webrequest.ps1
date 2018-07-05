function New-WebRequest ($RequestUrl, $AuthorizationHeader, $Action, $Payload, $DataType, $ContentType) {

    
    Write-Verbose "New Request $RequestUrl, $Action"        
    $request = [System.Net.WebRequest]::Create($RequestUrl)
    $request.Headers["Authorization"] = $AuthorizationHeader.CreateAuthorizationHeader()
    $request.Method = $Action
    
    if ($Action -eq 'POST' -and $Payload -ne $null ) {
    
        $request.ContentType = $ContentType
        $stream = $request.GetRequestStream()
        #TODO Length if file

        switch ($dataType) {
            "File" {
                
                $fileStream = New-Object System.IO.FileStream($Payload)

                $request.ContentLength = $fileStream.Length

                $fileStream.CopyTo($stream)
                $fileStream.Flush()
                $fileStream.Close()
            }
            "Azure" {
                $Payload.FetchAttributes()
                $request.ContentLength = $Payload.Properties.Length

                $payload.DownloadToStream($stream)
            }
            Default {
                $request.ContentLength = $Payload.Length
                $streamWriter = new-object System.IO.StreamWriter($stream)
                $streamWriter.Write([string]$Payload)
                $streamWriter.Flush()
                $streamWriter.Close()    
            }
        }

    }
    $request

}