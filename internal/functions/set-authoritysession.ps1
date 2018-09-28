function Set-AuthoritySession {
    [CmdletBinding()]
    param (
        [HashTable] $Values
    )

    if ($Values.Contains("D365FOUrl")) {
        $Script:D365FOURL = $Values.Item("D365FOUrl");
    }

    if ($Values.Contains("Authority")) {
        $Script:Authority = $Values.Item("Authority");
    }
    if ($Values.Contains("ClientId")) {
        $Script:ClientId = $Values.Item("ClientId");
    }
    if ($Values.Contains("ClientSecret")) {
        $Script:ClientSecret = $Values.Item("ClientSecret");
    }
        


}
