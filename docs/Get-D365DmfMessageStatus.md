---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365DmfMessageStatus

## SYNOPSIS
Get Message Status from the DMF

## SYNTAX

```
Get-D365DmfMessageStatus [-MessageId] <String> [[-Tenant] <String>] [[-Url] <String>] [[-ClientId] <String>]
 [[-ClientSecret] <String>] [-WaitForCompletion] [[-Token] <String>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Get the Message Status based on the MessageId from the DMF Endpoint of the Dynamics 365 for Finance & Operations environment

## EXAMPLES

### EXAMPLE 1
```
Get-D365DmfMessageStatus -MessageId "84a383c8-336d-45e4-9933-0c3e8bfb734a"
```

This will get the message status through the DMF endpoint.
It will use "84a383c8-336d-45e4-9933-0c3e8bfb734a" as the MessageId parameter passed to the DMF endpoint.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 2
```
Get-D365DmfMessageStatus -MessageId "84a383c8-336d-45e4-9933-0c3e8bfb734a" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
```

This will import a package into the 123456789 job through the DMF endpoint.
It will use "84a383c8-336d-45e4-9933-0c3e8bfb734a" as the MessageId parameter passed to the DMF endpoint.
It will use "e674da86-7ee5-40a7-b777-1111111111111" as the Azure Active Directory guid.
It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the base D365FO environment url.
It will use "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
It will use "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.

### EXAMPLE 3
```
$token = Get-D365ODataToken
```

PS C:\\\> Get-D365DmfMessageStatus -MessageId "84a383c8-336d-45e4-9933-0c3e8bfb734a" -Token $token

This will get the message status through the DMF endpoint.
It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
It will use "84a383c8-336d-45e4-9933-0c3e8bfb734a" as the MessageId parameter passed to the DMF endpoint.

It will use the default OData configuration details that are stored in the configuration store.

## PARAMETERS

### -MessageId
MessageId of the message that you want to query the status for

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through DMF

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AADGuid

Required: False
Position: 2
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
Position: 3
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

### -WaitForCompletion
Instruct the cmdlet to wait until the Message Status is in a terminating state

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

### -Token
Pass a bearer token string that you want to use for while working against the endpoint

This can improve performance if you are iterating over a large collection/array

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
Tags: Import, Upload, DMF, Package, Packages, Message, MessageId, Message Status

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365ODataConfig]()

[Get-D365ActiveODataConfig]()

[Import-D365DmfPackage]()

[Set-D365ActiveODataConfig]()

