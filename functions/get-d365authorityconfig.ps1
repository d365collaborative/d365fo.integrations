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
Name of the Config to get

.EXAMPLE
An example

.NOTES
Author Rasmus Andersen (@ITRasmus)
#>
function Get-D365AuthorityConfig {
    param(
        [Parameter(Mandatory = $True, Position = 1)]
        [string] $ConfigName
    )

    $pSFConfig = Get-PSFConfig -FullName "$Script:AuthorityConfig$ConfigName"

    if ($pSFConfig.Count -eq 0) {
        Write-PSFMessage -Level Important -Message "Unable to locate the <c='em'>configuration objects</c> on the machine. Please make sure that you ran <c='em'>Set-D365AuthorityConfig</c> first."
        Stop-PSFFunction -Message "Stopping because unable to locate configuration objects for $ConfigName."
        return
    }
    else {
        
        $config = $pSFConfig.Value
        @{
            D365FOUrl    = $config.D365FOUrl; 
            Authority    = $config.Authority;
            ClientId     = $config.ClientId;
            ClientSecret = $config.ClientSecret;
        }
        
    }

}