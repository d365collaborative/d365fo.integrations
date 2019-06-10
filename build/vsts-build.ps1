<#
This script publishes the module to the gallery.
It expects as input an ApiKey authorized to publish the module.

Insert any build steps you may need to take before publishing it here.
#>
param (
	$ApiKey,
	
	$WorkingDirectory = $env:SYSTEM_DEFAULTWORKINGDIRECTORY
)

# Prepare publish folder
Write-PSFMessage -Level Important -Message "Creating and populating publishing directory."
$publishDir = New-Item -Path $WorkingDirectory -Name publish -ItemType Directory

Write-PSFMessage -Level Important -Message "Copying files from the working directory to the publish directory."
Copy-Item -Path "$($WorkingDirectory)\d365fo.integrations" -Destination $publishDir.FullName -Recurse -Force

#region Gather text data to compile
$text = @()
$processed = @()

# Gather Stuff to run before
Write-PSFMessage -Level Important -Message "Fixing the before files."
foreach ($line in (Get-Content "$($PSScriptRoot)\filesBefore.txt" | Where-Object { $_ -notlike "#*" }))
{
	if ([string]::IsNullOrWhiteSpace($line)) { continue }
	
	$basePath = Join-Path "$($publishDir.FullName)\d365fo.integrations" $line
	foreach ($entry in (Resolve-PSFPath -Path $basePath))
	{
		$item = Get-Item $entry
		if ($item.PSIsContainer) { continue }
		if ($item.FullName -in $processed) { continue }
		$text += [System.IO.File]::ReadAllText($item.FullName)
		$processed += $item.FullName
	}
}

# Gather commands
Write-PSFMessage -Level Important -Message "Fetching internal functions."
Get-ChildItem -Path "$($publishDir.FullName)\d365fo.integrations\internal\functions\" -Recurse -File -Filter "*.ps1" | ForEach-Object {
	$text += [System.IO.File]::ReadAllText($_.FullName)
}

Write-PSFMessage -Level Important -Message "Fetching external functions."
Get-ChildItem -Path "$($publishDir.FullName)\d365fo.integrations\functions\" -Recurse -File -Filter "*.ps1" | ForEach-Object {
	$text += [System.IO.File]::ReadAllText($_.FullName)
}

# Gather stuff to run afterwards
Write-PSFMessage -Level Important -Message "Fixing the after files."
foreach ($line in (Get-Content "$($PSScriptRoot)\filesAfter.txt" | Where-Object { $_ -notlike "#*" }))
{
	if ([string]::IsNullOrWhiteSpace($line)) { continue }
	
	$basePath = Join-Path "$($publishDir.FullName)\d365fo.integrations" $line
	foreach ($entry in (Resolve-PSFPath -Path $basePath))
	{
		$item = Get-Item $entry
		if ($item.PSIsContainer) { continue }
		if ($item.FullName -in $processed) { continue }
		$text += [System.IO.File]::ReadAllText($item.FullName)
		$processed += $item.FullName
	}
}
#endregion Gather text data to compile

#region Update the psm1 file
Write-PSFMessage -Level Important -Message "Update the psm1 file."
$fileData = Get-Content -Path "$($publishDir.FullName)\d365fo.integrations\d365fo.integrations.psm1" -Raw
$fileData = $fileData.Replace('"<was not compiled>"', '"<was compiled>"')
$fileData = $fileData.Replace('"<compile code into here>"', ($text -join "`n`n"))
[System.IO.File]::WriteAllText("$($publishDir.FullName)\d365fo.integrations\d365fo.integrations.psm1", $fileData, [System.Text.Encoding]::UTF8)
#endregion Update the psm1 file

# Publish to Gallery
Write-PSFMessage -Level Important -Message "Running the publish command against PowerShell gallery."
Publish-Module -Path "$($publishDir.FullName)\d365fo.integrations" -NuGetApiKey $ApiKey -Force -Verbose