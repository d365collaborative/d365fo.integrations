$modules = @("PSFramework", "PSScriptAnalyzer", "Azure.Storage", "PSNotification", "PSOAuthHelper", "PowerShellGet", "PackageManagement")

Install-Module "Pester" -MaximumVersion 4.99.99 -Force -SkipPublisherCheck -AllowClobber

foreach ($module in $modules) {
    Write-Host "Installing $module" -ForegroundColor Cyan
    Install-Module $module -Force -SkipPublisherCheck -AllowClobber
    Import-Module $module -Force -PassThru
}