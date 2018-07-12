<#
.SYNOPSIS
User for creating new entries with odata integration

.DESCRIPTION
Long description

.PARAMETER Configuration
Parameter contains either a string containing json or a filename containing the configuration used for calling D365. 
use Get-D365RestTemplate to get format

.PARAMETER Entity
Name of the Entity ex. data/CurrencyISOCodes. 

.PARAMETER Payload
The payload is either a string containing json or a path to a file

.PARAMETER PayloadFiles
The Array must be like 
$arr = 'Entity','FilePathToJson','Entity','FilePathToJson' and so on

.EXAMPLE
$payload = Get-content C:\Integration\DefGroup1.json | out-string

New-D365Rest "c:\Integration\odataPost.json"  -Entity "data/DataManagementDefinitionGroups" -payload $payload -payloadType "JSON" -verbose

OR

New-D365Rest "c:\Integration\odataPost.json"  -Entity "data/DataManagementDefinitionGroups" -payload C:\Integration\DefGroup1.json -payloadType "File" -verbose

OR

$arr = "data/DataManagementDefinitionGroups","C:\Integration\DefGroup1.json","data/DataManagementDefinitionGroups","C:\Integration\DefGroup2.json"

New-D365Rest "c:\Integration\odataPost.json"  -Entity "data/DataManagementDefinitionGroups" -payload $arr -payloadType "Files" -verbose


.NOTES
General notes
#>
function New-D365Rest {
    [CmdletBinding(DefaultParameterSetName = 'File')]
    param(
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "File")]
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "Files")]
        [string]$Configuration,
        
        [Parameter(Mandatory = $true, Position = 2, ParameterSetName = "File")]
        [string]$Entity,
        
        [Parameter(Mandatory = $true, Position = 3, ParameterSetName = "Files")]
        [Array]$PayloadFiles,
        
        [Parameter(Mandatory = $true, Position = 3, ParameterSetName = "File")]
        [string]$Payload
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



    if($PSCmdlet.ParameterSetName -eq "File")
    {
        if (Test-Path $Configuration) {
            $Payload = Get-Content $Payload
        }
        $PayLoadType = "JSON"
    
    }

    $authorizationHeader = New-AuthorizationHeader $authority $clientId $clientSecret $d365FO


    if($PayLoadType -eq "JSON")
    {
        $Payload = $Payload.Trim()
        $webRequest =  New-WebRequest "$d365FO/$Entity"  $authorizationHeader "POST"  $Payload  $PayLoadType "application/json;odata.metadata=minimal"
    }
    else {
        $webRequest = New-WebRequestBatch $d365FO "data/`$batch" $authorizationHeader "POST" $PayloadFiles
    }

    Get-IntegrationResponse $webRequest


}
