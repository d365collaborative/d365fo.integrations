---
external help file: d365fo.integrations-help.xml
Module Name: d365fo.integrations
online version:
schema: 2.0.0
---

# Invoke-D365RestEndpoint

## SYNOPSIS
Invoke a REST Endpoint in Dynamics 365 Finance & Operations

## SYNTAX

```
Invoke-D365RestEndpoint [-ServiceName] <String> [[-Payload] <String>] [[-Tenant] <String>] [[-URL] <String>]
 [[-ClientId] <String>] [[-ClientSecret] <String>] [[-Token] <String>] [-EnableException]
 [[-TimeoutSec] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Invokce any REST Endpoint available in a Dynamics 365 Finance & Operations environment

It can be REST endpoints that are available out of the box or custom REST endpoints based on X++ classesrations platform

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload "{"RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}"
```

This will invoke the REST endpoint in the  Dynamics 365 Finance & Operations environment.
The ServiceName used for the import is "UserSessionService/AifUserSessionService/GetUserSessionInfo".
The Payload is a valid json string, containing all the needed properties.

### EXAMPLE 2
```
$Payload = '{"RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
```

PS C:\\\> Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload $Payload

This will invoke the REST endpoint in the  Dynamics 365 Finance & Operations environment.
First the desired json data is put into the $Payload variable.
The ServiceName used for the import is "UserSessionService/AifUserSessionService/GetUserSessionInfo".
The $Payload variable is passed to the cmdlet.

### EXAMPLE 3
```
$token = Get-D365ODataToken
```

PS C:\\\> Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload "{"RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}" -Token $token

This will invoke the REST endpoint in the  Dynamics 365 Finance & Operations environment.
It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
The ServiceName used for the import is "UserSessionService/AifUserSessionService/GetUserSessionInfo".
The Payload is a valid json string, containing all the needed properties.

## PARAMETERS

### -ServiceName
The "name" of the REST endpoint that you want to invoke

The REST endpoints consists of the following elementes:
ServiceGroupName/ServiceName/MethodName

E.g.
"UserSessionService/AifUserSessionService/GetUserSessionInfo"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Payload
The entire string contain the json object that you want to pass to the REST endpoint

If the payload parameter is NOT null, it will trigger a HTTP POST action against the URL.

But if the payload is null, it will trigger a HTTP GET action against the URL.

Remember that json is text based and can use either single quotes (') or double quotes (") as the text qualifier, so you might need to escape the different quotes in your payload before passing it in

```yaml
Type: String
Parameter Sets: (All)
Aliases: Json

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through REST endpoint

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

### -URL
URL / URI for the D365FO environment you want to access through REST endpoint

```yaml
Type: String
Parameter Sets: (All)
Aliases: URI

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

### -Token
Pass a bearer token string that you want to use for while working against the endpoint

This can improve performance if you are iterating over a large collection/array

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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

### -TimeoutSec
Specifies how long the request can be pending before it times out.
Enter a value in seconds.
The default value, 0, specifies an indefinite time-out.
A Domain Name System (DNS) query can take up to 15 seconds to return or time out.
If your request contains a host name that requires resolution, and you set TimeoutSec to a value greater than zero, but less than 15 seconds, it can take 15 seconds or more before a WebException is thrown, and your request times out.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: REST, Endpoint, Custom Service, Services

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
