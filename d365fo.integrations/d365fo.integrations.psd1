@{
    # Script module or binary module file associated with this manifest
    RootModule   = 'd365fo.integrations.psm1'
	
    # Version number of this module.
    ModuleVersion     = '0.4.32'
	
    # ID used to uniquely identify this module
    GUID              = 'd2667b62-1436-42b3-a840-ab6b4a0e5aa0'
	
    # Author of this module
    Author            = 'Mötz Jensen & Rasmus Andersen'

    # Company or vendor of this module
    CompanyName       = 'Essence Solutions'

    # Copyright statement for this module
    Copyright         = '(c) 2018 Mötz Jensen & Rasmus Andersen. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Tools for working against the OData and DMF endpoint with the D365FO platform'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'
	
    # Modules that must be imported into the global environment prior to importing
    # this module
    RequiredModules   = @(
        @{ ModuleName = 'PSFramework'; ModuleVersion = '1.0.13' }
        , @{ ModuleName = 'Azure.Storage'; ModuleVersion = '4.4.0' }
        ,	@{ ModuleName = 'PSNotification'; ModuleVersion = '0.5.3' }
        ,	@{ ModuleName = 'PSOAuthHelper'; ModuleVersion = '0.3.0' }
    )
	
    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @('bin\d365fo.integrations.dll')
	
    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @('xml\d365fo.integrations.Types.ps1xml')
	
    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @('xml\d365fo.integrations.Format.ps1xml')
	
    # Functions to export from this module
    FunctionsToExport = @(
        	'Add-D365ODataConfig'
		,	'Enable-D365ExceptionIntegrations'
		,	'Export-D365DmfPackage'
		
        ,   'Get-D365ActiveODataConfig'
        ,   'Get-D365DmfDataEntity'
        ,   'Get-D365DmfMessageStatus'
        ,	'Get-D365ODataConfig'
        ,   'Get-D365ODataEntityData'
        ,   'Get-D365ODataEntityDataByKey'
        ,   'Get-D365ODataEntityKey'
        ,   'Get-D365ODataEntityMandatoryField'
        ,   'Get-D365ODataEntityUrl'
        ,	'Get-D365ODataPublicEntity'
        ,   'Get-D365ODataPublicEnum'
        ,   'Get-D365ODataToken'
        
        ,   'Get-D365RestServiceGroup'
        ,   'Get-D365RestService'
        ,   'Get-D365RestServiceOperation'
        ,   'Get-D365RestServiceOperationDetails'

        ,   'Import-D365DmfPackage'
        ,   'Import-D365ODataEntity'
        ,   'Import-D365ODataEntityBatchMode'

        ,   'Invoke-D365DmfInit'
        ,   'Invoke-D365ODataEntityAction',
        ,   'Invoke-D365RestEndpoint'
        
        ,   'Remove-D365ODataEntity'
        ,   'Remove-D365ODataEntityBatchMode'
        
        ,	'Set-D365ActiveODataConfig'
        ,   'Update-D365ODataEntity'
        ,   'Update-D365ODataEntityBatchMode'
    )
	
    # Cmdlets to export from this module
    CmdletsToExport   = ''
	
    # Variables to export from this module
    VariablesToExport = ''
	
    # Aliases to export from this module
    AliasesToExport   = ''
	
    # List of all modules packaged with this module
    ModuleList        = @()
	
    # List of all files packaged with this module
    FileList          = @()
	
    # Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{
		
        #Support for PowerShellGet galleries.
        PSData = @{
			
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('d365fo', 'Dynamics365', 'D365', 'Finance&Operations', 'FinanceOperations', 'FinanceAndOperations', 'Dynamics365FO')
			
            # A URL to the license for this module.
            LicenseUri   = "https://opensource.org/licenses/MIT"
			
            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/d365collaborative/d365fo.integrations'
			
            # A URL to an icon representing this module.
            # IconUri = ''
			
            # ReleaseNotes of this module
            # ReleaseNotes = ''

            IsPrerelease = 'True'
			
        } # End of PSData hashtable
		
    } # End of PrivateData hashtable
}