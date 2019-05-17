function Enable-d365Exception {
    [CmdletBinding()]
    param ()

    $PSDefaultParameterValues['*:EnableException'] = $true
}