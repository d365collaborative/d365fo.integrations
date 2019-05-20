function New-BatchContent {
    param(
        
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Url,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$AuthToken,
        [Parameter(Mandatory = $true, Position = 3)]
        [string]$Payload,
        [Parameter(Mandatory = $true, Position = 4)]
        [string]$Count
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
    
    $null = $dataBuilder.AppendLine("Authorization: $AuthToken")
    $null = $dataBuilder.AppendLine("") #On purpose!
    
    $null = $dataBuilder.AppendLine("$Payload")

    $dataBuilder.ToString()
}
<#
