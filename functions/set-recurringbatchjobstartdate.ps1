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
function Set-RecurringBatchJobStartDate()
{
    
    $AOSPath = ""
    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $AOSPath = (Get-Website -Name "AOSService" | Select-Object -Property "PhysicalPath" ).physicalpath
    }
    else {
        $AOSPath = [System.Environment]::ExpandEnvironmentVariables("%ServiceDrive%")  +  "\AOSService\webroot"
    }

    add-Type -Path "$AOSPath\bin\Microsoft.Dynamics.ApplicationPlatform.Environment.dll"
      
    $environment = [Microsoft.Dynamics.ApplicationPlatform.Environment.EnvironmentFactory]::GetApplicationEnvironment()
    
    $dataAccess = $environment.DataAccess

    $DatabaseServer = $dataAccess.DbServer
    $DatabaseName = $dataAccess.Database
    $DatabaseUserName = $dataAccess.SqlUser
    $DatabaseUserPassword = $dataAccess.SqlPwd



    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Server=$DatabaseServer;Database=$DatabaseName;User=$DatabaseUserName;Password=$DatabaseUserPassword"

    $sqlCommand = New-Object System.Data.SqlClient.SqlCommand
    $sqlCommand.Connection = $sqlConnection

    $sqlCommand.Connection.Open()
    $sqlCommand.CommandText = get-content "$script:PSModuleRoot\internal\sql\set-recurringbatchjobstartdate.sql"
    $sqlCommand.ExecuteScalar()
    $sqlCommand.Connection.Close()
    
}

