<#
.SYNOPSIS
Import a set of Data Entities into Dynamics 365 Finance & Operations

.DESCRIPTION
Imports a set of Data Entities, defined as a json payloads, using the OData endpoint of the Dynamics 365 Finance & Operations

The entire payload will be batched into a single request against the OData endpoint

.PARAMETER EntityName
Name of the Data Entity you want to work against

The parameter is Case Sensitive, because the OData endpoint in D365FO is Case Sensitive

Remember that most Data Entities in a D365FO environment is named by its singular name, but most be retrieve using the plural name

E.g. The version 3 of the customers Data Entity is named CustomerV3, but can only be retrieving using CustomersV3

Look at the Get-D365ODataPublicEntity cmdlet to help you obtain the correct name

.PARAMETER Payload
The entire string contain the json objects that you want to import into the D365FO environment

Payload supports multiple json objects, that needs to be batched together

.PARAMETER CrossCompany
Instruct the cmdlet / function to ensure the request against the OData endpoint will work across all companies

    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData
        
    .PARAMETER URL
        URL / URI for the D365FO environment you want to access through OData
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application

    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts

.EXAMPLE
PS C:\> Import-D365ODataEntityBatchMode -EntityName "ExchangeRates" -Payload '{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}','{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-04T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'

This will import a set of Data Entities into Dynamics 365 Finance & Operations using the OData endpoint.
The EntityName used for the import is ExchangeRates.
The Payload is an array containing valid json strings, each containing all the needed properties.

.EXAMPLE
PS C:\> $Payload = '{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}','{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-04T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
PS C:\> Import-D365ODataEntityBatchMode -EntityName "ExchangeRates" -Payload $Payload

This will import a set of Data Entities into Dynamics 365 Finance & Operations using the OData endpoint.
First the desired json data is put into the $Payload variable.
The EntityName used for the import is ExchangeRates.
The $Payload variable is passed to the cmdlet.

.NOTES
Tags: OData, Data, Entity, Import, Upload

Author: Mötz Jensen (@Splaxi)
#>

function Import-D365ODataEntityBatchMode {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $EntityName,

        [Parameter(Mandatory = $true)]
        [Alias('Json')]
        [string[]] $Payload,

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
        [string] $ClientSecret = $Script:ODataClientSecret,

        [switch] $EnableException

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

        $dataBuilder = [System.Text.StringBuilder]::new()

    }

    process {
        $idbatch = $(New-Guid).ToString()
        $idchangeset = $(New-Guid).ToString()
    
        $batchPayload = "--batch_$idbatch"
        $changesetPayload = "--changeset_$idchangeset"
        
        $request = [System.Net.WebRequest]::Create("$URL/data/`$batch")
        $request.Headers["Authorization"] = $headers.Authorization
        $request.Method = "POST"
        $request.ContentType = "multipart/mixed; boundary=batch_$idBatch"

        $dataBuilder.Clear()

        $null = $dataBuilder.AppendLine("--$batchPayLoad ") #Space is important!
        $null = $dataBuilder.AppendLine("Content-Type: multipart/mixed; boundary=changeset_$idchangeset {0}" -f [System.Environment]::NewLine)
        $null = $dataBuilder.AppendLine("$changeSetPayLoad ") #Space is important!

        $localEntity = $EntityName
        $payLoadEnumerator = $PayLoad.GetEnumerator()
        $counter = 0
        while ($payLoadEnumerator.MoveNext()) {

            Write-PSFMessage -Level Verbose -Message "Inside the payload loop"

            $counter ++
            $localPayload = $payLoadEnumerator.Current.Trim()

            $null = $dataBuilder.Append((New-BatchContent -Url "$URL/data/$localEntity" -AuthToken $bearer -Payload $LocalPayload -Count $counter))

            if ($PayLoad.Count -eq $counter) {
                $null = $dataBuilder.AppendLine("$changesetPayload--")
            }
            else {
                $null = $dataBuilder.AppendLine("$changesetPayload")
            }
        }
    
        $null = $dataBuilder.Append("$batchPayload--")
        $data = $dataBuilder.ToString()

        Write-PSFMessage -Level VeryVerbose -Message $data -Tag "Webrequest.DATA"
        
        $request.ContentLength = $data.Length

        $stream = $request.GetRequestStream()
        $streamWriter = new-object System.IO.StreamWriter($stream)
        $streamWriter.Write([string]$data);
        $streamWriter.Flush();
    
        $response = $request.GetResponse()

        # $response

        $stream = $response.GetResponseStream()
    
        $streamReader = New-Object System.IO.StreamReader($stream);
        
        $integrationResponse = $streamReader.ReadToEnd()
        $streamReader.Close();

        $integrationResponse
    }
}
<#
    .SYNOPSIS
        Import a set of Data Entities into Dynamics 365 Finance & Operations
        
    .DESCRIPTION
        Imports a set of Data Entities, defined as a json payloads, using the OData endpoint of the Dynamics 365 Finance & Operations
        
        The entire payload will be batched into a single request against the OData endpoint
        
    .PARAMETER EntityName
        Name of the Data Entity you want to work against
        
        The parameter is Case Sensitive, because the OData endpoint in D365FO is Case Sensitive
        
        Remember that most Data Entities in a D365FO environment is named by its singular name, but most be retrieve using the plural name
        
        E.g. The version 3 of the customers Data Entity is named CustomerV3, but can only be retrieving using CustomersV3
        
        Look at the Get-D365ODataPublicEntity cmdlet to help you obtain the correct name
        
    .PARAMETER Payload
        The entire string contain the json objects that you want to import into the D365FO environment
        
        Payload supports multiple json objects, that needs to be batched together
        
    .PARAMETER CrossCompany
        Instruct the cmdlet / function to ensure the request against the OData endpoint will work across all companies
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData
        
    .PARAMETER URL
        URL / URI for the D365FO environment you want to access through OData
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Import-D365ODataEntityBatchMode -EntityName "ExchangeRates" -Payload '{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}','{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-04T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
        
        This will import a set of Data Entities into Dynamics 365 Finance & Operations using the OData endpoint.
        The EntityName used for the import is ExchangeRates.
        The Payload is an array containing valid json strings, each containing all the needed properties.
        
    .EXAMPLE
        PS C:\> $Payload = '{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}','{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-04T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
        PS C:\> Import-D365ODataEntityBatchMode -EntityName "ExchangeRates" -Payload $Payload
        
        This will import a set of Data Entities into Dynamics 365 Finance & Operations using the OData endpoint.
        First the desired json data is put into the $Payload variable.
        The EntityName used for the import is ExchangeRates.
        The $Payload variable is passed to the cmdlet.
        
    .NOTES
        Tags: OData, Data, Entity, Import, Upload
        
        Author: Mötz Jensen (@Splaxi)
