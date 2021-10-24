---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Set-D365ODataTokenInSession

## SYNOPSIS
Set the token for the remaing of the session

## SYNTAX

```
Set-D365ODataTokenInSession [-BearerToken] <String> [<CommonParameters>]
```

## DESCRIPTION
Sets the token for the remaing of the session, via the $PSDefaultParameterValues variable

When the token expires, you will have to do a new authentication request again

## EXAMPLES

### EXAMPLE 1
```
Set-D365ODataTokenInSession -BearerToken "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....."
```

This sets the Token parameter value for all cmdlets, for the remaining of the session.
Sets the Token parameter value to "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi.....".

### EXAMPLE 2
```
$token = Get-D365ODataToken
```

PS C:\\\> Set-D365ODataTokenInSession -BearerToken $token

This sets the Token parameter value for all cmdlets, for the remaining of the session.
It gets a token from the Get-D365ODataToken cmdlet and stores it in the $token variable.
Sets the Token parameter value to the value of the $token variable.

### EXAMPLE 3
```
Get-D365ODataToken | Set-D365ODataTokenInSession
```

This sets the Token parameter value for all cmdlets, for the remaining of the session.
It gets a token from the Get-D365ODataToken cmdlet and pipes it into Set-D365ODataTokenInSession.

### EXAMPLE 4
```
$token = Get-D365ODataTokenInteractive
```

PS C:\\\> Set-D365ODataTokenInSession -BearerToken $token

This sets the Token parameter value for all cmdlets, for the remaining of the session.
It gets a token from the Get-D365ODataTokenInteractive cmdlet and stores it in the $token variable.
Sets the Token parameter value to the value of the $token variable.

### EXAMPLE 5
```
Get-D365ODataTokenInteractive | Set-D365ODataTokenInSession
```

This sets the Token parameter value for all cmdlets, for the remaining of the session.
It gets a token from the Get-D365ODataTokenInteractive cmdlet and pipes it into Set-D365ODataTokenInSession.

## PARAMETERS

### -BearerToken
Pass the bearer token string that you want to use for the default token value across the module

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Exception, Exceptions, Warning, Warnings

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
