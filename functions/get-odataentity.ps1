<#
.SYNOPSIS
Used for getting OData from D365FO

.DESCRIPTION
Function calls the OData service in D365FO, returns a string as the result

.PARAMETER Configuration
Parameter contains either a string containing json or a filename containing the configuration used for calling D365. 
use Get-ODataTemplate to get format

.PARAMETER ConfigurationType
Is the Configuration a file or String

.PARAMETER Entity
Name of the Entity ex.  data/CurrencyISOCodes or just data for getting every odata service 

.EXAMPLE

Get-ODataEntity ".\ODataConfiguration.json"  -ConfigurationType "File" -Entity "data"

Get-ODataEntity ".\ODataConfiguration.json"  -ConfigurationType "File" -Entity "data/CurrencyISOCodes"

Get-ODataEntity ".\ODataConfiguration.json"  -ConfigurationType "File" -Entity "data/CurrencyISOCodes?`$orderby=ISOCurrencyCode"

Get-ODataEntity ".\ODataConfiguration.json"  -ConfigurationType "File" -Entity "data/CurrencyISOCodes?`$filter=ISOCurrencyCode eq 'DKK'"

.NOTES
General notes
#>
function Get-ODataEntity {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Configuration,
        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateSet('File', 'String')]
        [string]$ConfigurationType,
        [Parameter(Mandatory = $true, Position = 3)]
        [string]$Entity        
    )

    if ($ConfigurationType -eq "File") {
        $config = Get-Content $Configuration | Out-String | ConvertFrom-Json 
    }
    else {
        $config = $Configuration | ConvertFrom-Json 
    }

    $null = add-type -path "$script:PSModuleRoot\internal\dll\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"

    $d365FO = $Config.D365FO
    $authority = $Config.Authority
    $clientId = $Config.ClientId
    $clientSecret = $Config.ClientSecret


    Write-Verbose "$D365FO/$Entity"
    $authorizationHeader = New-AuthorizationHeader $authority $clientId $clientSecret $d365FO
    $webRequest = New-WebRequest "$d365FO/$Entity" $authorizationHeader "GET" 
    
    Get-IntegrationResponse $webRequest

    

}