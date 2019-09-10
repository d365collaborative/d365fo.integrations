$modules = @("Pester", "PSFramework", "PSScriptAnalyzer", "Azure.Storage", "PSNotification", "PSOAuthHelper", "PowerShellGet", "PackageManagement")

foreach ($module in $modules) {
    Write-Host "Installing $module" -ForegroundColor Cyan
    Install-Module $module -Force -SkipPublisherCheck -AllowClobber
    Import-Module $module -Force -PassThru
}