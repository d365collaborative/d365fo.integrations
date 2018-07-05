function Invoke-DequeueIntegration($Config, $Job, $StorageContext, $Container) {

    $d365FO = $Config.D365FO
    $authority = $Config.Authority
    $clientId = $Config.ClientId
    $clientSecret = $Config.ClientSecret
    $action = $Config.Action
    
    $jobId = $job.Job_Id
    $file = $job.FilePath
    

    $requestUrl = "$D365FO/api/connector/dequeue/$jobId"

    $authorizationHeader = New-AuthorizationHeader $authority $clientId $clientSecret $D365FO

    $webRequest = New-WebRequest $requestUrl $authorizationHeader $action

    $response = Get-IntegrationResponse $webRequest

    $jsonResponse = ConvertFrom-Json  $response

    Write-Verbose "Dequeue response"
    Write-Verbose $jsonResponse

    $retries = 4;

    while ($retries -gt 0 ) {

        try {

            $authorizationHeader = New-AuthorizationHeader $authority $clientId $clientSecret $d365FO
            $webRequest = New-WebRequest $jsonResponse.DownloadLocation $authorizationHeader $action

            Save-IntegrationResult $webRequest $file $config $storageContext $container
            $retries = 0;
        }
        catch {
            if ($_.Message -like "*(500)*" ) {
                $retries = $retries - 1;
            }
            else {
                throw
            }
            if ($retries -eq 0) { throw}
        }
    }

    $authorizationHeader = New-AuthorizationHeader $authority $clientId $clientSecret $d365FO

    $ackUrl = "$d365FO/api/connector/ack/$jobId"
    $webRequest = New-WebRequest $ackUrl $authorizationHeader "POST" $response "JSON" "application/json"
    
    $ackResponse = Get-IntegrationResponse $webRequest

    Write-Verbose "ACK response"
    Write-Verbose $ackResponse
}