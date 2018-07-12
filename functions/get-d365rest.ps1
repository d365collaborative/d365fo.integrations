<#
.SYNOPSIS
Used for getting OData from D365FO

.DESCRIPTION
Function calls the OData service in D365FO, returns a string as the result

.PARAMETER Configuration
Parameter contains either a string containing json or a filename containing the configuration used for calling D365. 
use Get-D365RestTemplate to get format

.PARAMETER Entity
Name of the Entity ex.  data/CurrencyISOCodes or just data for getting every odata service 

.EXAMPLE

Get-D365Rest ".\ODataConfiguration.json"  -Entity "data"

Get-D365Rest ".\ODataConfiguration.json"  -Entity "data/CurrencyISOCodes"

Get-D365Rest ".\ODataConfiguration.json"  -Entity "data/CurrencyISOCodes?`$orderby=ISOCurrencyCode"

Get-D365Rest ".\ODataConfiguration.json"  -Entity "data/CurrencyISOCodes?`$filter=ISOCurrencyCode eq 'DKK'"

.NOTES
General notes
#>
function Get-D365Rest {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Configuration,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$Entity        
    )

    if (Test-Path $Configuration) {
        $config = Get-Content $Configuration | Out-String | ConvertFrom-Json -ErrorAction Stop
    }
    else {
        $config = $Configuration | ConvertFrom-Json -ErrorAction Stop
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
