
<#
    .SYNOPSIS
        Update a set of Data Entities in Dynamics 365 Finance & Operations
        
    .DESCRIPTION
        Updates a set of Data Entities, defined as a json payloads, using the OData endpoint of the Dynamics 365 Finance & Operations
        
        The entire payload will be batched into a single request against the OData endpoint
        
    .PARAMETER EntityName
        Name of the Data Entity you want to work against
        
        The parameter is Case Sensitive, because the OData endpoint in D365FO is Case Sensitive
        
        Remember that most Data Entities in a D365FO environment is named by its singular name, but most be retrieve using the plural name
        
        E.g. The version 3 of the customers Data Entity is named CustomerV3, but can only be retrieving using CustomersV3
        
        Look at the Get-D365ODataPublicEntity cmdlet to help you obtain the correct name
        
    .PARAMETER Payload
        The array of PSCustomObjects that you want to update in the D365FO environment
        
        Each PSCustomObject needs to have a Key and a Payload property
        
        The Key must be a string
        The Payload must be a json string
        
    .PARAMETER PayloadCharset
        The charset / encoding that you want the cmdlet to use while updating the odata entity
        
        The default value is: "UTF8"
        
        The charset has to be a valid http charset like: ASCII, ANSI, ISO-8859-1, UTF-8
        
    .PARAMETER CrossCompany
        Instruct the cmdlet / function to ensure the request against the OData endpoint will work across all companies
        
    .PARAMETER ThrottleSeed
        Instruct the cmdlet to invoke a thread sleep between 1 and ThrottleSeed value
        
        This is to help to mitigate the 429 retry throttling on the OData / Custom Service endpoints
        
        It makes most sense if you are running things a outer loop, where you will hit the OData / Custom Service endpoints with a burst of calls in a short time
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access through OData
        
    .PARAMETER SystemUrl
        URL / URI for the D365FO instance where the OData endpoint is available
        
        If you are working against a D365FO instance, it will be the URL / URI for the instance itself, which is the same as the Url parameter value
        
        If you are working against a D365 Talent / HR instance, this will to be full instance URL / URI like "https://aos-rts-sf-b1b468164ee-prod-northeurope.hr.talent.dynamics.com/namespaces/0ab49d18-6325-4597-97b3-c7f2321aa80c"
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER RawOutput
        Instructs the cmdlet to output the raw json string directly
        
    .PARAMETER Token
        Pass a bearer token string that you want to use for while working against the endpoint
        
        This can improve performance if you are iterating over a large collection/array
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> $payload = '{"SalesTaxGroup":"DK"}'
        PS C:\> $updates = @([PSCustomObject]@{Key = "dataAreaId='USMF',CustomerAccount='Customer1'"; Payload = $payload})
        PS C:\> $updates += [PSCustomObject]@{Key = "dataAreaId='USMF',CustomerAccount='Customer2'"; Payload = $payload}
        PS C:\> Update-D365ODataEntityBatchMode -EntityName "CustomersV3" -Payload $($updates.ToArray())
        
        This will update a set of Data Entities in Dynamics 365 Finance & Operations using the OData endpoint.
        The payload that needs to be updated for all entities is saved in the $payload variable.
        The desired customers that needs to be updated are saved into the $updates, with their unique key and the payload.
        The $updates variable is passed to the cmdlet.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataToken
        PS C:\> $payload = '{"SalesTaxGroup":"DK"}'
        PS C:\> $updates = @([PSCustomObject]@{Key = "dataAreaId='USMF',CustomerAccount='Customer1'"; Payload = $payload})
        PS C:\> $updates += [PSCustomObject]@{Key = "dataAreaId='USMF',CustomerAccount='Customer2'"; Payload = $payload}
        PS C:\> Update-D365ODataEntityBatchMode -EntityName "CustomersV3" -Payload $($updates.ToArray()) -Token $token
        
        This will update a set of Data Entities in Dynamics 365 Finance & Operations using the OData endpoint.
        It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
        The payload that needs to be updated for all entities is saved in the $payload variable.
        The desired customers that needs to be updated are saved into the $updates, with their unique key and the payload.
        The $updates variable is passed to the cmdlet.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> $payload = '{"SalesTaxGroup":"DK"}'
        PS C:\> $updates = @([PSCustomObject]@{Key = "dataAreaId='USMF',CustomerAccount='Customer1'"; Payload = $payload})
        PS C:\> $updates += [PSCustomObject]@{Key = "dataAreaId='USMF',CustomerAccount='Customer2'"; Payload = $payload}
        PS C:\> Update-D365ODataEntityBatchMode -EntityName "CustomersV3" -Payload $($updates.ToArray()) -ThrottleSeed 2
        
        This will update a set of Data Entities in Dynamics 365 Finance & Operations using the OData endpoint, and sleep/pause between 1 and 2 seconds.
        The payload that needs to be updated for all entities is saved in the $payload variable.
        The desired customers that needs to be updated are saved into the $updates, with their unique key and the payload.
        The $updates variable is passed to the cmdlet.
        It will use the ThrottleSeed 2 to sleep/pause the execution, to mitigate the 429 pushback from the endpoint.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .NOTES
        Tags: OData, Data, Entity, Update, Upload, Batch
        
        Author: Mötz Jensen (@Splaxi)
