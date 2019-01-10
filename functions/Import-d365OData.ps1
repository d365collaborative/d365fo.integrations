<#
.SYNOPSIS
User for creating new entries with odata integration

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

.PARAMETER Payload
An Array with the payload designed like @("entity","JSON","entity","JSON")

.EXAMPLE

$Padawan = '{ "@odata.type": "#Microsoft.Dynamics.DataEntities.Title","TitleId" : "Jedi Padawan"}' 
$Initiate = '{ "@odata.type": "#Microsoft.Dynamics.DataEntities.Title","TitleId" : "Jedi Initiate"}'

$payload = @("data/Titles",$Initiate,"data/Titles",$Padawan)


Import-D365OData -D365FOUrl  "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -Authority "https://sts.windows.net/YourDomain" -ClientId "YouClientId" -ClientSecret "Secret"  -Payload $payload

.NOTES
General notes
#>
function Import-D365OData {
    [CmdletBinding()]
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
        [array]$Payload
    )


    if ($PayLoad.Count % 2 -eq 1 ) {
    
        Write-PSFMessage -Level Critical -Message "Payload count is not even $($PayLoad.Count)"
        Stop-PSFFunction -Message "Stopping"
    }

    $SessionsVariables = @{
        D365FOUrl    = $D365FOUrl
        Authority    = $Authority
        ClientId     = $ClientId
        ClientSecret = $ClientSecret
    }

    Set-AuthoritySession -Values $SessionsVariables


    if ($Payload.Length -eq 2) {
        $singleEntity = $Payload[0].Trim()
        $singlePayLoad = $Payload[1].Trim()
        $webRequest = New-WebRequest "$D365FOUrl/$singleEntity" "POST"  $singlePayLoad  "JSON" "application/json;odata.metadata=minimal"
    }
    else {
        $webRequest = New-WebRequestBatch "$D365FOUrl/data/`$batch" "POST" $Payload
    }
    if (Test-PSFFunctionInterrupt) {return}
    
    Get-IntegrationResponse -WebRequest $webRequest -ExpectedResult ([System.Net.HttpStatusCode]::Created) -GetContent


}