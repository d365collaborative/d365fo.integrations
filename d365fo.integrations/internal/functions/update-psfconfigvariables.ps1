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