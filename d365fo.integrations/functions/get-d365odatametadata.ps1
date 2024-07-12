
<#
    .SYNOPSIS
        Downloads the OData metadata for a Dynamics 365 for Finance and Operations environment as an .edmx file.
        
    .DESCRIPTION
        The Get-D365ODataMetadata cmdlet downloads the OData metadata for a Dynamics 365 for Finance and Operations environment as an .edmx file.
        
    .PARAMETER Path
        The path to the .edmx file where the OData metadata will be saved.
        
        While the .edmx extension is recommended, the .xml extension can also be used.
        
    .PARAMETER Url
        The URL of the Dynamics 365 for Finance and Operations environment for which the OData metadata is to be downloaded.
        
        This parameter is optional if a configuration has been added with the Add-D365ODataConfig cmdlet.
        
    .PARAMETER Tenant
        The tenant id (guid) of the Dynamics 365 for Finance and Operations environment for which the OData metadata is to be downloaded.
        
        This parameter is used when authenticating the download request.
        This parameter is optional if a configuration has been added with the Add-D365ODataConfig cmdlet.
        
    .PARAMETER ClientId
        The client id (guid) of the Azure Active Directory application that is used to authenticate the download request.
        
        This parameter is used when authenticating the download request. See https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/services-home-page#authentication for more information on authenticating OData requests.
        This parameter is optional if a configuration has been added with the Add-D365ODataConfig cmdlet.
        
    .PARAMETER ClientSecret
        The client secret of the Azure Active Directory application that is used to authenticate the download request.
        
        This parameter is used when authenticating the download request.
        This parameter is optional if a configuration has been added with the Add-D365ODataConfig cmdlet.
        
    .PARAMETER Token
        The bearer token to use for the request. If this parameter is not supplied, the cmdlet will attempt to get a new token using the supplied parameters.
        
    .PARAMETER EnableException
        If this switch is enabled, the cmdlet will throw an exception if an error occurs. Otherwise, the cmdlet will write an error message to the host.
        
        This parameters disables user-friendly warnings, which is less user friendly, but allows catching exceptions in calling scripts.
        
    .EXAMPLE
        PS C:\> Get-D365ODataMetadata -Path "C:\Temp\d365fo.edmx"
        
        Downloads the OData metadata for the environment specified by the active configuration and saves it to the file "C:\Temp\d365fo.edmx".
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataToken
        PS C:\> Get-D365ODataPublicEntity -Path "C:\Temp\d365fo.edmx" -Token $token
        
        Downloads the OData metadata for the environment specified by the active configuration and saves it to the file "C:\Temp\d365fo.edmx".
        It will get a fresh token based on the active configuration, saved it into the token variable and pass it to the cmdlet.
        
    .EXAMPLE
        PS C:\> Get-D365ODataMetadata -Path "C:\Temp\d365fo.edmx" -Url "https://uat.sandbox.operations.dynamics.com" -Tenant "3718c2ef-850b-462a-93e9-58a26d54346e" -ClientId "60adecfa-99bc-47c7-b0cd-0ba61a91375f" -ClientSecret "du1234/mM4N7F1234Gf3TWp/1234jqn7RcbpG4C1234"
        
        Downloads the OData metadata for the environment specified by the parameters and saves it to the file "C:\Temp\d365fo.edmx".
        
    .NOTES
        Tags: OData, Data, Metadata
        
        Author: Florian Hopfner (@FH-Inway)
#>

function Get-D365ODataMetadata {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [string] $Path,

        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,

        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [string] $Token,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    if ([System.String]::IsNullOrEmpty($Url)) {
        $messageString = "It seems that you didn't supply a valid value for the Url parameter. You need specify the Url parameter or add a configuration with the <c='em'>Add-D365ODataConfig</c> cmdlet."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
        return
    }

    if ($Url.Substring($Url.Length - 1) -eq "/") {
        Write-PSFMessage -Level Verbose -Message "The Url parameter had a tailing slash, which should not be there. Removing the tailing slash." -Target $Url
        $Url = $Url.Substring(0, $Url.Length - 1)
    }

    $bearer = $Token
    if (-not $bearer) {
        $bearerParms = @{
            Url          = $Url
            ClientId     = $ClientId
            ClientSecret = $ClientSecret
            Tenant       = $Tenant
        }

        $bearer = New-BearerToken @bearerParms
    }
    $headerParms = @{
        URL         = $Url
        BearerToken = $bearer
    }
    $headers = New-AuthorizationHeaderBearerToken @headerParms

    [System.UriBuilder] $odataMetadataUrl = $Url
    $odataMetadataPath = 'data/$metadata'
    if ($odataMetadataUrl.Path -eq "/") {
        $odataMetadataUrl.Path = $odataMetadataPath
    }
    else {
        $odataMetadataUrl.Path += "/$odataMetadataPath"
    }
    
    try {
        Write-PSFMessage -Level Verbose -Message "Executing http request against the metadata OData endpoint '$($odataMetadataUrl.Uri.AbsoluteUri)'" -Target $($odataMetadataUrl.Uri.AbsoluteUri)
        Invoke-RestMethod -Method Get -Uri $odataMetadataUrl.Uri.AbsoluteUri -Headers $headers -OutFile $Path
        
        Write-PSFMessage -Level Host -Message "OData metadata from '$($odataMetadataUrl.Uri.AbsoluteUri)' was downloaded to '$Path'"
    }
    catch {
        $messageString = "An error occurred while trying to download the OData metadata from '$($odataMetadataUrl.Uri.AbsoluteUri)' to '$Path'."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
        return
    }

    Invoke-TimeSignal -End
}