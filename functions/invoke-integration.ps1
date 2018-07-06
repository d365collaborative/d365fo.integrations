<#
.SYNOPSIS
A function used for export / import data from / into D365 using recurring datajobs

.DESCRIPTION
Long description

.PARAMETER Configuration
Parameter contains either a string containing json or a filename containing the configuration used for calling D365. 
Use Get-IntegrationTemplate to get the Format

.PARAMETER IntegrationType
ExhaustQueue will run 10 times where all jobs from the configuration failed
Normal will do a normal run, it will retry the download 5 times if a HTTP 500 is recieved upon the download

.EXAMPLE

Invoke-Integration "C:\temp\Integration.json"   -verbose



.NOTES
General notes
#>
function Invoke-Integration {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Configuration,
        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateSet('Normal', 'ExhaustQueue')]
        [string]$IntegrationType = 'Normal'
    )


    if (Test-Path $Configuration) {
        $config = Get-Content $Configuration | Out-String | ConvertFrom-Json -ErrorAction Stop
    }
    else {
        $config = $Configuration | ConvertFrom-Json -ErrorAction Stop
    }

    $d365FO = $Config.D365FO
    $authority = $Config.Authority
    $clientId = $Config.ClientId
    $clientSecret = $Config.ClientSecret
    $action = $Config.Action
    $jobs = $Config.Jobs
    $containerName = $Config.ContainerName


    if ($config.Storage -eq "azure") {
        import-module "azure.storage"
        
        $storageContext = new-AzureStorageContext -StorageAccountName $config.AccountId -StorageAccountKey $config.AccessToken

        if ($config.action -eq 'GET') {
            $newContainerName = "$containerName$(get-date -UFormat '%Y%m%d')"

            $container = get-AzureStorageContainer -name $newContainerName.toLower() -context $storageContext -ErrorAction SilentlyContinue

            if ($container -eq $null) {
                $container = New-AzureStorageContainer -name $newContainerName.ToLower() -context $storageContext 
            }
            else {
                $newContainerName = "$containerName$(get-date -UFormat '%Y%m%d%H%M%S')"
                $container = New-AzureStorageContainer -name $newContainerName.ToLower() -context $storageContext 
                
            }
            
        }
        else {
            $container = get-AzureStorageContainer -name $containerName.ToLower() -context $storageContext
        }
    }


    write-verbose "D365FO : $d365FO"
    write-verbose "authority : $authority"
    write-verbose "clientId : $clientId"
    write-verbose "clientSecret : $clientSecret"
    write-verbose "Action : $action"

    $null = add-type -path "$script:PSModuleRoot\internal\dll\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"

    $jobStatus = @()
    foreach ($job in $jobs) {
        add-member -InputObject $job -membertype noteproperty -name "Status" -value "Begin"
        add-member -InputObject $job -membertype  noteproperty -name "ErrorMessage" -value ""
        $jobStatus += $job
    }


    $exhaustRuns = 10
    do {

        foreach ($job in $jobStatus) {

            try {

                $jobId = $job.Job_Id
                $file = $job.FilePath

                Write-Verbose "job_id : $jobId"
                Write-Verbose "File :$file"

                if ($action -eq 'GET') {
                    Invoke-DequeueIntegration $config $job $storageContext $container
                }
                elseif ($action -eq 'POST') {
                    Invoke-EnqueueIntegration $config $job $storageContext $container
                }
                $job.Status = "Completed"
            }
            catch {
                write-Error $_.Exception.Message
                Write-Error $_.Exception
                Write-Error "Integration $jobId failed"
                $job.Status = 'Failed'
                $job.ErrorMessage = $_.Exception.Message
            }
            finally {
        
            }


        }
        $jobFailed = $false;
        $jobCompleted = $false;

        foreach ($job in $jobStatus) {
            if ($job.Status -eq "Failed") {
                $jobFailed = $true
            }
            if ($job.Status -eq "Completed") {
                $jobCompleted = $true
            }
        }
        if ($jobFailed -eq $true -and $jobCompleted -eq $false) {$exhaustRuns-- }


    } while ($IntegrationType -eq 'ExhaustQueue' -and $exhaustRuns -gt 0)

    foreach ($job in $jobStatus) {

        $jobId = $job.Job_Id
        $file = $job.FilePath
        $errmessage = $job.ErrorMessage
        

        if ($job.Status -eq "Failed") {
            Write-Host "JobId: $jobid,File : $file, Message : $errmessage" -ForegroundColor Red
        }
        else {
            Write-Host "JobId: $jobid,File : $file, Integration succesfully completed"  -ForegroundColor Yellow
        }


    }
}