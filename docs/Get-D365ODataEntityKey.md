---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Get-D365ODataEntityKey

## SYNOPSIS
Get key field(s) from Data Entity

## SYNTAX

```
Get-D365ODataEntityKey [-Name] <String> [-Properties] <PSObject> [-OutputSample] [<CommonParameters>]
```

## DESCRIPTION
Get the key field(s) from a Data Entity and its meta data

## EXAMPLES

### EXAMPLE 1
```
Get-D365ODataPublicEntity -EntityName CustomersV3 | Get-D365ODataEntityKey | Format-List
```

This will extract all the relevant key fields from the Data Entity.
The "CustomersV3" value is used to get the desired Data Entity.
The output from Get-D365ODataPublicEntity is piped into Get-D365ODataEntityKey.
All key fields will be extracted and displayed.
The output will be formatted as a list.

### EXAMPLE 2
```
Get-D365ODataPublicEntity -EntityName CustomersV3 | Get-D365ODataEntityKey
```

This will output a sample of the key from the Data Entity.
The "CustomersV3" value is used to get the desired Data Entity.
The output from Get-D365ODataPublicEntity is piped into Get-D365ODataEntityKey.
All key fields will be concatenated and displayed.

## PARAMETERS

### -Name
Name of the Data Entity

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

### -Properties
The properties value from the meta data object

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OutputSample
Instruct the cmdlet to output a sample of the key

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
Tags: OData, Data, Entity, MetaData, Meta, Key, Keys

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365ODataPublicEntity]()

