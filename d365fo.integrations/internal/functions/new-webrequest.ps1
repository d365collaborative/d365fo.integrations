function New-WebRequest {

    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$RequestUrl,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$Action,
        [Parameter(Mandatory = $false, Position = 3)]
        [string]$Payload,
        [Parameter(Mandatory = $false, Position = 4)]
        [string]$DataType,
        [Parameter(Mandatory = $false, Position = 5)]
        [string]$ContentType
    )



    $authToken = New-AuthorizationToken
    if (Test-PSFFunctionInterrupt) {
        Stop-PSFFunction -StepsUpward 1 -Message "Stopping"
        return
    }

    try {


        Write-PSFMessage -Message "New Request $RequestUrl, $Action, $Payload, $DataType, $ContentType " -Level Verbose
        $request = [System.Net.WebRequest]::Create($RequestUrl)
        $request.Headers["Authorization"] = $authToken
        $request.Method = $Action
    
        if ($Action -eq 'POST' -and $null -ne $Payload ) {
    
            $request.ContentType = $ContentType
            Write-PSFMessage -Level verbose  -Message "Request : $dataType"
            
            switch ($dataType) {
                "File" {
                
                    $fileStream = New-Object System.IO.FileStream($Payload, [System.IO.FileMode]::Open)
                    Write-PSFMessage -level Verbose -Message "Length $($fileStream.Length)"
                    $request.ContentLength = $fileStream.Length
                    $stream = $request.GetRequestStream()
                    $fileStream.CopyTo($stream)
                    $fileStream.Flush()
                    $fileStream.Close()
                }
                "Azure" {
                    $Payload.FetchAttributes()
                    Write-PSFMessage -level Verbose -Message "Length $($Payload.Properties.Length)"
                    $request.ContentLength = $Payload.Properties.Length
                    $stream = $request.GetRequestStream()
                    $Payload.DownloadToStream($stream)

                }
                Default {
                    Write-PSFMessage -level Verbose -Message "Length $($Payload.Length)"
                    $request.ContentLength = [System.Text.Encoding]::UTF8.GetByteCount($Payload)
                    $stream = $request.GetRequestStream()
                    $streamWriter = new-object System.IO.StreamWriter($stream)
                    $streamWriter.Write([string]$Payload)
                    $streamWriter.Flush()
                    $streamWriter.Close()
                }
            }

        }
        $request
    }
    catch {
   
        Write-PSFMessage -Level Critical -Message "Exception while creating WebRequest $RequestUrl" -Exception $_.Exception
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1
    }

}