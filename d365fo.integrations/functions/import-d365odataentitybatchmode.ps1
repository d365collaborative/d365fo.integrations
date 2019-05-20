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