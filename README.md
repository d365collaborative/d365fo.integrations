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
Update-Module -name d365fo.tools
```


_Before the communication works with D365FO, please remember to create the App registration in your Azure Active Directory and register the ClientId under Azure Active Directory Applications_

The module is based upon json settings.

The module supports two functions, 
1. Rest
2. Recurring Data Jobs


_Rest_

The Rest functions are
1. Get-D365RestTemplate
2. Get-D365Rest
3. New-D365Rest

_Recurring Data Jobs_

The Recurring Data Jobs functions are
1. Get-D365IntegrationTemplate
2. New-D36Integration
3. Set-D365RecurringBatchJobStartDate

The functionality will be explained on the wiki pages
