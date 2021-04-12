
<#
    .SYNOPSIS
        Import a DMF package into Dynamics 365 Finance & Operations
        
    .DESCRIPTION
        Imports a DMF package into the DMF endpoint of the Dynamics 365 Finance & Operations
        
    .PARAMETER Path
        Path of the file that you want to import into D365FO
        
    .PARAMETER JobId
        JobId of the DMF job you want to import into
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through DMF
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access through DMF
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Import-D365DmfPackage -Path "c:\temp\d365fo.tools\dmfpackage.zip" -JobId "db5e719a-8db3-4fe5-9c78-7be479ce85a2"
        
        This will import a package into the 123456789 job through the DMF endpoint.
        It will use "c:\temp\d365fo.tools\dmfpackage.zip" as the location to read the file from.
        It will use "db5e719a-8db3-4fe5-9c78-7be479ce85a2" as the jobid parameter passed to the DMF endpoint.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Import-D365DmfPackage -Path "c:\temp\d365fo.tools\dmfpackage.zip" -JobId "db5e719a-8db3-4fe5-9c78-7be479ce85a2" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will import a package into the 123456789 job through the DMF endpoint.
        It will use "c:\temp\d365fo.tools\dmfpackage.zip" as the location to read the file from.
        It will use "db5e719a-8db3-4fe5-9c78-7be479ce85a2" as the jobid parameter passed to the DMF endpoint.
        It will use "e674da86-7ee5-40a7-b777-1111111111111" as the Azure Active Directory guid.
        It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the base D365FO environment url.
        It will use "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
        It will use "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.
        
    .LINK
        Add-D365ODataConfig
        
    .LINK
        Get-D365ActiveODataConfig
        
    .LINK
        Get-D365DmfMessageStatus
        
    .LINK
        Set-D365ActiveODataConfig
        
    .NOTES
        Tags: Import, Upload, DMF, Package, Packages, JobId
        
        Author: Mötz Jensen (@Splaxi)
#>

function Import-D365DmfPackage {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [String] $JobId,

        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [switch] $EnableException

    )

    begin {
        $bearerParms = @{
            Url          = $Url
            ClientId     = $ClientId
            ClientSecret = $ClientSecret
            Tenant       = $Tenant
        }

        $bearer = New-BearerToken @bearerParms
    }

    process {
        Invoke-TimeSignal -Start

        $dmfParms = @{
            JobId               = $JobId
            Url                 = $Url
            AuthenticationToken = $bearer
            Path                = $Path
        }

        $dmfDetails = Invoke-DmfEnqueuePackage @dmfParms -EnableException:$EnableException

        if ([string]::IsNullOrWhiteSpace($dmfDetails)) {
            Write-PSFMessage -Level Verbose -Message "Output object is null" -Target $Var
        }

        [PSCustomObject]@{
            MessageId = $dmfDetails.Replace('"', '')
        }
        
        Invoke-TimeSignal -End
    }
}