#>

function Update-D365ODataEntityBatchMode {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory = $true)]
        [string] $EntityName,

        [Parameter(Mandatory = $true)]
        [PsCustomObject[]] $Payload,

        [string] $PayloadCharset = "UTF-8",

        [switch] $CrossCompany,

        [int] $ThrottleSeed,

        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,

        [string] $SystemUrl = $Script:ODataSystemUrl,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [switch] $RawOutput,
        
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

        $dataBuilder = [System.Text.StringBuilder]::new()

    }

    process {
        Invoke-TimeSignal -Start

        Write-PSFMessage -Level Verbose -Message "Building batch request for the OData endpoint for entity named: $EntityName." -Target $EntityName

        $idbatch = $(New-Guid).ToString()
        $idchangeset = $(New-Guid).ToString()
    
        $batchPayload = "batch_$idbatch"
        $changesetPayload = "changeset_$idchangeset"
        
        $request = [System.Net.WebRequest]::Create("$SystemUrl/data/`$batch")
        $request.Headers["Authorization"] = $headers.Authorization
        $request.Method = "POST"
        $request.ContentType = "multipart/mixed; boundary=batch_$idBatch"

        $dataBuilder.Clear() > $null

        $dataBuilder.AppendLine("--$batchPayLoad ") > $null #Space is important!
        $dataBuilder.AppendLine("Content-Type: multipart/mixed; boundary=changeset_$idchangeset {0}" -f [System.Environment]::NewLine) > $null
        $dataBuilder.AppendLine("--$changeSetPayLoad ") > $null #Space is important!

        $payLoadEnumerator = $PayLoad.GetEnumerator()
        $counter = 0
        while ($payLoadEnumerator.MoveNext()) {
            $key = $payLoadEnumerator.Current.Key

            $localEntity = "$EntityName($key)"

            Write-PSFMessage -Level Verbose -Message "Parsing the payload for the batch request."

            $counter ++
            $localPayload = $payLoadEnumerator.Current.Payload.Trim()

            $dataBuilder.Append((New-BatchContent -Url "$SystemUrl/data/$localEntity" -Payload $LocalPayload -Count $counter -Method "PATCH")) > $null

            if ($PayLoad.Count -eq $counter) {
                $dataBuilder.AppendLine("--$changesetPayload--") > $null
            }
            else {
                $dataBuilder.AppendLine("--$changesetPayload") > $null
            }
        }
    
        $dataBuilder.Append("--$batchPayload--") > $null
        $data = $dataBuilder.ToString()

        Write-PSFMessage -Level Debug -Message "Parsing data to debug log next."

        Write-PSFMessage -Level Debug -Message $data
        
        Add-WebRequestContent -WebRequest $request -Payload $data
    
        try {
            Write-PSFMessage -Level Verbose -Message "Executing batch http request against the OData endpoint."

            $response = $request.GetResponse()
        }
        catch {
            $messageString = "Something went wrong while importing batch data through the OData endpoint for the entity: $EntityName"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }
    
        #Might need to be something else than OK and Created
        if ($response.StatusCode -ne [System.Net.HttpStatusCode]::Ok -and $response.StatusCode -ne [System.Net.HttpStatusCode]::Created) {
            Write-PSFMessage -Level Verbose -Message "Status code not 'Ok' and not 'Created', Description $($response.StatusDescription)"
            Stop-PSFFunction -Message "Stopping" -Exception $([System.Exception]::new("Returned status code indicates that the request was unsuccessful."))
            return
        }

        $stream = $response.GetResponseStream()
    
        $streamReader = New-Object System.IO.StreamReader($stream)
        
        $res = $streamReader.ReadToEnd()
        $streamReader.Close();

        if ($RawOutput) {
            $res
        }
        else {
            $res | ConvertTo-Json
        }

        if ($ThrottleSeed) {
            Start-Sleep -Seconds $(Get-Random -Minimum 1 -Maximum $ThrottleSeed)
        }
        
        Invoke-TimeSignal -End
    }
}