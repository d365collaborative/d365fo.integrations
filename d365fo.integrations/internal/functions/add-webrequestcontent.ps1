function Add-WebRequestContent {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Net.WebRequest] $Request,
        
        [Parameter(Mandatory = $true)]
        [string] $Payload
    )

    try {
        $Request.ContentLength = [System.Text.Encoding]::UTF8.GetByteCount($Payload)
        $stream = $Request.GetRequestStream()
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