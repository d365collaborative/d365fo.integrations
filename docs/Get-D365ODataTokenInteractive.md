---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365ODataTokenInteractive

## SYNOPSIS
Get OAuth 2.0 token to be used against OData or Custom Service, via an interactive sign-in flow

## SYNTAX

```
Get-D365ODataTokenInteractive [[-Tenant] <String>] [[-Url] <String>] [[-Timeout] <Int32>] [-EnableException]
 [-RawOutput] [<CommonParameters>]
```

## DESCRIPTION
Get an OAuth 2.0 bearer token to be used against the OData or Custom Service endpoints of the Dynamics 365 Finance & Operations

It will be running as an interactive sign-in flow, based on what is know as the device authentication flow

Your clipboard will be set with a device code, and your default browser will navigate to "https://microsoft.com/devicelogin"
You will have to paste in the device code, and complete an ordinary sign-in with your credentials
When your sign-in is complete, it will pick up the OAuth 2.0 bearer token from the Azure AD

## EXAMPLES

### EXAMPLE 1
```
Get-D365ODataTokenInteractive
```

This will start an interactive sign-in process to the Azure AD.
It will utilize the active OData configuration for the Tenant(Id) and the Url (Resource).
It will copy the device code into your clipboard.
It will start the default browser and nagivate to "https://microsoft.com/devicelogin".
It will wait the default amount of seconds for you to complete the interactive sign-in.

The output will be a formal formatted bearer token, ready to be used right away.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 2
```
Get-D365ODataTokenInteractive -RawOutput
```

This will start an interactive sign-in process to the Azure AD.
It will utilize the active OData configuration for the Tenant(Id) and the Url (Resource).
It will copy the device code into your clipboard.
It will start the default browser and nagivate to "https://microsoft.com/devicelogin".
It will wait the default amount of seconds for you to complete the interactive sign-in.

It will output all properties of the token.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 3
```
Get-D365ODataTokenInteractive -Timeout 100
```

This will start an interactive sign-in process to the Azure AD.
It will utilize the active OData configuration for the Tenant(Id) and the Url (Resource).
It will copy the device code into your clipboard.
It will start the default browser and nagivate to "https://microsoft.com/devicelogin".
It will wait 100 seconds for you to complete the interactive sign-in.

The output will be a formal formatted bearer token, ready to be used right away.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 4
```
Get-D365ODataTokenInteractive | Set-D365ODataTokenInSession
```

This sets the Token parameter value for all cmdlets, for the remaining of the session.
It gets a token from the Get-D365ODataTokenInteractive cmdlet and pipes it into Set-D365ODataTokenInSession.

## PARAMETERS

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AadGuid

Required: False
Position: 1
Default value: $Script:ODataTenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
URL / URI for the D365FO environment you want to be working against

If you are working against a D365FO instance, it will be the URL / URI for the instance itself

If you are working against a D365 Talent / HR instance, this will have to be "http://hr.talent.dynamics.com"

```yaml
Type: String
Parameter Sets: (All)
Aliases: Resource, Uri

Required: False
Position: 2
Default value: $Script:ODataUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Instruct the cmdlet how long time you need to be able to complete the interactive logon

The default value is: 300 seconds

Note: The parameter doesn't show up in the intellisense when tabbing through all available parameters, as it shouldn't be necessary to change the value

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableException
This parameters disables user-friendly warnings and enables the throwing of exceptions
This is less user friendly, but allows catching exceptions in calling scripts

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RawOutput
Instructs the cmdlet to output the raw token object and all its properties

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: OData, OAuth, Token, JWT, DeviceAuth, Device, DeviceCode

Inspiration: https://blog.simonw.se/getting-an-access-token-for-azuread-using-powershell-and-device-login-flow/

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365ODataConfig]()

[Get-D365ActiveODataConfig]()

[Set-D365ActiveODataConfig]()

