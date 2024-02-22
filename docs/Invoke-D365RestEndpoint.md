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
Invoke-D365RestEndpoint [-ServiceName] <String> [[-Payload] <String>] [[-PayloadCharset] <String>]
 [[-RetryTimeout] <TimeSpan>] [[-ThrottleSeed] <Int32>] [[-Tenant] <String>] [[-Url] <String>]
 [[-SystemUrl] <String>] [[-ClientId] <String>] [[-ClientSecret] <String>] [[-Token] <String>]
 [-EnableException] [[-TimeoutSec] <Int32>] [<CommonParameters>]
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

### EXAMPLE 4
```
$Payload = '{"RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
```

PS C:\\\> Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload $Payload  -RetryTimeout "00:01:00"

This will invoke the REST endpoint in the  Dynamics 365 Finance & Operations environment, and try for 1 minute to handle 429.
First the desired json data is put into the $Payload variable.
The ServiceName used for the import is "UserSessionService/AifUserSessionService/GetUserSessionInfo".
The $Payload variable is passed to the cmdlet.
It will only try to handle 429 retries for 1 minute, before failing.

### EXAMPLE 5
```
$Payload = '{"RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
```

PS C:\\\> Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload $Payload -ThrottleSeed 2

This will invoke the REST endpoint in the  Dynamics 365 Finance & Operations environment, and sleep/pause between 1 and 2 seconds.
First the desired json data is put into the $Payload variable.
The ServiceName used for the import is "UserSessionService/AifUserSessionService/GetUserSessionInfo".
The $Payload variable is passed to the cmdlet.
It will use the ThrottleSeed 2 to sleep/pause the execution, to mitigate the 429 pushback from the endpoint.

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

### -PayloadCharset
The charset / encoding that you want the cmdlet to use while invoking the odata entity action

The default value is: "UTF8"

The charset has to be a valid http charset like: ASCII, ANSI, ISO-8859-1, UTF-8

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: UTF-8
Accept pipeline input: False
Accept wildcard characters: False
```

### -RetryTimeout
The retry timeout, before the cmdlet should quit retrying based on the 429 status code

Needs to be provided in the timspan notation:
"hh:mm:ss"

hh is the number of hours, numerical notation only
mm is the number of minutes
ss is the numbers of seconds

Each section of the timeout has to valid, e.g.
hh can maximum be 23
mm can maximum be 59
ss can maximum be 59

Not setting this parameter will result in the cmdlet to try for ever to handle the 429 push back from the endpoint

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 00:00:00
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThrottleSeed
Instruct the cmdlet to invoke a thread sleep between 1 and ThrottleSeed value

This is to help to mitigate the 429 retry throttling on the OData / Custom Service endpoints

It makes most sense if you are running things a outer loop, where you will hit the OData / Custom Service endpoints with a burst of calls in a short time

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through REST endpoint

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AadGuid

Required: False
Position: 6
Default value: $Script:ODataTenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
URL / URI for the D365FO environment you want to access through REST endpoint

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uri

Required: False
Position: 7
Default value: $Script:ODataUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### -SystemUrl
URL / URI for the D365FO instance where the OData endpoint is available

If you are working against a D365FO instance, it will be the URL / URI for the instance itself, which is the same as the Url parameter value

If you are working against a D365 Talent / HR instance, this will to be full instance URL / URI like "https://aos-rts-sf-b1b468164ee-prod-northeurope.hr.talent.dynamics.com/namespaces/0ab49d18-6325-4597-97b3-c7f2321aa80c"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: $Script:ODataSystemUrl
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
Position: 9
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
Position: 10
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
Position: 11
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
Position: 12
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
