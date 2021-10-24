
<#
    .SYNOPSIS
        Get OAuth 2.0 token to be used against OData or Custom Service, via an interactive sign-in flow
        
    .DESCRIPTION
        Get an OAuth 2.0 bearer token to be used against the OData or Custom Service endpoints of the Dynamics 365 Finance & Operations

        It will be running as an interactive sign-in flow, based on what is know as the device authentication flow

        Your clipboard will be set with a device code, and your default browser will navigate to "https://microsoft.com/devicelogin"
        You will have to paste in the device code, and complete an ordinary sign-in with your credentials
        When your sign-in is complete, it will pick up the OAuth 2.0 bearer token from the Azure AD
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to be working against
        
        If you are working against a D365FO instance, it will be the URL / URI for the instance itself
        
        If you are working against a D365 Talent / HR instance, this will have to be "http://hr.talent.dynamics.com"
        
    .PARAMETER Timeout
        Instruct the cmdlet how long time you need to be able to complete the interactive logon

        The default value is: 300 seconds

        Note: The parameter doesn't show up in the intellisense when tabbing through all available parameters, as it shouldn't be necessary to change the value

    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .PARAMETER RawOutput
        Instructs the cmdlet to output the raw token object and all its properties
        
    .EXAMPLE
        PS C:\> Get-D365ODataTokenInteractive
        
        This will start an interactive sign-in process to the Azure AD.
        It will utilize the active OData configuration for the Tenant(Id) and the Url (Resource).
        It will copy the device code into your clipboard.
        It will start the default browser and nagivate to "https://microsoft.com/devicelogin".
        It will wait the default amount of seconds for you to complete the interactive sign-in.

        The output will be a formal formatted bearer token, ready to be used right away.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365ODataTokenInteractive -RawOutput
        
        This will start an interactive sign-in process to the Azure AD.
        It will utilize the active OData configuration for the Tenant(Id) and the Url (Resource).
        It will copy the device code into your clipboard.
        It will start the default browser and nagivate to "https://microsoft.com/devicelogin".
        It will wait the default amount of seconds for you to complete the interactive sign-in.

        It will output all properties of the token.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365ODataTokenInteractive -Timeout 100
        
        This will start an interactive sign-in process to the Azure AD.
        It will utilize the active OData configuration for the Tenant(Id) and the Url (Resource).
        It will copy the device code into your clipboard.
        It will start the default browser and nagivate to "https://microsoft.com/devicelogin".
        It will wait 100 seconds for you to complete the interactive sign-in.

        The output will be a formal formatted bearer token, ready to be used right away.
        
        It will use the default OData configuration details that are stored in the configuration store.

    .EXAMPLE
        PS C:\> Get-D365ODataTokenInteractive | Set-D365ODataTokenInSession
        
        This sets the Token parameter value for all cmdlets, for the remaining of the session.
        It gets a token from the Get-D365ODataTokenInteractive cmdlet and pipes it into Set-D365ODataTokenInSession.

    .LINK
        Add-D365ODataConfig
        
    .LINK
        Get-D365ActiveODataConfig
        
    .LINK
        Set-D365ActiveODataConfig
        
    .NOTES
        Tags: OData, OAuth, Token, JWT, DeviceAuth, Device, DeviceCode
        
        Inspiration: https://blog.simonw.se/getting-an-access-token-for-azuread-using-powershell-and-device-login-flow/

        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365ODataTokenInteractive {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType()]
    param (
        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [Alias('Resource')]
        [string] $Url = $Script:ODataUrl,

        [Parameter(DontShow = $true)]
        [int] $Timeout = 300,
        
        [switch] $EnableException,

        [switch] $RawOutput
    )

    begin {
        if ([System.String]::IsNullOrEmpty($Url)) {
            $messageString = "It seems that you didn't supply a valid value for the Url parameter. You need specify the Url parameter or add a configuration with the <c='em'>Add-D365ODataConfig</c> cmdlet."
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $entityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }
        
        if ($Url.Substring($Url.Length - 1) -eq "/") {
            Write-PSFMessage -Level Verbose -Message "The Url parameter had a tailing slash, which shouldn't be there. Removing the tailling slash." -Target $Url
            $Url = $Url.Substring(0, $Url.Length - 1)
        }

        # Known ClientId for PowerShell in Azure AD
        $clientID = '1950a258-227b-4e31-a9cf-717495945fc2'

    }

    process {
        $azureUriDeviceCode = $Script:AzureTenantOauthDevicecode
        $azureUriToken = $Script:AzureTenantOauthToken
        
        $DeviceCodeRequestParams = @{
            Method = 'POST'
            Body   = @{
                resource  = $Url
                client_id = $ClientId
            }
        }
        $DeviceCodeRequestParams.Uri = $azureUriDeviceCode -f $Tenant

        $DeviceCodeRequest = Invoke-RestMethod @DeviceCodeRequestParams

        $DeviceCodeRequest.user_code | Set-Clipboard
        Write-PSFMessage -Level Host -Message "The device code <c='em'>$($DeviceCodeRequest.user_code)</c> has been copied into your clipboard."
        Start-Sleep -Seconds 2
        Write-PSFMessage -Level Host -Message "Will start the default browser and have it open the <c='em'>$($DeviceCodeRequest.verification_url)</c> page, where you need to <c='em'>paste</c> the code in and complete sign-in with your credentials."
        Start-Sleep -Seconds 2
        Start-Process $DeviceCodeRequest.verification_url
            
        $TokenRequestParams = @{
            Method = 'POST'
            Body   = @{
                grant_type = "urn:ietf:params:oauth:grant-type:device_code"
                code       = $DeviceCodeRequest.device_code
                client_id  = $ClientId
            }
        }
        $TokenRequestParams.Uri = $azureUriToken -f $Tenant

        $TimeoutTimer = [System.Diagnostics.Stopwatch]::StartNew()
        while ([string]::IsNullOrEmpty($tokenObj.access_token)) {
            if (Test-PSFFunctionInterrupt) { return }

            if ($TimeoutTimer.Elapsed.TotalSeconds -gt $Timeout) {
                $messageString = "The login session <c='em'>timed out</c>. You have <c='em'>$Timeout seconds</c> to complete the sign-in operation."
                Write-PSFMessage -Level Host -Message $messageString
                Stop-PSFFunction -Message "Stopping because login took to long." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
                return
            }
            $tokenObj = try {
                Invoke-RestMethod @TokenRequestParams -ErrorAction Stop
            }
            catch {
                $Message = $_.ErrorDetails.Message | ConvertFrom-Json
                if ($Message.error -ne "authorization_pending") {
                    throw
                }
            }
            Start-Sleep -Seconds 1
        }

        if ($RawOutput) {
            $tokenObj
        }
        else {
            $tokenObj | Get-BearerToken
        }
    }
}