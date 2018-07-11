$script:PSModuleRoot = $PSScriptRoot


function Import-ModuleFile {

    [CmdletBinding()]
    Param (
        [string]
        $Path
    )
    if ($doDotSource) { . $Path }
    else { $ExecutionContext.InvokeCommand.InvokeScript($false, ([scriptblock]::Create([io.file]::ReadAllText($Path))), $null, $null) }
}


$script:doDotSource = $false
if ($psframework_dotsourcemodule) { $script:doDotSource = $true }
if (($PSVersionTable.PSVersion.Major -lt 6) -or ($PSVersionTable.OS -like "*Windows*")) {

    if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsPowerShell\PSFramework\System" -Name "DoDotSource" -ErrorAction Ignore).DoDotSource) { $script:doDotSource = $true }
    if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\WindowsPowerShell\PSFramework\System" -Name "DoDotSource" -ErrorAction Ignore).DoDotSource) { $script:doDotSource = $true }
}


# All internal functions privately available within the toolset
foreach ($function in (Get-ChildItem "$script:PSModuleRoot\internal\functions\*.ps1")) {
    . Import-ModuleFile $function.FullName
}
# All public functions available within the toolset
foreach ($function in (Get-ChildItem "$script:PSModuleRoot\functions\*.ps1")) {
    . Import-ModuleFile $function.FullName
}