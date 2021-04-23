---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365ODataToken

## SYNOPSIS
Get OAuth 2.0 token to be used against OData or Custom Service

## SYNTAX

```
Get-D365ODataToken [[-Tenant] <String>] [[-Url] <String>] [[-SystemUrl] <String>] [[-ClientId] <String>]
 [[-ClientSecret] <String>] [-EnableException] [-RawOutput] [<CommonParameters>]
```

## DESCRIPTION
Get an OAuth 2.0 bearer token to be used against the OData or Custom Service endpoints of the Dynamics 365 Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Get-D365ODataToken
```

This will get a bearetrtoken string.
The output will be a formal formatted bearer token, ready to be used right away.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 2
```
Get-D365ODataToken -RawOutput
```

This will get an OAuth 2.0 token.
It will output all properties of the token.

It will use the default OData configuration details that are stored in the configuration store.

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
Aliases: Uri

Required: False
Position: 2
Default value: $Script:ODataUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### -SystemUrl
URL / URI for the D365FO instance you want to be working against

If you are working against a D365FO instance, it will be the URL / URI for the instance itself, which is the same as the Url parameter value

If you are working against a D365 Talent / HR instance, this will to be full instance URL / URI like "https://aos-rts-sf-b1b468164ee-prod-northeurope.hr.talent.dynamics.com/namespaces/0ab49d18-6325-4597-97b3-c7f2321aa80c"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Script:ODataSystemUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
The ClientId obtained from the Azure Portal when you created a Registered Application

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:ODataClientId
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
The ClientSecret obtained from the Azure Portal when you created a Registered Application

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Script:ODataClientSecret
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
Tags: OData, OAuth, Token, JWT

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365ODataConfig]()

[Get-D365ActiveODataConfig]()

[Set-D365ActiveODataConfig]()

