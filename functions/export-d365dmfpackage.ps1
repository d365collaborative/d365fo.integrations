<#
.SYNOPSIS
Used for exporting a DMF Package

.DESCRIPTION
Used for downloading a package generated in D365FO with a recurring data job

.PARAMETER D365FOUrl
URL of the D365FO instance

.PARAMETER Authority
The Authority to calidate the ClientId and Secret

.PARAMETER ClientId
Client id registered from the Authority, must also be registed in D365FO and in the Recurring Data Job

.PARAMETER ClientSecret
The secret for the clientId

.PARAMETER JobId
The GUID from the recurring data job

.PARAMETER FileName
The file to store the downloaded content to.

.EXAMPLE
Export-D365DMFPackage -D365FOUrl  "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -Authority "https://sts.windows.net/YourDomain" -ClientId "YouClientId" -ClientSecret "Secret"  -JobId "GUID" -FileName "C:\Temp\Fil1.zip"

.NOTES
Author: Rasmus Andersen (@ITRasmus)
#>
function Export-D365DMFPackage {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$D365FOUrl,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$Authority,
        [Parameter(Mandatory = $true, Position = 3)]
        [string]$ClientId,
        [Parameter(Mandatory = $true, Position = 4)]
        [String]$ClientSecret,
        [Parameter(Mandatory = $true, Position = 5)]
        [String]$JobId,
        [Parameter(Mandatory = $true, Position = 6)]
        [String]$FileName
        
    )

    
    $SessionsVariables = @{
        D365FOUrl    = $D365FOUrl; 
        Authority    = $Authority;
        ClientId     = $ClientId;
        ClientSecret = $ClientSecret;
    }

    Set-AuthoritySession -Values $SessionsVariables

    Write-PSFMessage -Level Verbose -Message "Job $JobId Starting"

    Invoke-DequeueDataManagement $JobId $FileName
    if (Test-PSFFunctionInterrupt) {
        Write-PSFMessage -Level Critical -Message "Job $JobId failed"
        return 
    }
    Write-PSFMessage -Level Important -Message "Job $JobId completed, file saved to $FileName"
    $FileName

}