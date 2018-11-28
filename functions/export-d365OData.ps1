<#
.SYNOPSIS
#

.DESCRIPTION
Long description

.PARAMETER D365FOUrl
URL of the D365FO instance

.PARAMETER Authority
The Authority to calidate the ClientId and Secret

.PARAMETER ClientId
Client id registered from the Authority, must also be registed in D365FO and in the Recurring Data Job

.PARAMETER ClientSecret
The secret for the clientId

.PARAMETER Entity
Parameter description

.EXAMPLE
An example

.NOTES
Author Rasmus Andersen (@ITRasmus)
#>
function Export-D365OData {
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
        [string]$Entity        
    )

    $SessionsVariables = @{
        D365FOUrl    = $D365FOUrl; 
        Authority    = $Authority;
        ClientId     = $ClientId;
        ClientSecret = $ClientSecret;
    }

    Set-AuthoritySession -Values $SessionsVariables
 
    Write-PSFMessage -Message "Calling $D365FO/$Entity" -Level Verbose


    $webRequest = New-WebRequest "$Script:D365FOUrl/$Entity" "GET" 
    if (Test-PSFFunctionInterrupt) {return}
    
    
    Get-IntegrationResponse -WebRequest $webRequest -ExpectedResult ([System.Net.HttpStatusCode]::Ok) -GetContent

    

}