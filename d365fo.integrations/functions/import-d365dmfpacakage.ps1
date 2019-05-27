function Import-D365DmfPackage {
    [CmdletBinding()]
    [OutputType()]
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
        [Alias('URI')]
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

        $requestUrl = "$Url/api/connector/enqueue/$JobId"
    }

    process {

        $request = New-WebRequest -Url $requestUrl -Action "POST" -AuthenticationToken $bearer -ContentType "application/zip"

        Add-WebRequestContentFromFile -Request $request -Path $Path

        try {
            $response = $request.GetResponse()

            $response
        }
        catch {
            $messageString = "Something went wrong while importing data through the OData endpoint for the entity: $EntityName"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }
    }
}