#>

function Import-D365ODataEntityBatchMode {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $EntityName,

        [Parameter(Mandatory = $true)]
        [Alias('Json')]
        [string[]] $Payload,

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
        [string] $ClientSecret = $Script:ODataClientSecret,

        [switch] $EnableException

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

        $dataBuilder = [System.Text.StringBuilder]::new()

    }

    process {
        $idbatch = $(New-Guid).ToString()
        $idchangeset = $(New-Guid).ToString()
    
        $batchPayload = "--batch_$idbatch"
        $changesetPayload = "--changeset_$idchangeset"
        
        $request = [System.Net.WebRequest]::Create("$URL/data/`$batch")
        $request.Headers["Authorization"] = $headers.Authorization
        $request.Method = "POST"
        $request.ContentType = "multipart/mixed; boundary=batch_$idBatch"

        $dataBuilder.Clear()

        $null = $dataBuilder.AppendLine("--$batchPayLoad ") #Space is important!
        $null = $dataBuilder.AppendLine("Content-Type: multipart/mixed; boundary=changeset_$idchangeset {0}" -f [System.Environment]::NewLine)
        $null = $dataBuilder.AppendLine("$changeSetPayLoad ") #Space is important!

        $localEntity = $EntityName
        $payLoadEnumerator = $PayLoad.GetEnumerator()
        $counter = 0
        while ($payLoadEnumerator.MoveNext()) {

            Write-PSFMessage -Level Verbose -Message "Inside the payload loop"

            $counter ++
            $localPayload = $payLoadEnumerator.Current.Trim()

            $null = $dataBuilder.Append((New-BatchContent -Url "$URL/data/$localEntity" -AuthToken $bearer -Payload $LocalPayload -Count $counter))

            if ($PayLoad.Count -eq $counter) {
                $null = $dataBuilder.AppendLine("$changesetPayload--")
            }
            else {
                $null = $dataBuilder.AppendLine("$changesetPayload")
            }
        }
    
        $null = $dataBuilder.Append("$batchPayload--")
        $data = $dataBuilder.ToString()

        Write-PSFMessage -Level VeryVerbose -Message $data -Tag "Webrequest.DATA"
        
        $request.ContentLength = $data.Length

        $stream = $request.GetRequestStream()
        $streamWriter = new-object System.IO.StreamWriter($stream)
        $streamWriter.Write([string]$data);
        $streamWriter.Flush();
    
        $response = $request.GetResponse()

        # $response

        $stream = $response.GetResponseStream()
    
        $streamReader = New-Object System.IO.StreamReader($stream);
        
        $integrationResponse = $streamReader.ReadToEnd()
        $streamReader.Close();

        $integrationResponse
    }
}