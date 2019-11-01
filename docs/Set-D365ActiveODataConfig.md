---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Set-D365ActiveODataConfig

## SYNOPSIS
Set the active OData configuration

## SYNTAX

```
Set-D365ActiveODataConfig [-Name] <String> [-Temporary] [<CommonParameters>]
```

## DESCRIPTION
Updates the current active OData configuration with a new one

## EXAMPLES

### EXAMPLE 1
```
Set-D365ActiveODataConfig -Name "UAT"
```

This will set the OData configuration named "UAT" as the active configuration.

## PARAMETERS

### -Name
Name of the OData configuration you want to load into the active OData configuration

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

### -Temporary
Instruct the cmdlet to only temporarily override the persisted settings in the configuration store

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
Tags: Environment, Config, Configuration, ClientId, ClientSecret

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
