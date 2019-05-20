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

        $data = "--$batchPayLoad {0}" -f [System.Environment]::NewLine
        $data += "Content-Type: multipart/mixed; boundary=changeset_$idchangeset {0}{0}" -f [System.Environment]::NewLine
        $data += "$changeSetPayLoad {0}" -f [System.Environment]::NewLine

        $localEntity = $EntityName
        $payLoadEnumerator = $PayLoad.GetEnumerator()
        $counter = 0
        while ($payLoadEnumerator.MoveNext()) {

            Write-PSFMessage -Level Verbose -Message "Inside the payload loop"

            $counter ++
            $localPayload = $payLoadEnumerator.Current.Trim()

            $data += New-BatchContent  "$URL/data/$localEntity" $bearer $LocalPayload $counter

            if ($PayLoad.Count -eq $counter) {
                $data += "$changesetPayload--{0}" -f [System.Environment]::NewLine
            }
            else {
                $data += "$changesetPayload{0}" -f [System.Environment]::NewLine
            }
        }
    
    
        $data += "$batchPayload--"

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