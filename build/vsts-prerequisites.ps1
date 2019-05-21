$modules = @("Pester", "PSFramework", "PSScriptAnalyzer", "Azure.Storage", "PSNotification", "PSOAuthHelper")

foreach ($module in $modules) {
    Write-Host "Installing $module" -ForegroundColor Cyan
    Install-Module $module -Force -SkipPublisherCheck
    Import-Module $module -Force -PassThru
}