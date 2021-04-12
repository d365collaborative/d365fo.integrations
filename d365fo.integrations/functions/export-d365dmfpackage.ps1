
<#
    .SYNOPSIS
        Export a DMF package from Dynamics 365 Finance & Operations
        
    .DESCRIPTION
        Exports a DMF package from the DMF endpoint of the Dynamics 365 Finance & Operations
        
    .PARAMETER Path
        Path where you want the cmdlet to save the exported file to
        
    .PARAMETER JobId
        JobId of the DMF job you want to export from
        
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
        PS C:\> Export-D365DmfPackage -Path "c:\temp\d365fo.tools\dmfpackage.zip" -JobId "db5e719a-8db3-4fe5-9c78-7be479ce85a2"
        
        This will export a package from the 123456789 job through the DMF endpoint.
        It will use "c:\temp\d365fo.tools\dmfpackage.zip" as the location to save the file.
        It will use "db5e719a-8db3-4fe5-9c78-7be479ce85a2" as the jobid parameter passed to the DMF endpoint.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Export-D365DmfPackage -Path "c:\temp\d365fo.tools\dmfpackage.zip" -JobId "db5e719a-8db3-4fe5-9c78-7be479ce85a2" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will export a package from the 123456789 job through the DMF endpoint.
        It will use "c:\temp\d365fo.tools\dmfpackage.zip" as the location to save the file.
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
        Set-D365ActiveODataConfig
        
    .NOTES
        Tags: Export, Download, DMF, Package, Packages, JobId
        
        Author: Mötz Jensen (@Splaxi)
#>

function Export-D365DmfPackage {
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory = $true)]
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
        }

        $dmfDetails = Get-DmfDequeuePackageDetails @dmfParms -EnableException:$EnableException
        
        if (Test-PSFFunctionInterrupt) { return }

        if ([string]::IsNullOrWhiteSpace($dmfDetails)) {
            $messageString = "There was no file ready to be downloaded."
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        $dmfDetailsJson = $dmfDetails | ConvertFrom-Json

        if ($VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue) {
            Write-PSFMessage -Level Verbose -Message "$dmfDetails" -Target $dmfDetailsJson
        }

        $dmfDetailsJson | Get-DmfFile -Path $Path -AuthenticationToken $bearer

        if (Test-PSFFunctionInterrupt) {
            Stop-PSFFunction -Message "Downloading the DMF Package file failed." -Exception $([System.Exception]::new("Unable to download the DMF package file."))
            return
        }

        Invoke-DmfAcknowledge -JsonMessage $dmfDetails @dmfParms
        
        if (Test-PSFFunctionInterrupt) {
            Stop-PSFFunction -Message "Acknowledgement of the DMF Package failed." -Exception $([System.Exception]::new("Unable to acknowledge the DMF package file."))
            return
        }

        Get-Item -Path $Path | Select-PSFObject "Name as Filename", @{Name = "Size"; Expression = {[PSFSize]$_.Length}}, "LastWriteTime as LastModified", "Fullname as File"

        Invoke-TimeSignal -End
    }
}