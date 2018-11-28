function Invoke-DequeueDataManagement {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$JobId,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$FileName
        
    )

    $requestUrl = "$Script:D365FOURL/api/connector/dequeue/$JobId"

    Write-PSFMessage -Level Verbose -Message "Dequeue url : $requestUrl"

    $webRequest = New-WebRequest $requestUrl  "GET"
    if (Test-PSFFunctionInterrupt) {
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1   
        return
    }
    $dequeueResponse = Get-IntegrationResponse -WebRequest $webRequest -ExpectedResult ([System.Net.HttpStatusCode]::Ok) -GetContent 
    
    if (Test-PSFFunctionInterrupt) {
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1   
        return
    }
    $jsonResponse = ConvertFrom-Json  $dequeueResponse

    Write-PSFMessage -Level Verbose -Message "Response: $jsonResponse"
    #TODO The download failes sometimes, but why ?
    
    $retries = 4;

    while ($retries -gt 0 ) {


        Write-PSFMessage -Level Verbose -Message "DownloadLocation: $($jsonResponse.DownloadLocation)"

        $webRequest = New-WebRequest $jsonResponse.DownloadLocation "GET"
        if (Test-PSFFunctionInterrupt) {
            Stop-PSFFunction -Message "Stopping" -StepsUpward 1   
            return
        }

        $response = Save-IntegrationResult $webRequest $FileName
        if (Test-PSFFunctionInterrupt) {
            if ($response -like "*(500)*") { $retries = $retries - 1; }
            else {
                Write-PSFMessage -Level Critical "Error occured $response"
                Stop-PSFFunction -Message "Stopping" -StepsUpward 1 
                return
            }
            if ($retries -eq 0) {
                Write-PSFMessage -Level Critical "Retries exhausted for $JobId"
                Stop-PSFFunction -Message "Stopping" -StepsUpward 1                
                return
            }
        }
        else { $retries = 0}

    }

    $ackUrl = "$Script:D365FOURL/api/connector/ack/$jobId"
    Write-PSFMessage -Level Verbose -Message "Ack url : $ackUrl"

    $webRequest = New-WebRequest $ackUrl "POST" $dequeueResponse "JSON" "application/json"
    if (Test-PSFFunctionInterrupt) {
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1   
        return
    }
    
    $ackResponse = Get-IntegrationResponse -WebRequest $webRequest -ExpectedResult ([System.Net.HttpStatusCode]::Ok) -GetContent
    if (Test-PSFFunctionInterrupt) {
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1   
        return
    }
    Write-PSFMessage -Level Verbose -Message "Ack : $ackResponse"
    
}