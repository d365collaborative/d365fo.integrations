function New-WebRequestBatch {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$RequestUrl,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$Action,
        [Parameter(Mandatory = $false, Position = 3)]
        [Array]$Payload
        
    )

    Write-PSFMessage -Level Verbose -Message "New Batch Request $RequestUrl, $Action"

    $authToken = New-AuthorizationToken
    if (Test-PSFFunctionInterrupt) {
        Stop-PSFFunction -StepsUpward 1 -Message "Stopping"
        return
    }

    $idbatch = $(New-Guid).ToString()
    $idchangeset = $(New-Guid).ToString()

    $batchPayload = "--batch_$idbatch"
    $changesetPayload = "--changeset_$idchangeset"

    $request = [System.Net.WebRequest]::Create("$RequestUrl")
    $request.Headers["Authorization"] = $authToken
    $request.Method = $Action
    $request.ContentType = "multipart/mixed; boundary=batch_$idBatch"

    $data = "--$batchPayLoad `r`n"
    $data += "Content-Type: multipart/mixed; boundary=changeset_$idchangeset `r`n`r`n"
    $data += "$changeSetPayLoad `r`n"


    $payLoadEnumerator = $PayLoad.GetEnumerator()
    $counter = 0
    while ($payLoadEnumerator.MoveNext()) {

        $counter ++
        $localEntity = $payLoadEnumerator.Current
        $null = $payLoadEnumerator.MoveNext()
        $localPayload = $payLoadEnumerator.Current.Trim()

        $data += New-BatchContent  "$Script:D365FOURL/$localEntity" $authToken $LocalPayload $counter

        if ($PayLoad.Count -eq ($counter * 2)) {
            $data += "$changesetPayload--`r`n"
        }
        else {
            $data += "$changesetPayload`r`n"
        }
    }
    
    
    $data += "$batchPayload--"

    Write-PSFMessage -Level VeryVerbose -Message $data -Tag "Webrequest.DATA"
    $request.ContentLength = $data.Length

    $stream = $request.GetRequestStream()
    $streamWriter = new-object System.IO.StreamWriter($stream)
    $streamWriter.Write([string]$data);
    $streamWriter.Flush();
    
    $request

}