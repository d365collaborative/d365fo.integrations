$scriptBlock = { Get-D365ODataConfig | Sort-Object Name | Select-Object -ExpandProperty Name }

Register-PSFTeppScriptblock -Name "d365odata.config.names" -ScriptBlock $scriptBlock -Mode Simple
