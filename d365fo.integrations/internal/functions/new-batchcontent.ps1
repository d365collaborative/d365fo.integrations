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
    
    # $null = $dataBuilder.Append(
    $null = $dataBuilder.Append("Content-Type: application/http{0}" -f [System.Environment]::NewLine)
    $null = $dataBuilder.Append("Content-Transfer-Encoding: binary{0}" -f [System.Environment]::NewLine)
    $null = $dataBuilder.Append("Content-ID: $Count{0}{0}" -f [System.Environment]::NewLine)
    $null = $dataBuilder.Append("POST $Url HTTP/1.1{0}" -f [System.Environment]::NewLine)
    
    $null = $dataBuilder.Append("OData-Version: 4.0{0}" -f [System.Environment]::NewLine)
    $null = $dataBuilder.Append("OData-MaxVersion: 4.0{0}" -f [System.Environment]::NewLine)

    $null = $dataBuilder.Append("Content-Type: application/json;odata.metadata=minimal{0}" -f [System.Environment]::NewLine)
    
    $null = $dataBuilder.Append("Authorization: $AuthToken{0}{0}" -f [System.Environment]::NewLine)
    
    $null = $dataBuilder.Append("$Payload" + [System.Environment]::NewLine)

    $dataBuilder.ToString()
}