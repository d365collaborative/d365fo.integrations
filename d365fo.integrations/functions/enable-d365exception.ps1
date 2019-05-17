
<#
    .SYNOPSIS
        Enable exceptions to be thrown
        
    .DESCRIPTION
        Change the default exception behavior of the module to support throwing exceptions
        
    .EXAMPLE
        PS C:\>
        
    .NOTES
        General notes
#>

function Enable-d365Exception {
    [CmdletBinding()]
    param ()

    $PSDefaultParameterValues['*:EnableException'] = $true
}