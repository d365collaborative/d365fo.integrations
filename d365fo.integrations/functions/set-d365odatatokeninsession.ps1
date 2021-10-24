
<#
    .SYNOPSIS
        Set the token for the remaing of the session
        
    .DESCRIPTION
        Sets the token for the remaing of the session, via the $PSDefaultParameterValues variable
        
        When the token expires, you will have to do a new authentication request again
        
    .PARAMETER BearerToken
        Pass the bearer token string that you want to use for the default token value across the module
        
    .EXAMPLE
        PS C:\> Set-D365ODataTokenInSession -BearerToken "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....."
        
        This sets the Token parameter value for all cmdlets, for the remaining of the session.
        Sets the Token parameter value to "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi.....".
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataToken
        PS C:\> Set-D365ODataTokenInSession -BearerToken $token
        
        This sets the Token parameter value for all cmdlets, for the remaining of the session.
        It gets a token from the Get-D365ODataToken cmdlet and stores it in the $token variable.
        Sets the Token parameter value to the value of the $token variable.
        
    .EXAMPLE
        PS C:\> Get-D365ODataToken | Set-D365ODataTokenInSession
        
        This sets the Token parameter value for all cmdlets, for the remaining of the session.
        It gets a token from the Get-D365ODataToken cmdlet and pipes it into Set-D365ODataTokenInSession.
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataTokenInteractive
        PS C:\> Set-D365ODataTokenInSession -BearerToken $token
        
        This sets the Token parameter value for all cmdlets, for the remaining of the session.
        It gets a token from the Get-D365ODataTokenInteractive cmdlet and stores it in the $token variable.
        Sets the Token parameter value to the value of the $token variable.
        
    .EXAMPLE
        PS C:\> Get-D365ODataTokenInteractive | Set-D365ODataTokenInSession
        
        This sets the Token parameter value for all cmdlets, for the remaining of the session.
        It gets a token from the Get-D365ODataTokenInteractive cmdlet and pipes it into Set-D365ODataTokenInSession.
        
    .NOTES
        Tags: Exception, Exceptions, Warning, Warnings
        
        Author: Mötz Jensen (@Splaxi)
#>

function Set-D365ODataTokenInSession {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $BearerToken
    )

    process {
        Write-PSFMessage -Level Verbose -Message "Setting the token value across the entire module."
    
        $Global:PSDefaultParameterValues['*:Token'] = $BearerToken
    }
}