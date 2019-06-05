---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365ActiveODataConfig

## SYNOPSIS
Get the active OData configuration

## SYNTAX

```
Get-D365ActiveODataConfig [-OutputAsHashtable] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Get the active OData configuration from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Get-D365ActiveODataConfig
```

This will get the active OData configuration.

## PARAMETERS

### -OutputAsHashtable
Instruct the cmdlet to return a hashtable object

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: OData, Environment, Config, Configuration, ClientId, ClientSecret

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365BroadcastMessageConfig]()

[Clear-D365ActiveBroadcastMessageConfig]()

[Get-D365BroadcastMessageConfig]()

[Remove-D365BroadcastMessageConfig]()

[Send-D365BroadcastMessage]()

[Set-D365ActiveBroadcastMessageConfig]()

