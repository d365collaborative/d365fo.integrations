function Invoke-EnqueueDataManagement {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$JobId,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$FileName
            
    )


    $requestUrl = "$Script:D365FOURL/api/connector/enqueue/$JobId"

    Write-PSFMessage -Level Verbose -Message "Enqueue url : $requestUrl"

    $webRequest = New-WebRequest $requestUrl "POST" $FileName "File" "application/zip"
    if (Test-PSFFunctionInterrupt) {
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1
        return
    }


    $response = Get-IntegrationResponse -WebRequest $webRequest -ExpectedResult ([System.Net.HttpStatusCode]::Ok) -GetContent
    if (Test-PSFFunctionInterrupt) {
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1
        return
    }

    $response
}