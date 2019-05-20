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
    
    $data = "Content-Type: application/http{0}" -f [System.Environment]::NewLine
    $data += "Content-Transfer-Encoding: binary{0}" -f [System.Environment]::NewLine
    $data += "Content-ID: $Count{0}{0}" -f [System.Environment]::NewLine
    $data += "POST $Url HTTP/1.1{0}" -f [System.Environment]::NewLine
    
    $data += "OData-Version: 4.0{0}" -f [System.Environment]::NewLine
    $data += "OData-MaxVersion: 4.0{0}" -f [System.Environment]::NewLine

    $data += "Content-Type: application/json;odata.metadata=minimal{0}" -f [System.Environment]::NewLine
    
    $data += "Authorization: $AuthToken{0}{0}" -f [System.Environment]::NewLine
    
    $data += "$Payload" + [System.Environment]::NewLine

    $data
}