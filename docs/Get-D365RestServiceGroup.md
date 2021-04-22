---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365RestServiceGroup

## SYNOPSIS
Get Service Group from the Json Service endpoint

## SYNTAX

```
Get-D365RestServiceGroup [[-Name] <String>] [[-Tenant] <String>] [[-Url] <String>] [[-SystemUrl] <String>]
 [[-ClientId] <String>] [[-ClientSecret] <String>] [[-Token] <String>] [-EnableException] [-RawOutput]
 [-OutputAsJson] [<CommonParameters>]
```

## DESCRIPTION
Get available Service Group from the Json Service endpoint of the Dynamics 365 Finance & Operations instance

## EXAMPLES

### EXAMPLE 1
```
Get-D365RestServiceGroup
```

This will list all available Service Groups from the Dynamics 365 Finance & Operations instance.

It will use the default configuration details that are stored in the configuration store.

### EXAMPLE 2
```
Get-D365RestServiceGroup -Name "*service*"
```

This will list all available Service Groups, which matches the "*service*" pattern, from the Dynamics 365 Finance & Operations instance.

It will use the default configuration details that are stored in the configuration store.

### EXAMPLE 3
```
$token = Get-D365ODataToken
```

PS C:\\\> Get-D365RestServiceGroup -Token $token

This will list all available Service Groups from the Dynamics 365 Finance & Operations instance.
It will get a fresh token, saved it into the token variable and pass it to the cmdlet.

It will use the default configuration details that are stored in the configuration store.

## PARAMETERS

### -Name
Name of the Service Group that you are looking for

The parameter supports wildcards.
E.g.
-Name "*Timesheet*"

Default value is "*" to list all service groups

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AadGuid

Required: False
Position: 2
Default value: $Script:ODataTenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
URL / URI for the D365FO environment you want to access

If you are working against a D365FO instance, it will be the URL / URI for the instance itself

If you are working against a D365 Talent / HR instance, this will have to be "http://hr.talent.dynamics.com"

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uri

Required: False
Position: 3
Default value: $Script:ODataUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### -SystemUrl
URL / URI for the D365FO instance where the Json Service endpoint is available

If you are working against a D365FO instance, it will be the URL / URI for the instance itself, which is the same as the Url parameter value

If you are working against a D365 Talent / HR instance, this will to be full instance URL / URI like "https://aos-rts-sf-b1b468164ee-prod-northeurope.hr.talent.dynamics.com/namespaces/0ab49d18-6325-4597-97b3-c7f2321aa80c"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
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
Position: 6
Default value: $Script:ODataClientSecret
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
Pass a bearer token string that you want to use for while working against the endpoint

This can improve performance if you are iterating over a large collection/array

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
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
Instructs the cmdlet to include the outer structure of the response received from Json Service endpoint

The output will still be a PSCustomObject

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

### -OutputAsJson
Instructs the cmdlet to convert the output to a Json string

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
Tags: Json, Data, Service, Operations

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365ODataConfig]()

[Get-D365ActiveODataConfig]()

[Set-D365ActiveODataConfig]()

