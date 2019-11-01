---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Export-D365DmfPackage

## SYNOPSIS
Export a DMF package from Dynamics 365 Finance & Operations

## SYNTAX

```
Export-D365DmfPackage [-Path] <String> [-JobId] <String> [[-Tenant] <String>] [[-Url] <String>]
 [[-ClientId] <String>] [[-ClientSecret] <String>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Exports a DMF package from the DMF endpoint of the Dynamics 365 Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Export-D365DmfPackage -Path "c:\temp\d365fo.tools\dmfpackage.zip" -JobId "db5e719a-8db3-4fe5-9c78-7be479ce85a2"
```

This will export a package from the 123456789 job through the DMF endpoint.
It will use "c:\temp\d365fo.tools\dmfpackage.zip" as the location to save the file.
It will use "db5e719a-8db3-4fe5-9c78-7be479ce85a2" as the jobid parameter passed to the DMF endpoint.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 2
```
Export-D365DmfPackage -Path "c:\temp\d365fo.tools\dmfpackage.zip" -JobId "db5e719a-8db3-4fe5-9c78-7be479ce85a2" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
```

This will export a package from the 123456789 job through the DMF endpoint.
It will use "c:\temp\d365fo.tools\dmfpackage.zip" as the location to save the file.
It will use "db5e719a-8db3-4fe5-9c78-7be479ce85a2" as the jobid parameter passed to the DMF endpoint.
It will use "e674da86-7ee5-40a7-b777-1111111111111" as the Azure Active Directory guid.
It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the base D365FO environment url.
It will use "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
It will use "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.

## PARAMETERS

### -Path
Path where you want the cmdlet to save the exported file to

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobId
JobId of the DMF job you want to export from

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

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through DMF

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

### -Url
URL / URI for the D365FO environment you want to access through DMF

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uri

Required: False
Position: 4
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

### System.String
## NOTES
Tags: Export, Download, DMF, Package, Packages, JobId

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365ODataConfig]()

[Get-D365ActiveODataConfig]()

[Set-D365ActiveODataConfig]()

