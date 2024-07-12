---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365ODataMetadata

## SYNOPSIS
Downloads the OData metadata for a Dynamics 365 for Finance and Operations environment as an .edmx file.

## SYNTAX

```
Get-D365ODataMetadata [-Path] <String> [[-Url] <String>] [[-Tenant] <String>] [[-ClientId] <String>]
 [[-ClientSecret] <String>] [[-Token] <String>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
The Get-D365ODataMetadata cmdlet downloads the OData metadata for a Dynamics 365 for Finance and Operations environment as an .edmx file.

## EXAMPLES

### EXAMPLE 1
```
Get-D365ODataMetadata -Path "C:\Temp\d365fo.edmx"
```

Downloads the OData metadata for the environment specified by the active configuration and saves it to the file "C:\Temp\d365fo.edmx".

### EXAMPLE 2
```
$token = Get-D365ODataToken
```

PS C:\\\> Get-D365ODataPublicEntity -Path "C:\Temp\d365fo.edmx" -Token $token

Downloads the OData metadata for the environment specified by the active configuration and saves it to the file "C:\Temp\d365fo.edmx".
It will get a fresh token based on the active configuration, saved it into the token variable and pass it to the cmdlet.

### EXAMPLE 3
```
Get-D365ODataMetadata -Path "C:\Temp\d365fo.edmx" -Url "https://uat.sandbox.operations.dynamics.com" -Tenant "3718c2ef-850b-462a-93e9-58a26d54346e" -ClientId "60adecfa-99bc-47c7-b0cd-0ba61a91375f" -ClientSecret "du1234/mM4N7F1234Gf3TWp/1234jqn7RcbpG4C1234="
```

Downloads the OData metadata for the environment specified by the parameters and saves it to the file "C:\Temp\d365fo.edmx".

## PARAMETERS

### -Path
The path to the .edmx file where the OData metadata will be saved.

While the .edmx extension is recommended, the .xml extension can also be used.

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

### -Url
The URL of the Dynamics 365 for Finance and Operations environment for which the OData metadata is to be downloaded.

This parameter is optional if a configuration has been added with the Add-D365ODataConfig cmdlet.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uri

Required: False
Position: 2
Default value: $Script:ODataUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
The tenant id (guid) of the Dynamics 365 for Finance and Operations environment for which the OData metadata is to be downloaded.

This parameter is used when authenticating the download request.
This parameter is optional if a configuration has been added with the Add-D365ODataConfig cmdlet.

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AadGuid

Required: False
Position: 3
Default value: $Script:ODataTenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
The client id (guid) of the Azure Active Directory application that is used to authenticate the download request.

This parameter is used when authenticating the download request.
See https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/services-home-page#authentication for more information on authenticating OData requests.
This parameter is optional if a configuration has been added with the Add-D365ODataConfig cmdlet.

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
The client secret of the Azure Active Directory application that is used to authenticate the download request.

This parameter is used when authenticating the download request.
This parameter is optional if a configuration has been added with the Add-D365ODataConfig cmdlet.

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

### -Token
The bearer token to use for the request.
If this parameter is not supplied, the cmdlet will attempt to get a new token using the supplied parameters.

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
If this switch is enabled, the cmdlet will throw an exception if an error occurs.
Otherwise, the cmdlet will write an error message to the host.

This parameters disables user-friendly warnings, which is less user friendly, but allows catching exceptions in calling scripts.

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
Tags: OData, Data, Metadata

Author: Florian Hopfner (@FH-Inway)

## RELATED LINKS
