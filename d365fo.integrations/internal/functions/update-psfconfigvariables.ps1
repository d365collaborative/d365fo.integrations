<#
.SYNOPSIS
Update module variables from the configuration store

.DESCRIPTION
Update all module variables that are based on the PSF configuration store

.EXAMPLE
PS C:\> Update-PsfConfigVariables

This will update all module variables based on the configuration store.

.NOTES
Tags: Variable, Variables

Author: Mötz Jensen (@Splaxi)
#>

function Update-PsfConfigVariables {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]

    [CmdletBinding()]
    [OutputType()]
    param ()

    foreach ($config in Get-PSFConfig -FullName "d365fo.integrations.azure.*") {
        $item = $config.FullName.Replace("d365fo.integrations.", "")
        $name = (Get-Culture).TextInfo.ToTitleCase($item).Replace(".","")
        
        Write-PSFMessage -Level Verbose -Message "$name" -Target $($config.Value)
        Set-Variable -Name $name -Value $config.Value -Scope Script
    }
    
    foreach ($config in Get-PSFConfig -FullName "d365fo.integrations.dmf.*") {
        $item = $config.FullName.Replace("d365fo.integrations.", "")
        $name = (Get-Culture).TextInfo.ToTitleCase($item).Replace(".","")
        
        Write-PSFMessage -Level Verbose -Message "$name" -Target $($config.Value)
        Set-Variable -Name $name -Value $config.Value -Scope Script
    }
}