function Save-IntegrationResult ($WebRequest, $File, $Config, $StorageContext, $Container) {

    Write-Verbose "Saving to file $File"

    $response = $null
    
    try {

        $response = $WebRequest.GetResponse()
    }
    catch {
        $url = $webRequest.RequestURI.AbsoluteUri
        write-Error $_.Exception.Message
        Write-Error $_.Exception
        Write-Error $url
        throw 
        #throw "Tried to save result, Unable to invoke $url"
    }
    if ($response.StatusCode -eq [System.Net.HttpStatusCode]::Ok) {

        $stream = $response.GetResponseStream()
    
        if ($config.Storage -eq "azure") {
    
            $cloudStorageAccount = [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($StorageContext.ConnectionString)
    
            $blobClient = $cloudStorageAccount.CreateCloudBlobClient()
    
            $blobcontainer = $blobClient.GetContainerReference($Container.Name);
    
            $blockBlob = $blobcontainer.GetBlockBlobReference($File);
    
            $blockBlob.UploadFromStream($stream);
    
        }
        else {
            
            $fileStream = [System.IO.File]::Create($File)
    
            $stream.CopyTo($fileStream)
    
            $fileStream.Close()
        }
        
            
    }
    else {
        $statusDescription = $response.StatusDescription
        throw "Https status code : $statusDescription" 
    }
    
   
    
    
}