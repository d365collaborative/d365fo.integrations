
function Invoke-DmfAcknowledge {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [String] $JobId,

        [Parameter(Mandatory = $true)]
        [string] $JsonMessage,

        [Parameter(Mandatory = $true)]
        [string] $AuthenticationToken,

        [Parameter(Mandatory = $true)]
        [string] $Url
    )

    $requestUrl = "$Url/api/connector/ack/$JobId"

    $request = New-WebRequest -Url $requestUrl -Action "POST" -AuthenticationToken $AuthenticationToken -ContentType "application/json"

    Add-WebRequestContent -Request $request -Payload $JsonMessage

    try {
        $response = $request.GetResponse()
            
        $stream = $response.GetResponseStream()
    
        $streamReader = New-Object System.IO.StreamReader($stream)
        
        $res = $streamReader.ReadToEnd()
        $streamReader.Close()

        $res
    }
    catch {
        $messageString = "Something went wrong while importing data through the OData endpoint for the entity: $EntityName"
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_ -StepsUpward 1
        return
    }
}