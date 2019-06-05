<#
.SYNOPSIS
Acknowledge a DMF package status

.DESCRIPTION
Send an acknowledgement to the DMF endpoint in the Dynamics 365 for Finance & Operations environment

.PARAMETER JobId
JobId of the DMF job you want to acknowledge

.PARAMETER JsonMessage
The json message that you want to pass to the DMF endpoint

.PARAMETER AuthenticationToken
The token value that should be used to authenticate against the URL / URI endpoint

.PARAMETER Url
URL / URI for the D365FO environment you want to access through DMF

.EXAMPLE
PS C:\> Invoke-DmfAcknowledge -JobId "db5e719a-8db3-4fe5-9c78-7be479ce85a2" -JsonMessage '{"CorrelationId": "5acd8121-d4e1-4cf8-b31f-9713de3e3627", "PopReceipt": "AgAAAAMAAAAAAAAA3XpSEQ0b1QE=", "DownloadLocation": "https://usnconeboxax1aos.cloud.onebox.dynamics.com/api/connector/download/%7Bb0b5401e-56ca-4dc8-b566-84389a001236%7D?correlation-id=5acd8121-d4e1-4cf8-b31f-9713de3e3627&blob=c5fbcc38-4f1e-4a81-af27-e6684d9fc217", "IsDownLoadFileExist": True, "FileDownLoadErrorMessage": ""}' -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -AuthenticationToken "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....."

This will acknowledge a DMF package through the DMF endpoint of the D365FO environment.
It will use "db5e719a-8db3-4fe5-9c78-7be479ce85a2" as the jobid parameter passed to the DMF endpoint.
It will use the '{"CorrelationId": "5acd8121-d4e1-4cf8-b31f-9713de3e3627", "PopReceipt": "AgAAAAMAAAAAAAAA3XpSEQ0b1QE=", "DownloadLocation": "https://usnconeboxax1aos.cloud.onebox.dynamics.com/api/connector/download/%7Bb0b5401e-56ca-4dc8-b566-84389a001236%7D?correlation-id=5acd8121-d4e1-4cf8-b31f-9713de3e3627&blob=c5fbcc38-4f1e-4a81-af27-e6684d9fc217", "IsDownLoadFileExist": True, "FileDownLoadErrorMessage": ""}' as the json message that will be passed on to the DMF endpoint.
        It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the base D365FO environment url.
        It will use the "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....." as the bearer token for the endpoint.

.NOTES
Tags: DMF, Package, Acknowledge, Acknowledgement, Ack

Author: Mötz Jensen (@Splaxi)
#>
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

    Write-PSFMessage -Level Verbose -Message "Building request for the ACK of the DMF package." -Target $JobId

    $requestUrl = "$Url/api/connector/ack/$JobId"

    $request = New-WebRequest -Url $requestUrl -Action "POST" -AuthenticationToken $AuthenticationToken -ContentType "application/json"

    Add-WebRequestContent -WebRequest $request -Payload $JsonMessage

    try {
        Write-PSFMessage -Level Verbose -Message "Executing the ACK request against the DMF endpoint." -Target $JsonMessage

        $response = $request.GetResponse()
    }
    catch {
        $messageString = "Something went wrong while trying to acknowledge the DMF Package against the DMF endpoint."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_ -StepsUpward 1
        return
    }

    Write-PSFMessage -Level Verbose -Message "Status code was: $($response.StatusCode)" -Target $response.StatusCode
    
    if ($response.StatusCode -ne [System.Net.HttpStatusCode]::Ok) {
        Write-PSFMessage -Level Verbose -Message "Status code not Ok, Description $($response.StatusDescription)"
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1 -EnableException:$false
        return
    }
}