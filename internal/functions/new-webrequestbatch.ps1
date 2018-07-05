function New-WebRequestBatch ($D365FO, $RequestUrl, $AuthorizationHeader, $Action, $Payloads)  
{

    Write-Verbose "New Request "$D365FO/$RequestUrl", $Action"        


    $idbatch = New-Guid
    $idbatch= $idbatch.ToString()
    $idchangeset = New-Guid
    $idchangeset= $idchangeset.ToString()
    $batchPayload = "--batch_$idbatch"
    $changesetPayload = "--changeset_$idchangeset"

    Write-Verbose "Batch $idBatch"
    Write-Verbose "Changeset $idchangeset"

    $authHeader = $authorizationHeader.CreateAuthorizationHeader()

    $request = [System.Net.WebRequest]::Create("$D365FO/$requestUrl")
    $request.Headers["Authorization"]  = $authHeader
    $request.Method = $action
    $request.ContentType = "multipart/mixed; boundary=batch_$idBatch"

    $data =  "--$batchPayLoad `r`n"
    $data += "Content-Type: multipart/mixed; boundary=changeset_$idchangeset `r`n`r`n"
    $data += "$changeSetPayLoad `r`n"

    if($PayLoads.Count % 2  -eq 1 ) { throw "PayLoad is not divideable with 2"}

    $payLoadEnumerator = $Payloads.GetEnumerator()
    $counter = 0
    while($payLoadEnumerator.movenext())
    { 
        $counter ++
        $entity  = $payLoadEnumerator.Current
        $payLoadEnumerator.movenext()
        $entityFile  = $payLoadEnumerator.Current
        $payload = Get-Content -Path $entityFile
        $payload.Trim()
        $data += New-BatchContent $counter "$D365FO/$entity" $authHeader  $payload
    }
    
    $data += "$changesetPayload--`r`n"
    $data += "$batchPayload--"
    $webRequest.ContentLength = $data.Length

    $stream = $webRequest.GetRequestStream()
    $streamWriter = new-object System.IO.StreamWriter($stream)
    $streamWriter.Write([string]$data);
    $streamWriter.Flush();
    
    $request

}