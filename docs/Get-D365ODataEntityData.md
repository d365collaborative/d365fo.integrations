---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365ODataEntityData

## SYNOPSIS
Get data from an Data Entity using OData

## SYNTAX

### Default (Default)
```
Get-D365ODataEntityData -EntitySetName <String> [-Top <Int32>] [-Filter <String[]>] [-Select <String[]>]
 [-Expand <String[]>] [-ODataQuery <String>] [-CrossCompany] [-RetryTimeout <TimeSpan>] [-Tenant <String>]
 [-Url <String>] [-SystemUrl <String>] [-ClientId <String>] [-ClientSecret <String>] [-Token <String>]
 [-EnableException] [-RawOutput] [-OutputAsJson] [<CommonParameters>]
```

### NextLink
```
Get-D365ODataEntityData [-EntityName <String>] [-EntitySetName <String>] [-Top <Int32>] [-Filter <String[]>]
 [-Select <String[]>] [-Expand <String[]>] [-ODataQuery <String>] [-CrossCompany] [-RetryTimeout <TimeSpan>]
 [-Tenant <String>] [-Url <String>] [-SystemUrl <String>] [-ClientId <String>] [-ClientSecret <String>]
 [-TraverseNextLink] [-ThrottleSeed <Int32>] [-Token <String>] [-EnableException] [-OutputAsJson]
 [<CommonParameters>]
```

### Specific
```
Get-D365ODataEntityData -EntityName <String> [-Top <Int32>] [-Filter <String[]>] [-Select <String[]>]
 [-Expand <String[]>] [-ODataQuery <String>] [-CrossCompany] [-RetryTimeout <TimeSpan>] [-Tenant <String>]
 [-Url <String>] [-SystemUrl <String>] [-ClientId <String>] [-ClientSecret <String>] [-Token <String>]
 [-EnableException] [-RawOutput] [-OutputAsJson] [<CommonParameters>]
```

## DESCRIPTION
Get data from an Data Entity using the OData endpoint of the Dynamics 365 Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=1'
```

This will get Customers from the OData endpoint.
It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
It will get the top 1 results from the list of customers.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 2
```
Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=10' -CrossCompany
```

This will get Customers from the OData endpoint.
It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
It will get the top 10 results from the list of customers.
It will make sure to search across all legal entities / companies inside the D365FO environment.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 3
```
Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=10&$filter=dataAreaId eq ''Comp1''' -CrossCompany
```

This will get Customers from the OData endpoint.
It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
It will get the top 10 results from the list of customers.
It will make sure to search across all legal entities / companies inside the D365FO environment.
It will search the customers inside the "Comp1" legal entity / company.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 4
```
Get-D365ODataEntityData -EntityName CustomersV3 -TraverseNextLink
```

This will get Customers from the OData endpoint.
It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
It will traverse all NextLink that will occur while fetching data from the OData endpoint.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 5
```
Get-D365ODataEntityData -EntityName CustomersV3 -TraverseNextLink -ThrottleSeed 2
```

This will get Customers from the OData endpoint, and sleep/pause between 1 and 2 seconds.
It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
It will traverse all NextLink that will occur while fetching data from the OData endpoint.
It will use the ThrottleSeed 2 to sleep/pause the execution, to mitigate the 429 pushback from the endpoint.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 6
```
$token = Get-D365ODataToken
```

PS C:\\\> Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=1' -Token $token

This will get Customers from the OData endpoint.
It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
It will get the top 1 results from the list of customers.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 7
```
Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=1' -RetryTimeout "00:01:00"
```

This will get Customers from the OData endpoint, and try for 1 minute to handle 429.
It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
It will get the top 1 results from the list of customers.
It will only try to handle 429 retries for 1 minute, before failing.

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
Parameter Sets: NextLink
Aliases: Name

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

```yaml
Type: String
Parameter Sets: NextLink
Aliases: CollectionName

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Top
Number of records that you want returned from the OData endpoint

Setting this will override anything in the OData parameter

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Filter statements to limit the records outputted from the OData endpoint

Supports an array of filter statements, so you don't need to know the syntax of combining filter statements

Setting this will override anything in the OData parameter

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Select
List of properties/columns that you want to return for the records outputted from the OData endpoint

Setting this will override anything in the OData parameter

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Expand
List of navigation properties/related properties that you want to include for the records outputted from the OData endpoint

Setting this will override anything in the OData parameter

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ODataQuery
Valid OData query string that you want to pass onto the D365 OData endpoint while retrieving data

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
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CrossCompany
Instruct the cmdlet / function to ensure the request against the OData endpoint will search across all companies

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

### -RetryTimeout
The retry timeout, before the cmdlet should quit retrying based on the 429 status code

Needs to be provided in the timspan notation:
"hh:mm:ss"

hh is the number of hours, numerical notation only
mm is the number of minutes
ss is the numbers of seconds

Each section of the timeout has to valid, e.g.
hh can maximum be 23
mm can maximum be 59
ss can maximum be 59

Not setting this parameter will result in the cmdlet to try for ever to handle the 429 push back from the endpoint

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 00:00:00
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AadGuid

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
Aliases: Uri

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

### -TraverseNextLink
Instruct the cmdlet to keep traversing the NextLink if the result set from the OData endpoint is larger than what one round trip can handle

The system default is 10,000 (10 thousands) at the time of writing this feature in December 2020

```yaml
Type: SwitchParameter
Parameter Sets: NextLink
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThrottleSeed
Instruct the cmdlet to invoke a thread sleep between 1 and ThrottleSeed value

This is to help to mitigate the 429 retry throttling on the OData / Custom Service endpoints

It will only be available in combination with the TraverseNextLink parameter

```yaml
Type: Int32
Parameter Sets: NextLink
Aliases:

Required: False
Position: Named
Default value: 0
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
Instructs the cmdlet to include the outer structure of the response received from OData endpoint

The output will still be a PSCustomObject

```yaml
Type: SwitchParameter
Parameter Sets: Default, Specific
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

-ODataQuery '$top=1&$filter=dataAreaId eq ''Comp1'''

Tags: OData, Data, Entity, Query

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365ODataConfig]()

[Get-D365ActiveODataConfig]()

[Set-D365ActiveODataConfig]()

