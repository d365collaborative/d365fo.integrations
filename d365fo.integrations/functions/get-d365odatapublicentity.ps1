

function Get-D365ODataPublicEntity {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType()]
    param (

        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string] $EntityName,

        [Parameter(Mandatory = $false, ParameterSetName = "NameContains")]
        [string] $EntityNameContains,

        [Parameter(Mandatory = $false, ParameterSetName = "Query")]
        [string] $ODataQuery,

        [Parameter(Mandatory = $false)]
        [Alias('$AADGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Parameter(Mandatory = $false)]
        [Alias('URI')]
        [string] $URL = $Script:ODataUrl,

        [Parameter(Mandatory = $false)]
        [string] $ClientId = $Script:ODataClientId,

        [Parameter(Mandatory = $false)]
        [string] $ClientSecret = $Script:ODataClientSecret

    )

    $bearerParms = @{
        Resource     = $URL
        ClientId     = $ClientId
        ClientSecret = $ClientSecret
    }

    $bearerParms.AuthProviderUri = "https://login.microsoftonline.com/$Tenant/oauth2/token"

    $bearer = Invoke-ClientCredentialsGrant @bearerParms | Get-BearerToken

    $headerParms = @{
        URL         = $URL
        BearerToken = $bearer
    }

    $headers = New-AuthorizationHeaderBearerToken @headerParms

    [System.UriBuilder] $odataEndpoint = $URL
    $odataEndpoint.Path = "metadata/PublicEntities"

    if (-not ([string]::IsNullOrEmpty($ODataQuery))) {
        $odataEndpoint.Query = "$ODataQuery"
    }
    elseif(-not ([string]::IsNullOrEmpty($EntityName))) {
        $odataEndpoint.Query = "`$filter=tolower(Name) eq tolower('$EntityName') or tolower(EntitySetName) eq tolower('$EntityName')"
    }
    elseif(-not ([string]::IsNullOrEmpty($EntityNameContains))) {
        $odataEndpoint.Query = "`$filter=contains(tolower(Name), tolower('$EntityNameContains')) or contains(tolower(EntitySetName), tolower('$EntityNameContains'))"
    }

    try {
        Invoke-RestMethod -Method Get -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType 'application/json'
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while trying to send a message to the users." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors."
        return
    }
}