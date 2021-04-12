---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365ODataPublicEnum

## SYNOPSIS
Get public enumerations (enums) and their metadata

## SYNTAX

### Default (Default)
```
Get-D365ODataPublicEnum [-EnumName <String>] [-ODataQuery <String>] [-Tenant <String>] [-Url <String>]
 [-SystemUrl <String>] [-ClientId <String>] [-ClientSecret <String>] [-Token <String>] [-EnableException]
 [-RawOutput] [-OutputAsJson] [<CommonParameters>]
```

### NameContains
```
Get-D365ODataPublicEnum -EnumNameContains <String> [-ODataQuery <String>] [-Tenant <String>] [-Url <String>]
 [-SystemUrl <String>] [-ClientId <String>] [-ClientSecret <String>] [-Token <String>] [-EnableException]
 [-RawOutput] [-OutputAsJson] [<CommonParameters>]
```

### Query
```
Get-D365ODataPublicEnum -ODataQuery <String> [-Tenant <String>] [-Url <String>] [-SystemUrl <String>]
 [-ClientId <String>] [-ClientSecret <String>] [-Token <String>] [-EnableException] [-RawOutput]
 [-OutputAsJson] [<CommonParameters>]
```

## DESCRIPTION
Get a list with all the public available enumerations (enums), and their metadata, that are exposed through the OData endpoint of the Dynamics 365 Finance & Operations environment

The cmdlet will search across the names for the enumerations (enums) and across the labelid

## EXAMPLES

### EXAMPLE 1
```
Get-D365ODataPublicEnum
```

This will list all available enumerations (enums).

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 2
```
Get-D365ODataPublicEnum -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
```

This will list all available enumerations (enums).

It will use "e674da86-7ee5-40a7-b777-1111111111111" as the Azure Active Directory guid.
It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the base D365FO environment url.
It will use "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
It will use "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.

### EXAMPLE 3
```
Get-D365ODataPublicEnum -EnumName VendRequestRoleType
```

This will list the VendRequestRoleType enumerations (enums).

It will use the default OData configuration details that are stored in the configuration store.

Sample output:

EnumName            EnumValueName EnumIntValue EnumValueLabelId
--------            ------------- ------------ ----------------
VendRequestRoleType None                     0 @SYS1369
VendRequestRoleType Admin                    1 @SYS20515
VendRequestRoleType Clerk                    2 @SYS130176

### EXAMPLE 4
```
Get-D365ODataPublicEnum -EnumNameContains VendRequestRole
```

This will search for all enumerations (enums) that matches the VendRequestRole search pattern.

It will use the default OData configuration details that are stored in the configuration store.

Sample output:

EnumName            EnumValueName EnumIntValue EnumValueLabelId
--------            ------------- ------------ ----------------
VendRequestRoleType None                     0 @SYS1369
VendRequestRoleType Admin                    1 @SYS20515
VendRequestRoleType Clerk                    2 @SYS130176

### EXAMPLE 5
```
$token = Get-D365ODataToken
```

PS C:\\\> Get-D365ODataPublicEnum -Token $token

This will list all available enumerations (enums).
It will get a fresh token, saved it into the token variable and pass it to the cmdlet.

It will use the default OData configuration details that are stored in the configuration store.

## PARAMETERS

### -EnumName
Name of the enumerations (enums) you are searching for

The parameter is Case Insensitive, to make it easier for the user to locate the correct enumerations (enums)

```yaml
Type: String
Parameter Sets: Default
Aliases: LabelId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnumNameContains
Name of the enumerations (enums) you are searching for, but instructing the cmdlet to use search logic

Using this parameter enables you to supply only a portion of the name for the enumerations (enums) you are looking for, and still get a valid result back

The parameter is Case Insensitive, to make it easier for the user to locate the correct enumerations (enums)

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
If you are using -EnumName or -EnumNameContains along with the -ODataQuery, you need to understand that the "$filter" query is already started.
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
Aliases: $AadGuid

Required: False
Position: Named
Default value: $Script:ODataTenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
URL / URI for the D365FO environment you want to access through MetaData

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
URL / URI for the D365FO instance where the MetaData endpoint is available

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
Instructs the cmdlet to include the outer structure of the response received from MetaData endpoint

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
The OData standard is using the $ (dollar sign) for many functions and features, which in PowerShell is normally used for variables.

Whenever you want to use the different query options, you need to take the $ sign and single quotes into consideration.

Example of an execution where I want the top 1 result only, from a specific legal entity / company.
This example is using single quotes, to help PowerShell not trying to convert the $ into a variable.
Because the OData standard is using single quotes as text qualifiers, we need to escape them with multiple single quotes.

-ODataQuery '$top=1&$filter=dataAreaId eq ''Comp1'''

Tags: OData, MetaData, Enum, Enumerations

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
