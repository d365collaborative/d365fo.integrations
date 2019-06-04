
<#
    .SYNOPSIS
        Add content from file to a Web Request
        
    .DESCRIPTION
        Read the content from a file and put it into the Web Request object
        
    .PARAMETER WebRequest
        The Web Request object that you want to add the content of the file to
        
    .PARAMETER Path
        Path to the file you want to add to the Web Request object
        
    .EXAMPLE
        PS C:\> $request = New-WebRequest -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com/api/connector/enqueue/123456789" -Action "POST" -AuthenticationToken "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....."
        PS C:\> Add-WebRequestContentFromFile -WebRequest $request -Path "c:\temp\d365fo.tools\dmfpackage.zip"
        
        This will add the file content to the Web Request.
        It will create a new Web Request object.
        It will use the "c:\temp\d365fo.tools\dmfpackage.zip" path to read the file content.
        
    .LINK
        New-WebRequest
        
    .NOTES
        Tags: Request, DMF, Package, Packages
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Add-WebRequestContentFromFile {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Net.WebRequest] $WebRequest,

        [Parameter(Mandatory = $true)]
        [string] $Path

    )

    if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

    try {
    
        $fileStream = New-Object System.IO.FileStream($Path, [System.IO.FileMode]::Open)
        
        Write-PSFMessage -Level Debug -Message "Length $($fileStream.Length)"
        
        $WebRequest.ContentLength = $fileStream.Length
        $stream = $WebRequest.GetRequestStream()
        $fileStream.CopyTo($stream)
        $fileStream.Flush()
        $fileStream.Close()
    }
    catch {
        Write-PSFMessage -Level Critical -Message "Exception while adding the file content to the WebRequest" -Exception $_.Exception
        Stop-PSFFunction -Message "Stopping" -StepsUpward 1
    }
}