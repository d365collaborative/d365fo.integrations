function Export-D365DmfPackage {
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [String] $JobId,

        [Parameter(Mandatory = $false)]
        [Alias('$AADGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Parameter(Mandatory = $false)]
        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,

        [Parameter(Mandatory = $false)]
        [string] $ClientId = $Script:ODataClientId,

        [Parameter(Mandatory = $false)]
        [string] $ClientSecret = $Script:ODataClientSecret,

        [switch] $EnableException

    )

    begin {
        $bearerParms = @{
            Resource     = $Url
            ClientId     = $ClientId
            ClientSecret = $ClientSecret
        }

        $bearerParms.AuthProviderUri = "https://login.microsoftonline.com/$Tenant/oauth2/token"

        $bearer = Invoke-ClientCredentialsGrant @bearerParms | Get-BearerToken

        $requestUrl = "$Url/api/connector/dequeue/$JobId"
    }

    process {
        $request = New-WebRequest -Url $requestUrl -Action "GET" -AuthenticationToken $bearer

        try {
            $response = $request.GetResponse()
            
            $stream = $response.GetResponseStream()
    
            $streamReader = New-Object System.IO.StreamReader($stream);
        
            $integrationResponse = $streamReader.ReadToEnd()
            #$streamReader.Flush();
            $streamReader.Close();

            $integrationResponse
        }
        catch {
            $messageString = "Something went wrong while importing data through the OData endpoint for the entity: $EntityName"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }
    }
}