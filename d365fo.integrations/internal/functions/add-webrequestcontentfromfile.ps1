function Add-WebrequestContentFromFile {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Net.WebRequest] $Request,

        [Parameter(Mandatory = $true)]
        [string] $Path

    )

    if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

    try {
    
        $fileStream = New-Object System.IO.FileStream($Path, [System.IO.FileMode]::Open)
        Write-PSFMessage -level Verbose -Message "Length $($fileStream.Length)"
        $request.ContentLength = $fileStream.Length
        $stream = $request.GetRequestStream()
        $fileStream.CopyTo($stream)
        $fileStream.Flush()
        $fileStream.Close()
    }
    catch {
        Write-PSFMessage -Level Critical -Message "Exception while creating WebRequest $RequestUrl" -Exception $_.Exception
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1
    }
}