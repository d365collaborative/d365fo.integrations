Write-Host "Working on the machine named: $($env:computername)"
Write-Host "The user running is: $($env:UserName)"

$modules = @("PSFramework", "PSScriptAnalyzer", "Azure.Storage", "PSNotification", "PSOAuthHelper", "PowerShellGet", "PackageManagement")

Install-Module "Pester" -MaximumVersion 4.99.99 -Force -Confirm:$false -Scope CurrentUser -AllowClobber -SkipPublisherCheck

foreach ($item in $modules) {
    
    $module = Get-InstalledModule -Name $item -ErrorAction SilentlyContinue

    if ($null -eq $module) {
        Write-Host "Installing $item" -ForegroundColor Cyan
        Install-Module -Name $item -Force -Confirm:$false -Scope CurrentUser -AllowClobber -SkipPublisherCheck
    }

    Import-Module $item -Force
}