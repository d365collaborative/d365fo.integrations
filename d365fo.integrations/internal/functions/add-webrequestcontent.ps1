
<#
    .SYNOPSIS
        Add content to a Web Request
        
    .DESCRIPTION
        Add the payload as content into the Web Request object
        
    .PARAMETER WebRequest
        The Web Request object that you want to add the content to
        
    .PARAMETER Payload
        The entire string contain the json object that you want to pass to the D365FO environment
        
    .EXAMPLE
        PS C:\> $request = New-WebRequest -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com/api/connector/ack/123456789" -Action "POST" -AuthenticationToken "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....."
        PS C:\> Add-WebRequestContentFromFile -WebRequest $request -Payload '{"CorrelationId": "5acd8121-d4e1-4cf8-b31f-9713de3e3627", "PopReceipt": "AgAAAAMAAAAAAAAA3XpSEQ0b1QE=", "DownloadLocation": "https://usnconeboxax1aos.cloud.onebox.dynamics.com/api/connector/download/%7Bb0b5401e-56ca-4dc8-b566-84389a001236%7D?correlation-id=5acd8121-d4e1-4cf8-b31f-9713de3e3627&blob=c5fbcc38-4f1e-4a81-af27-e6684d9fc217", "IsDownLoadFileExist": True, "FileDownLoadErrorMessage": ""}'
        
        This will add the payload content to the Web Request.
        It will create a new Web Request object.
        It will use the '{"CorrelationId": "5acd8121-d4e1-4cf8-b31f-9713de3e3627", "PopReceipt": "AgAAAAMAAAAAAAAA3XpSEQ0b1QE=", "DownloadLocation": "https://usnconeboxax1aos.cloud.onebox.dynamics.com/api/connector/download/%7Bb0b5401e-56ca-4dc8-b566-84389a001236%7D?correlation-id=5acd8121-d4e1-4cf8-b31f-9713de3e3627&blob=c5fbcc38-4f1e-4a81-af27-e6684d9fc217", "IsDownLoadFileExist": True, "FileDownLoadErrorMessage": ""}' as the payload content to add to the web request.
        
    .LINK
        New-WebRequest
        
    .NOTES
        Tags: Request, DMF, Package, Packages
        
        Author: Mötz Jensen (@Splaxi)
        
#>
#
function Add-WebRequestContent {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Net.WebRequest] $WebRequest,
        
        [Parameter(Mandatory = $true)]
        [string] $Payload
    )

    Write-PSFMessage -Level Verbose -Message "Parsing the payload and adding it to the web request." -Target $Payload

    try {
        $WebRequest.ContentLength = [System.Text.Encoding]::UTF8.GetByteCount($Payload)

        $stream = $WebRequest.GetRequestStream()
        $streamWriter = new-object System.IO.StreamWriter($stream)
        $streamWriter.Write([string]$Payload)
        $streamWriter.Flush()
        $streamWriter.Close()
    }
    catch {
        Write-PSFMessage -Level Critical -Message "Exception while creating WebRequest $RequestUrl" -Exception $_.Exception
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1
    }
}