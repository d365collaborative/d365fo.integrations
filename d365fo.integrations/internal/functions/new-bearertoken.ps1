function New-BearerToken {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('Uri')]
        [string] $Url,

        [Parameter(Mandatory = $true)]
        [string] $ClientId,

        [Parameter(Mandatory = $true)]
        [string] $ClientSecret,

        [Parameter(Mandatory = $true)]
        [string] $Tenant

    )

    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Building request for fetching the bearer token." -Target $Var
    $bearerParms = @{
        Resource     = $Url
        ClientId     = $ClientId
        ClientSecret = $ClientSecret
    }

    $azureUri = $Script:AzureTenantOauthToken
    
    $bearerParms.AuthProviderUri = $azureUri -f $Tenant

    Write-PSFMessage -Level Verbose -Message "Fetching the bearer token." -Target ($bearerParms -join ", ")

    Invoke-ClientCredentialsGrant @bearerParms | Get-BearerToken

    Invoke-TimeSignal -End
}