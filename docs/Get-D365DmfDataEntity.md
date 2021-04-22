---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365DmfDataEntity

## SYNOPSIS
Get public DMF Data Entity and their metadata

## SYNTAX

### Default (Default)
```
Get-D365DmfDataEntity [-EntityName <String>] [-ODataQuery <String>] [-Tenant <String>] [-Url <String>]
 [-SystemUrl <String>] [-ClientId <String>] [-ClientSecret <String>] [-Token <String>] [-EnableException]
 [-RawOutput] [-OutNamesOnly] [-OutputAsJson] [<CommonParameters>]
```

### NameContains
```
Get-D365DmfDataEntity -EntityNameContains <String> [-ODataQuery <String>] [-Tenant <String>] [-Url <String>]
 [-SystemUrl <String>] [-ClientId <String>] [-ClientSecret <String>] [-Token <String>] [-EnableException]
 [-RawOutput] [-OutNamesOnly] [-OutputAsJson] [<CommonParameters>]
```

### Query
```
Get-D365DmfDataEntity -ODataQuery <String> [-Tenant <String>] [-Url <String>] [-SystemUrl <String>]
 [-ClientId <String>] [-ClientSecret <String>] [-Token <String>] [-EnableException] [-RawOutput]
 [-OutNamesOnly] [-OutputAsJson] [<CommonParameters>]
```

## DESCRIPTION
Get a list with all the public available DMF Data Entities,and their metadata, that are exposed through the DMF endpoint of the Dynamics 365 Finance & Operations environment

The cmdlet will search across the singular names for the Data Entities and across the collection names (plural)

## EXAMPLES

### EXAMPLE 1
```
Get-D365DmfDataEntity -EntityName customersv3
```

This will get Data Entities from the DMF endpoint.
This will search for the Data Entities that are named "customersv3".

### EXAMPLE 2
```
(Get-D365DmfDataEntity -EntityName customersv3).Value
```

This will get Data Entities from the DMF endpoint.
This will search for the Data Entities that are named "customersv3".
This will output the content of the "Value" property directly and list all found Data Entities and their metadata.

### EXAMPLE 3
```
Get-D365DmfDataEntity -EntityNameContains customers
```

This will get Data Entities from the DMF endpoint.
It will use the search string "customers" to search for any entity in their singular & plural name contains that search term.

### EXAMPLE 4
```
Get-D365DmfDataEntity -EntityNameContains customer -ODataQuery ' and IsReadOnly eq true'
```

This will get Data Entities from the DMF endpoint.
It will use the search string "customer" to search for any entity in their singular & plural name contains that search term.
It will utilize the OData Query capabilities to filter for Data Entities that are "IsReadOnly = $true".

### EXAMPLE 5
```
$token = Get-D365ODataToken
```

PS C:\\\> Get-D365ODataPublicEntity -EntityName customersv3 -Token $token

This will get Data Entities from the OData endpoint.
It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
This will search for the Data Entities that are named "customersv3".

## PARAMETERS

### -EntityName
Name of the Data Entity you are searching for

The parameter is Case Insensitive, to make it easier for the user to locate the correct Data Entity

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntityNameContains
Name of the Data Entity you are searching for, but instructing the cmdlet to use search logic

Using this parameter enables you to supply only a portion of the name for the entity you are looking for, and still a valid result back

The parameter is Case Insensitive, to make it easier for the user to locate the correct Data Entity

```yaml
Type: String
Parameter Sets: NameContains
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ODataQuery
Valid OData query string that you want to pass onto the D365 OData endpoint while retrieving data

Important note:
If you are using -EntityName or -EntityNameContains along with the -ODataQuery, you need to understand that the "$filter" query is already started.
Then you need to start with -ODataQuery ' and XYZ eq XYZ', e.g.
-ODataQuery ' and IsReadOnly eq false'
If you are using the -ODataQuery alone, you need to start the OData Query string correctly.
-ODataQuery '$filter=IsReadOnly eq false'

OData specific query options are:
$filter
$expand
$select
$orderby
$top
$skip

Each option has different characteristics, which is well documented at: http://docs.oasis-open.org/odata/odata/v4.0/odata-v4.0-part2-url-conventions.html

```yaml
Type: String
Parameter Sets: Default, NameContains
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Query
Aliases:

Required: True
Position: Named
Default value: None
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
Position: Named
Default value: $Script:ODataTenant
Accept pipeline input: False
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

### -ClientId
The ClientId obtained from the Azure Portal when you created a Registered Application

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: Named
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
Position: Named
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
Instructs the cmdlet to include the outer structure of the response received from DMF endpoint

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

### -OutNamesOnly
Instructs the cmdlet to only display the DataEntityName and the EntityName from the response received from DMF endpoint

DataEntityName is the (logical) name of the entity from a code perspective.
EntityName is the public DMF endpoint name of the entity.

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
The OData standard is using the $ (dollar sign) for many functions and features, which in PowerShell is normally used for variables.

Whenever you want to use the different query options, you need to take the $ sign and single quotes into consideration.

Example of an execution where I want the top 1 result only, from a specific legal entity / company.
This example is using single quotes, to help PowerShell not trying to convert the $ into a variable.
Because the OData standard is using single quotes as text qualifiers, we need to escape them with multiple single quotes.

-ODataQuery '$top=1&$filter=EntityCategory eq ''Master'''

Tags: DMF, Data, Entity, Query

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
