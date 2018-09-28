<#
.SYNOPSIS
Resets recurring data jobs, batchs jobs start date

.DESCRIPTION
Batch jobs used for the recurring datajobs, get a startdate in the past.
This triggers the batch to execute the job

.EXAMPLE
Set-RecurringBatchJobStartDate

.NOTES
General notes
#>
function Set-D365RecurringBatchJobStartDate() {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Name
    )
    
    $AOSPath = ""
    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $AOSPath = (Get-Website -Name "AOSService" | Select-Object -Property "PhysicalPath" ).physicalpath
    }
    else {
        $AOSPath = [System.Environment]::ExpandEnvironmentVariables("%ServiceDrive%") + "\AOSService\webroot"
    }

    add-Type -Path "$AOSPath\bin\Microsoft.Dynamics.ApplicationPlatform.Environment.dll"
      
    $environment = [Microsoft.Dynamics.ApplicationPlatform.Environment.EnvironmentFactory]::GetApplicationEnvironment()
    
    $dataAccess = $environment.DataAccess

    $DatabaseServer = $dataAccess.DbServer
    $DatabaseName = $dataAccess.Database
    $DatabaseUserName = $dataAccess.SqlUser
    [string]$DatabaseUserPassword = $dataAccess.SqlPwd
    
    if ($DatabaseUserPassword.Length -gt 128) {
        Stop-PSFFunction -Message "Function needs to be called as Administrator"
        return
    }

    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection


    $sqlConnection.ConnectionString = "Server=$DatabaseServer;Database=$DatabaseName;User=$DatabaseUserName;Password=$DatabaseUserPassword" 

    [System.Data.SqlClient.SqlCommand]  $sqlCommand = New-Object System.Data.SqlClient.SqlCommand
    $sqlCommand.Connection = $sqlConnection

    $sqlCommand.Connection.Open()
    $commandText = Get-Content "$script:PSModuleRoot\internal\sql\set-recurringbatchjobstartdate.sql" | out-string
    $sqlCommand.CommandText = $commandText
    $null = $sqlCommand.Parameters.AddWithValue("@Name", $Name)

    $reader = $sqlCommand.ExecuteReader()

    if ($reader.HasRows) {
        while ($reader.Read()) {
            Write-PSFMessage -Level Verbose -Message $("Batchjob updated '{0}'" -f $reader.GetString(0))
        }
    }
    
    Write-PSFMessage -Level Verbose -Message $("Number of batchjob updated '{0}'" -f $reader.RecordsAffected)

    $sqlCommand.Connection.Close()
    $sqlCommand.Dispose();
}

