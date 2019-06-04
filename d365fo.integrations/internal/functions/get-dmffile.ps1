<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER DownloadLocation
Parameter description

.PARAMETER Path
Parameter description

.PARAMETER AuthenticationToken
Parameter description

.PARAMETER Retries
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>

function Get-DmfFile {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Url')]
        [Alias('Uri')]
        [string] $DownloadLocation,

        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $AuthenticationToken,

        [int] $Retries = $Script:DmfDownloadRetries
    )

    $DownloadLocation = $DownloadLocation.Replace("http://", "https://").Replace(":80","")
    Write-PSFMessage -Level Verbose -Message "Download path is: $DownloadLocation" -Target $DownloadLocation

    while ($retries -gt 0 ) {
        $request = New-WebRequest -Url $DownloadLocation -Action "GET" -AuthenticationToken $AuthenticationToken

        Get-FileFromWebRequest -WebRequest $request -Path $Path

        if (Test-PSFFunctionInterrupt) {
            $retries = $retries - 1;

            if ($retries -lt 0) {
                Write-PSFMessage -Level Critical "Retries exhausted for $JobId"
                Stop-PSFFunction -Message "Stopping" -StepsUpward 1
                return
            }
        }
        else {
            $retries = 0
        }

    }
}