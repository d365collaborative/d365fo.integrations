
<#
    .SYNOPSIS
        Update a Data Entity in Dynamics 365 Finance & Operations
        
    .DESCRIPTION
        Updates a Data Entity, defined as a json payload, using the OData endpoint of the Dynamics 365 Finance & Operations platform
        
    .PARAMETER EntityName
        Name of the Data Entity you want to work against
        
        The parameter is Case Sensitive, because the OData endpoint in D365FO is Case Sensitive
        
        Remember that most Data Entities in a D365FO environment is named by its singular name, but most be retrieve using the plural name
        
        E.g. The version 3 of the customers Data Entity is named CustomerV3, but can only be retrieving using CustomersV3
        
        Look at the Get-D365ODataPublicEntity cmdlet to help you obtain the correct name
        
    .PARAMETER Key
        The key that will select the desired Data Entity uniquely across the OData endpoint
        
        The key would most likely be made up from multiple values, but can also be a single value
        
    .PARAMETER Payload
        The entire string contain the json object that you want to import into the D365FO environment
        
        Remember that json is text based and can use either single quotes (') or double quotes (") as the text qualifier, so you might need to escape the different quotes in your payload before passing it in
        
    .PARAMETER PayloadCharset
        The charset / encoding that you want the cmdlet to use while updating the odata entity
        
        The default value is: "UTF8"
        
        The charset has to be a valid http charset like: ASCII, ANSI, ISO-8859-1, UTF-8
        
    .PARAMETER CrossCompany
        Instruct the cmdlet / function to ensure the request against the OData endpoint will search across all companies
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access through OData
        
        If you are working against a D365FO instance, it will be the URL / URI for the instance itself
        
        If you are working against a D365 Talent / HR instance, this will have to be "http://hr.talent.dynamics.com"
        
    .PARAMETER SystemUrl
        URL / URI for the D365FO instance where the OData endpoint is available
        
        If you are working against a D365FO instance, it will be the URL / URI for the instance itself, which is the same as the Url parameter value
        
        If you are working against a D365 Talent / HR instance, this will to be full instance URL / URI like "https://aos-rts-sf-b1b468164ee-prod-northeurope.hr.talent.dynamics.com/namespaces/0ab49d18-6325-4597-97b3-c7f2321aa80c"
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER Token
        Pass a bearer token string that you want to use for while working against the endpoint
        
        This can improve performance if you are iterating over a large collection/array
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Update-D365ODataEntity -EntityName "CustomersV3" -Key "dataAreaId='DAT',CustomerAccount='123456789'" -Payload '{"NameAlias": "CustomerA"}' -CrossCompany
        
        This will update a Data Entity in Dynamics 365 Finance & Operations using the OData endpoint.
        The EntityName used for the update is "CustomersV3".
        It will use the "dataAreaId='DAT',CustomerAccount='123456789'" as key to identify the unique Customer record.
        The Payload is a valid json string, containing the needed properties that we want to update.
        It will make sure to search across all legal entities / companies inside the D365FO environment.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> $Payload = '{"NameAlias": "CustomerA"}'
        PS C:\> Update-D365ODataEntity -EntityName "accounts" -Key "dataAreaId='DAT',CustomerAccount='123456789'" -Payload $Payload
        
        This will update a Data Entity in Dynamics 365 Finance & Operations using the OData endpoint.
        First the desired json data is put into the $Payload variable.
        The EntityName used for the update is "CustomersV3".
        It will use the "dataAreaId='DAT',CustomerAccount='123456789'" as key to identify the unique Customer record.
        The $Payload variable is passed to the cmdlet.
        It will NOT look across companies.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataToken
        PS C:\> Update-D365ODataEntity -EntityName "CustomersV3" -Key "dataAreaId='DAT',CustomerAccount='123456789'" -Payload '{"NameAlias": "CustomerA"}' -CrossCompany -Token $token
        
        This will update a Data Entity in Dynamics 365 Finance & Operations using the OData endpoint.
        It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
        The EntityName used for the update is "CustomersV3".
        It will use the "dataAreaId='DAT',CustomerAccount='123456789'" as key to identify the unique Customer record.
        The Payload is a valid json string, containing the needed properties that we want to update.
        It will make sure to search across all legal entities / companies inside the D365FO environment.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .NOTES
        Tags: OData, Data, Entity, Update, Upload
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Add-D365ODataConfig
        
    .LINK
        Get-D365ActiveODataConfig
        
    .LINK
        Set-D365ActiveODataConfig
#>

function Update-D365ODataEntity {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $EntityName,

        [Parameter(Mandatory = $true)]
        [string] $Key,

        [Parameter(Mandatory = $true)]
        [Alias('Json')]
        [string] $Payload,

        [string] $PayloadCharset = "UTF-8",

        [switch] $CrossCompany,

        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,

        [string] $SystemUrl = $Script:ODataSystemUrl,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [string] $Token,

        [switch] $EnableException

    )

    begin {
        if ([System.String]::IsNullOrEmpty($SystemUrl)) {
            Write-PSFMessage -Level Verbose -Message "The SystemUrl parameter was empty, using the Url parameter as the OData endpoint base address." -Target $SystemUrl
            $SystemUrl = $Url
        }
        
        if ([System.String]::IsNullOrEmpty($Url) -or [System.String]::IsNullOrEmpty($SystemUrl)) {
            $messageString = "It seems that you didn't supply a valid value for the Url parameter. You need specify the Url parameter or add a configuration with the <c='em'>Add-D365ODataConfig</c> cmdlet."
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $entityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }
        
        if ($Url.Substring($Url.Length - 1) -eq "/") {
            Write-PSFMessage -Level Verbose -Message "The Url parameter had a tailing slash, which shouldn't be there. Removing the tailling slash." -Target $Url
            $Url = $Url.Substring(0, $Url.Length - 1)
        }
    
        if ($SystemUrl.Substring($SystemUrl.Length - 1) -eq "/") {
            Write-PSFMessage -Level Verbose -Message "The SystemUrl parameter had a tailing slash, which shouldn't be there. Removing the tailling slash." -Target $Url
            $SystemUrl = $SystemUrl.Substring(0, $SystemUrl.Length - 1)
        }

        if (-not $Token) {
            $bearerParms = @{
                Url          = $Url
                ClientId     = $ClientId
                ClientSecret = $ClientSecret
                Tenant       = $Tenant
            }

            $bearer = New-BearerToken @bearerParms
        }
        else {
            $bearer = $Token
        }

        $headerParms = @{
            URL         = $Url
            BearerToken = $bearer
        }

        $headers = New-AuthorizationHeaderBearerToken @headerParms

        $PayloadCharset = $PayloadCharset.ToLower()
        if ($PayloadCharset -like "utf*" -and $PayloadCharset -notlike "utf-*") {
            $PayloadCharset = $PayloadCharset -replace "utf", "utf-"
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        Invoke-TimeSignal -Start

        Write-PSFMessage -Level Verbose -Message "Building request for the OData endpoint for entity named: $EntityName." -Target $EntityName

        [System.UriBuilder] $odataEndpoint = $SystemUrl
        
        if ($odataEndpoint.Path -eq "/") {
            $odataEndpoint.Path = "data/$EntityName($Key)"
        }
        else {
            $odataEndpoint.Path += "/data/$EntityName($Key)"
        }

        if ($CrossCompany) {
            $odataEndpoint.Query = "cross-company=true"
        }

        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
            Invoke-RestMethod -Method Patch -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType "application/json;charset=$PayloadCharset" -Body $Payload
        }
        catch [System.Net.WebException] {
            $webException = $_.Exception
            
            if (($webException.Status -eq [System.Net.WebExceptionStatus]::ProtocolError) -and (-not($null -eq $webException.Response))) {
                $resp = [System.Net.HttpWebResponse]$webException.Response

                if ($resp.StatusCode -eq [System.Net.HttpStatusCode]::NotFound) {
                    $messageString = "It seems that the OData endpoint was unable to locate the desired entity: $EntityName, based on the key: <c='em'>$key</c>. Please make sure that the key is <c='em'>valid</c> or try using the <c='em'>-CrossCompany</c> parameter."
                    Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
                    Stop-PSFFunction -Message "Stopping because of HTTP error 404." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
                    return
                }
                else {
                    $messageString = "Something went wrong while updating the data entity through the OData endpoint for the entity: $EntityName"
                    Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
                    Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
                    return
                }
            }
        }
        catch {
            $messageString = "Something went wrong while updating the data entity through the OData endpoint for the entity: $EntityName"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        Invoke-TimeSignal -End
    }
}