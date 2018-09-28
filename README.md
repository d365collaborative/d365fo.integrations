# d365fo.integration
Powershell functions for integration with D365FO

Available on Powershellgallery
[d365fo.integrations](https://www.powershellgallery.com/packages/d365fo.integrations)

```
install-Module -Name d365fo.integrations
```

__List all available commands / functions__
```
Get-Command -Module d365fo.integrations
```
__Update the module__
```
Update-Module -name d365fo.integrations
```

_Before the communication works with D365FO, please remember to create the App registration in your Azure Active Directory and register the ClientId under Azure Active Directory Applications_

The module supports two types of integrations 
1. OData
2. DMF Recurring Data Jobs


_OData_

The OData functions are

1. Import-D365OData
2. Export-D365OData

_Recurring Data Jobs_

The Recurring Data Jobs functions are
1. Import-D365DMFPackage
2. Export-D365DMFPackage


_Misc_

*A function for restarting batch jobs.*
1. Set-D365RecurringBatchJobStartDate
For testing purposes, it is possible to do only monthly occurence and no enddate.
Execute the function will make D365FO to execute the batchjob
*A function for storing the must used properties for calling an integration, it can be persistet between sessions*
2. Set-D365AuthorityConfig
*A function for retrieving a stored config*
3. Get-D365AuthorityConfig