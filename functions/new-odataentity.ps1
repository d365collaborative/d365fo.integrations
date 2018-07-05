<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Configuration
Parameter contains either a string containing json or a filename containing the configuration used for calling D365. 
use Get-ODataTemplate to get format

.PARAMETER ConfigurationType
Is the Configuration a file or String

.PARAMETER Entity
Name of the Entity ex. data/CurrencyISOCodes, of the PayLoadType is Files, this one is not used

.PARAMETER Payload
The payload must either be a FilePath, a string containing the JSON, or a Array.
The Array must be like 
$arr = 'Entity','FilePathToJson','Entity','FilePathToJson' and so on

.PARAMETER PayLoadType
Is the Payload either a File, JSON or Files

.EXAMPLE
$payload = Get-content C:\Integration\DefGroup1.json | out-string

New-ODataEntity "c:\Integration\odataPost.json"  -ConfigurationType "File" -Entity "data/DataManagementDefinitionGroups" -payload $payload -payloadType "JSON" -verbose

OR

New-ODataEntity "c:\Integration\odataPost.json"  -ConfigurationType "File" -Entity "data/DataManagementDefinitionGroups" -payload C:\Integration\DefGroup1.json -payloadType "File" -verbose

OR

$arr = "data/DataManagementDefinitionGroups","C:\Integration\DefGroup1.json","data/DataManagementDefinitionGroups","C:\Integration\DefGroup2.json"

New-ODataEntity "c:\Integration\odataPost.json"  -ConfigurationType "File" -Entity "data/DataManagementDefinitionGroups" -payload $arr -payloadType "Files" -verbose


.NOTES
General notes
#>
function New-ODataEntity {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Configuration,
        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateSet('File', 'JSON')]
        [string]$ConfigurationType,
        [Parameter(Mandatory = $true, Position = 3)]
        [string]$Entity,
        [Parameter(Mandatory = $true, Position = 4)]
        [string]$Payload,
        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateSet('File', 'JSON','Files')]
        [string]$PayLoadType
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

    if($PayLoadType -eq "File")
    {
        $Payload = Get-Content $Payload
        $PayLoadType = "JSON"
    }

    $authorizationHeader = New-AuthorizationHeader $authority $clientId $clientSecret $d365FO


    if($PayLoadType -eq "JSON")
    {
        $Payload = $Payload.Trim()
        $webRequest =  New-WebRequest "$d365FO/$Entity"  $authorizationHeader "POST"  $Payload  $PayLoadType "application/json;odata.metadata=minimal"
    }
    else {
        $webRequest = New-WebRequestBatch $d365FO "data/`$batch" $authorizationHeader "POST" $Payload
    }

    Get-IntegrationResponse $webRequest


}