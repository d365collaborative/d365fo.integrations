function new-batchcontent ($count, $url, $authHeader, $payload)
{
    $data = "Content-Type: application/http`r`n"
    $data += "Content-Transfer-Encoding: binary`r`n"
    $data += "Content-ID: $count`r`n`r`n"
    $data += "POST $url HTTP/1.1`r`n"
    
    $data += "OData-Version: 4.0`r`n"
    $data += "OData-MaxVersion: 4.0`r`n"

    $data += "Content-Type: application/json;odata.metadata=minimal`r`n"
    
    $data += "Authorization: $authHeader`r`n`r`n"
    
    $data += "$Payload`r`n"

    $data
}