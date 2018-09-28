function new-batchcontent {
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



    $data = "Content-Type: application/http`r`n"
    $data += "Content-Transfer-Encoding: binary`r`n"
    $data += "Content-ID: $Count`r`n`r`n"
    $data += "POST $Url HTTP/1.1`r`n"
    
    $data += "OData-Version: 4.0`r`n"
    $data += "OData-MaxVersion: 4.0`r`n"

    $data += "Content-Type: application/json;odata.metadata=minimal`r`n"
    
    $data += "Authorization: $AuthToken`r`n`r`n"
    
    $data += "$Payload`r`n"

    $data
}