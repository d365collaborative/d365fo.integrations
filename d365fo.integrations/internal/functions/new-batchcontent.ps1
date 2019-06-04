
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
        
    .PARAMETER Count
        The index number that the content should be stamped with, to be valid in the entire batch request content
        
    .EXAMPLE
        PS C:\> New-BatchContent -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com/data/ExchangeRates" -AuthenticationToken "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....." -Payload '{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}' -Count 1
        
        This will create a new batch content string.
        It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com/data/ExchangeRates" as the endpoint for the content.
        It will use the "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....." as the bearer token for the endpoint.
        It will use '{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}' as the payload that needs to be included in the batch content.
        Iw will use 1 as the counter in the batch content number sequence.
        
    .NOTES
        Tags: OData, Data Entity, Batchmode, Batch, Batch Content, Multiple
        
        Author: Mötz Jensen (@Splaxi)
        Author: Rasmus Andersen (@ITRasmus)
        
#>

function New-BatchContent {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param(
        
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $Url,
        [Parameter(Mandatory = $true, Position = 2)]
        [string] $AuthenticationToken,
        [Parameter(Mandatory = $true, Position = 3)]
        [string] $Payload,
        [Parameter(Mandatory = $true, Position = 4)]
        [string] $Count
    )

    $dataBuilder = [System.Text.StringBuilder]::new()
    
    $null = $dataBuilder.AppendLine("Content-Type: application/http")
    $null = $dataBuilder.AppendLine("Content-Transfer-Encoding: binary")
    $null = $dataBuilder.AppendLine("Content-ID: $Count")
    $null = $dataBuilder.AppendLine("") #On purpose!
    $null = $dataBuilder.AppendLine("POST $Url HTTP/1.1")
    
    $null = $dataBuilder.AppendLine("OData-Version: 4.0")
    $null = $dataBuilder.AppendLine("OData-MaxVersion: 4.0")

    $null = $dataBuilder.AppendLine("Content-Type: application/json;odata.metadata=minimal")
    
    $null = $dataBuilder.AppendLine("Authorization: $AuthenticationToken")
    $null = $dataBuilder.AppendLine("") #On purpose!
    
    $null = $dataBuilder.AppendLine("$Payload")

    $dataBuilder.ToString()
}