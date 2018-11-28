
function remove-D365OData {
    [CmdletBinding()]
    param(
        
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$D365FOUrl,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$Authority,
        [Parameter(Mandatory = $true, Position = 3)]
        [string]$ClientId,
        [Parameter(Mandatory = $true, Position = 4)]
        [String]$ClientSecret,
        [Parameter(Mandatory = $true, Position = 5)]
        [string]$Request
    )


    $SessionsVariables = @{
        D365FOUrl    = $D365FOUrl; 
        Authority    = $Authority;
        ClientId     = $ClientId;
        ClientSecret = $ClientSecret;
    }

    Set-AuthoritySession -Values $SessionsVariables

    $webRequest = New-WebRequest "$D365FOUrl/$Request" "DELETE"  $Request  "JSON" "application/json;odata.metadata=minimal"

    if (Test-PSFFunctionInterrupt) {return }

    
    Get-IntegrationResponse -WebRequest $webRequest -ExpectedResult ([System.Net.HttpStatusCode]::NoContent)


}