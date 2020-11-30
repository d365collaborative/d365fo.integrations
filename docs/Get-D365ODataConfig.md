---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365ODataConfig

## SYNOPSIS
Get OData configs

## SYNTAX

```
Get-D365ODataConfig [[-Name] <String>] [-OutputAsHashtable] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Get all OData configuration objects from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Get-D365ODataConfig
```

This will display all OData configurations on the machine.

### EXAMPLE 2
```
Get-D365ODataConfig -OutputAsHashtable
```

This will display all OData configurations on the machine.
Every object will be output as a hashtable, for you to utilize as parameters for other cmdlets.

### EXAMPLE 3
```
Get-D365ODataConfig -Name "UAT"
```

This will display the OData configuration that is saved with the name "UAT" on the machine.

## PARAMETERS

### -Name
The name of the OData configuration you are looking for

The parameter supports wildcards.
E.g.
-Name "*Customer*"

Default value is "*" to display all OData configs

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
## NOTES
Tags: OData, Environment, Config, Configuration, ClientId, ClientSecret

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365BroadcastMessageConfig]()

[Clear-D365ActiveBroadcastMessageConfig]()

[Get-D365ActiveBroadcastMessageConfig]()

[Remove-D365BroadcastMessageConfig]()

[Send-D365BroadcastMessage]()

[Set-D365ActiveBroadcastMessageConfig]()

