---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365RestServiceOperationDetails

## SYNOPSIS
Get Service Group from the Json Service endpoint

## SYNTAX

```
Get-D365RestServiceOperationDetails [-ServiceGroupName] <String> [-ServiceName] <String>
 [-OperationName] <String> [[-Tenant] <String>] [[-Url] <String>] [[-SystemUrl] <String>]
 [[-ClientId] <String>] [[-ClientSecret] <String>] [[-Token] <String>] [-EnableException] [-OutputAsJson]
 [<CommonParameters>]
```

## DESCRIPTION
Get available Service Group from the Json Service endpoint of the Dynamics 365 Finance & Operations instance

## EXAMPLES

### EXAMPLE 1
```
Get-D365RestServiceOperationDetails -ServiceGroupName "ERWebServices" -ServiceName "ERPullSolutionFromRepositoryService" -OperationName "Execute"
```

This will list all available Operation details from the Service Group "ERWebServices", ServiceName "ERPullSolutionFromRepositoryService" and OperationName "Execute" combinantion, from the Dynamics 365 Finance & Operations instance.

It will use the default configuration details that are stored in the configuration store.

Sample output:

ServiceGroupName : ERWebServices
ServiceName      : ERPullSolutionFromRepositoryService
OperationName    : Execute
Parameters       : {@{Name=_request; Type=PullSolutionFromRepositoryRequest}}
Return           : @{Name=return; Type=PullSolutionFromRepositoryResponse}

### EXAMPLE 2
```
Get-D365RestServiceGroup -Name "ERWebServices" | Get-D365RestService | Get-D365RestServiceOperation | Get-D365RestServiceOperationDetails
```

This will list all available Operation details from the Service Group "ERWebServices", all available services, and all available operations for each service, from the Dynamics 365 Finance & Operations instance.

It will use the default configuration details that are stored in the configuration store.

Sample output:

ServiceGroupName : ERWebServices
ServiceName      : ERPullSolutionFromRepositoryService
OperationName    : Execute
Parameters       : {@{Name=_request; Type=PullSolutionFromRepositoryRequest}}
Return           : @{Name=return; Type=PullSolutionFromRepositoryResponse}

### EXAMPLE 3
```
$token = Get-D365ODataToken
```

PS C:\\\> Get-D365RestServiceOperationDetails -ServiceGroupName "ERWebServices" -ServiceName "ERPullSolutionFromRepositoryService" -OperationName "Execute" -Token $token

This will list all available Operation details from the Service Group "ERWebServices", ServiceName "ERPullSolutionFromRepositoryService" and OperationName "Execute" combinantion, from the Dynamics 365 Finance & Operations instance.
It will get a fresh token, saved it into the token variable and pass it to the cmdlet.

It will use the default configuration details that are stored in the configuration store.

Sample output:

ServiceGroupName : ERWebServices
ServiceName      : ERPullSolutionFromRepositoryService
OperationName    : Execute
Parameters       : {@{Name=_request; Type=PullSolutionFromRepositoryRequest}}
Return           : @{Name=return; Type=PullSolutionFromRepositoryResponse}

## PARAMETERS

### -ServiceGroupName
Name of the Service Group that you want to be working against

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ServiceName
Name of the Service that you want to be working against

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -OperationName
Name of the Operation that you want to be working against

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AadGuid

Required: False
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
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

