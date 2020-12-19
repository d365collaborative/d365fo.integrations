
<#
    .SYNOPSIS
        Create batch content
        
    .DESCRIPTION
        Create a valid batch content that can be used in a HTTP batch request
        
    .PARAMETER Url
        URL / URI that the batch content should be valid for
        
        Normally the final URL / URI for the OData endpoint that the content is to be imported into
        
    .PARAMETER AuthenticationToken
        The token value that should be used to authenticate against the URL / URI endpoint
        
    .PARAMETER Payload
        The entire string contain the json object that you want to import into the D365FO environment
        
    .PARAMETER PayloadCharset
        The charset / encoding that you want the cmdlet to use while updating the odata entity
        
        The default value is: "UTF8"
        
        The charset has to be a valid http charset like: ASCII, ANSI, ISO-8859-1, UTF-8
        
    .PARAMETER Count
        The index number that the content should be stamped with, to be valid in the entire batch request content
        
    .PARAMETER Method
        Specify the HTTP method that you want the batch payload to perform
        
        Default value is: "POST"
        
    .EXAMPLE
        PS C:\> New-BatchContent -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com/data/ExchangeRates" -Payload '{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}' -Count 1
        
        This will create a new batch content string.
        It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com/data/ExchangeRates" as the endpoint for the content.
        It will use the "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....." as the bearer token for the endpoint.
        It will use '{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}' as the payload that needs to be included in the batch content.
        Iw will use 1 as the counter in the batch content number sequence.
        
    .NOTES
        Tags: OData, Data Entity, Batchmode, Batch, Batch Content, Multiple
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function New-BatchKey {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param(
        
        [Parameter(Mandatory = $true)]
        [string] $Url,
        
        [Parameter(Mandatory = $true)]
        [string] $Count,

        [string] $Method = "POST"
    )

    $dataBuilder = [System.Text.StringBuilder]::new()
    
    $null = $dataBuilder.AppendLine("Content-Type: application/http")
    $null = $dataBuilder.AppendLine("Content-Transfer-Encoding: binary")
    $null = $dataBuilder.AppendLine("Content-ID: $Count")

    $null = $dataBuilder.AppendLine("") #On purpose!
    $null = $dataBuilder.AppendLine("$Method $Url HTTP/1.1")
    $null = $dataBuilder.AppendLine("") #On purpose!

    $dataBuilder.ToString()
}