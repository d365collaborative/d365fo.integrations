

function Get-D365ODataEntityData {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "Specific")]
        [Alias('EntityName')]
        [string] $Name,

        [Parameter(Mandatory = $true, ParameterSetName = "Default", ValueFromPipelineByPropertyName = $true)]
        [Alias('CollectionName')]
        [string] $EntitySetName,

        [Parameter(Mandatory = $false)]
        [string] $ODataQuery,

        [Parameter(Mandatory = $false)]
        [switch] $CrossCompany,

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

    begin {
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
    }

    process {
        
        [System.UriBuilder] $odataEndpoint = $URL
        
        if (-not ([string]::IsNullOrEmpty($Name))) {
            $odataEndpoint.Path = "data/$Name"
        }
        else {
            $odataEndpoint.Path = "data/$EntitySetName"
        }

        if (-not ([string]::IsNullOrEmpty($ODataQuery))) {
            $odataEndpoint.Query = "$ODataQuery"
        }
        
        if($CrossCompany){
            $odataEndpoint.Query = $($odataEndpoint.Query + "&cross-company=true").Replace("?", "")
        }

        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
            Invoke-RestMethod -Method Get -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType 'application/json'
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while trying to send a message to the users." -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors."
            return
        }
    }
}