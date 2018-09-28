<#
.SYNOPSIS
Store the configuration used for either the source or destination system.

.DESCRIPTION
Store the configuration used for either the source or destination system.
Enables the calling of integration or rest functions without the parameters stored in the function

.PARAMETER Authority
Autority to validate ClientId and ClientSecret with used Url

.PARAMETER ClientId
ClientId to validate

.PARAMETER ClientSecret
Secret to validate

.PARAMETER ConfigName
Name of the Config to store

.EXAMPLE

An example

.NOTES
Author Rasmus Andersen (@ITRasmus)
#>
function Set-D365AuthorityConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1 )]
        [string] $D365FOUrl,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string] $Authority,
        [Parameter(Mandatory = $true, Position = 3)]
        [string] $ClientId,
        [Parameter(Mandatory = $true, Position = 4)]
        [string] $ClientSecret,
        [Parameter(Mandatory = $True, Position = 5)]
        [string] $ConfigName,
        [Parameter(Mandatory = $false, Position = 6)]
        [switch] $Persist

    )

    $Details = @{D365FOUrl = $D365FOUrl; Authority = $Authority; ClientId = $ClientId;
        ClientSecret = $ClientSecret;
    }

    Write-PSFMessage -Message "Saving Config $Details to $Script:AuthorityConfig$ConfigName"
    Set-PSFConfig -FullName "$Script:AuthorityConfig$ConfigName" -Value $Details   
    $config = Get-PSFConfig -FullName "$Script:AuthorityConfig$ConfigName"
    
    if ($Persist) {
        Register-PSFConfig  -Config $config
    }
    Get-D365AuthorityConfig -ConfigName $ConfigName
}