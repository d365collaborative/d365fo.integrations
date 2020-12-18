---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Remove-D365ODataEntity

## SYNOPSIS
Remove a Data Entity from Dynamics 365 Finance & Operations

## SYNTAX

```
Remove-D365ODataEntity [-EntityName] <String> [-Key] <String> [-CrossCompany] [[-Tenant] <String>]
 [[-URL] <String>] [[-SystemUrl] <String>] [[-ClientId] <String>] [[-ClientSecret] <String>]
 [[-Token] <String>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Removes a Data Entity, defined by the EntityKey, using the OData endpoint of the Dynamics 365 Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Remove-D365ODataEntity -EntityName ExchangeRates -Key "RateTypeName='TEST',FromCurrency='DKK',ToCurrency='EUR',StartDate=2019-01-13T12:00:00Z"
```

This will remove a Data Entity from the D365FO environment through OData.
It will use the ExchangeRate entity, and its EntitySetName / CollectionName "ExchangeRates".
It will use the "RateTypeName='TEST',FromCurrency='DKK',ToCurrency='EUR',StartDate=2019-01-13T12:00:00Z" as the unique key for the entity.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 2
```
$token = Get-D365ODataToken
```

PS C:\\\> Remove-D365ODataEntity -EntityName ExchangeRates -Key "RateTypeName='TEST',FromCurrency='DKK',ToCurrency='EUR',StartDate=2019-01-13T12:00:00Z" -Token $token

This will remove a Data Entity from the D365FO environment through OData.
It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
It will use the ExchangeRate entity, and its EntitySetName / CollectionName "ExchangeRates".
It will use the "RateTypeName='TEST',FromCurrency='DKK',ToCurrency='EUR',StartDate=2019-01-13T12:00:00Z" as the unique key for the entity.

It will use the default OData configuration details that are stored in the configuration store.

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
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Key
The key that will select the desired Data Entity uniquely across the OData endpoint

The key would most likely be made up from multiple values, but can also be a single value

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CrossCompany
Instruct the cmdlet / function to ensure the request against the OData endpoint will work across all companies

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

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AADGuid

Required: False
Position: 3
Default value: $Script:ODataTenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
URL / URI for the D365FO environment you want to access through OData

If you are working against a D365FO instance, it will be the URL / URI for the instance itself

If you are working against a D365 Talent / HR instance, this will have to be "http://hr.talent.dynamics.com"

```yaml
Type: String
Parameter Sets: (All)
Aliases: URI

Required: False
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
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
Position: 8
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: OData, Data, Entity, Import, Upload

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
