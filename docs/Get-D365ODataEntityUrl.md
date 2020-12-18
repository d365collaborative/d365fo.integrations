---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365ODataEntityUrl

## SYNOPSIS
Get url for an Data Entity using OData

## SYNTAX

### Default (Default)
```
Get-D365ODataEntityUrl -EntitySetName <String> [-Url <String>] [-SystemUrl <String>] [<CommonParameters>]
```

### Specific
```
Get-D365ODataEntityUrl -EntityName <String> [-Url <String>] [-SystemUrl <String>] [<CommonParameters>]
```

## DESCRIPTION
Get url for an Data Entity to be used with the OData endpoint of the Dynamics 365 Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Get-D365ODataEntityUrl -EntityName CustomersV3
```

This will get the url for the CustomersV3 OData endpoint.
It will use the CustomersV3 entity as the name of the entity.
It will output a complete url for the CustomersV3 OData endpoint.

## PARAMETERS

### -EntityName
Name of the Data Entity you want to work against

The parameter is Case Sensitive, because the OData endpoint in D365FO is Case Sensitive

Remember that most Data Entities in a D365FO environment is named by its singular name, but most be retrieve using the plural name

E.g.
The version 3 of the customers Data Entity is named CustomerV3, but can only be retrieving using CustomersV3

Look at the Get-D365ODataPublicEntity cmdlet to help you obtain the correct name

```yaml
Type: String
Parameter Sets: Specific
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntitySetName
Name of the Data Entity you want to work against

The parameter is created specifically to be used when piping from Get-D365ODataPublicEntity

```yaml
Type: String
Parameter Sets: Default
Aliases: CollectionName

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Url
URL / URI for the D365FO environment you want to access through OData

If you are working against a D365FO instance, it will be the URL / URI for the instance itself

If you are working against a D365 Talent / HR instance, this will have to be "http://hr.talent.dynamics.com"

```yaml
Type: String
Parameter Sets: (All)
Aliases: AuthenticationUrl, Uri

Required: False
Position: Named
Default value: $Script:ODataUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### -SystemUrl
URL / URI for the D365FO instance where the OData endpoint is available

If you are working against a D365FO instance, it will be the URL / URI for the instance itself, which is the same as the Url parameter value

If you are working against a D365 Talent / HR instance, this will to be full instance URL / URI like "https://aos-rts-sf-b1b468164ee-prod-northeurope.hr.talent.dynamics.com/namespaces/0ab49d18-6325-4597-97b3-c7f2321aa80c"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:ODataSystemUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: OData, Data, Entity, Query, Url

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365ODataConfig]()

[Get-D365ActiveODataConfig]()

[Set-D365ActiveODataConfig]()

