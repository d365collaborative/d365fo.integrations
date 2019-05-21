# Add all things you want to run after importing the main code

Write-Host "Loading all Configurations"

# Load Configurations
foreach ($file in (Get-ChildItem "$($script:ModuleRoot)\internal\configurations\*.ps1" -ErrorAction Ignore)) {
	. Import-ModuleFile -Path $file.FullName
}

Write-Host "Loading all Scriptblocks"

# Load Scriptblocks
foreach ($file in (Get-ChildItem "$($script:ModuleRoot)\internal\scriptblocks\*.ps1" -ErrorAction Ignore)) {
	. Import-ModuleFile -Path $file.FullName
}

Write-Host "Loading all Tab Expansions"

# Load Tab Expansion
foreach ($file in (Get-ChildItem "$($script:ModuleRoot)\internal\tepp\*.tepp.ps1" -ErrorAction Ignore)) {
	. Import-ModuleFile -Path $file.FullName
}

Write-Host "Loading all TEPP assignments"

# Load Tab Expansion Assignment
. Import-ModuleFile -Path "$($script:ModuleRoot)\internal\tepp\assignment.ps1"

Write-Host "Loading all license"

# Load License
. Import-ModuleFile -Path "$($script:ModuleRoot)\internal\scripts\license.ps1"

Write-Host "Loading all OData variables"

Update-ODataVariables