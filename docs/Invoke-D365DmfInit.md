---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Invoke-D365DmfInit

## SYNOPSIS
Invoke DMF Initialize, which will refresh all Data Management Entities

## SYNTAX

```
Invoke-D365DmfInit [[-Tenant] <String>] [[-Url] <String>] [[-ClientId] <String>] [[-ClientSecret] <String>]
 [[-Token] <String>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Invokes the DMF initialization from the DMF Endpoint of the Dynamics 365 for Finance & Operations environment

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365DmfInit
```

This will invoke the DMF initialization through the DMF endpoint.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 2
```
Invoke-D365DmfInit -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
```

This will invoke the DMF initialization through the DMF endpoint.
It will use "e674da86-7ee5-40a7-b777-1111111111111" as the Azure Active Directory guid.
It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the base D365FO environment url.
It will use "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
It will use "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.

### EXAMPLE 3
```
$token = Get-D365ODataToken
```

PS C:\\\> Invoke-D365DmfInit -Token $token

This will invoke the DMF initialization through the DMF endpoint.
It will get a fresh token, saved it into the token variable and pass it to the cmdlet.

It will use the default OData configuration details that are stored in the configuration store.

## PARAMETERS

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through DMF

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AADGuid

Required: False
Position: 1
Default value: $Script:ODataTenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
URL / URI for the D365FO environment you want to access through DMF

```yaml
Type: String
Parameter Sets: (All)
Aliases: URI

Required: False
Position: 2
Default value: $Script:ODataUrl
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
Position: 3
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
Position: 4
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
Position: 5
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
Tags: DMF, Entities, Enitity, Init, Initialize, Refresh

Author: Mötz Jensen (@Splaxi), Gert Van Der Heyden (@gertvdheyden)

## RELATED LINKS

[Add-D365ODataConfig]()

[Get-D365ActiveODataConfig]()

[Set-D365ActiveODataConfig]()

