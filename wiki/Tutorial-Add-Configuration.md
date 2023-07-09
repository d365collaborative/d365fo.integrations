# **Add configuration for D365FO environment**

This tutorial will show you how to add and store a configuration for a D365FO environment, so that you don't have to remember the different parameter values and don't need to copy and paste it all the time.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.integrations module installed
* URL to the desired D365FO instance (NO TAILING SLASH!)
* ClientId of the Azure AD Registered Application
* ClientSecret of the Azure AD Registered Application
* Guid of the Azure AD tenant where the Registered Application is created

Please visit the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Administrator) or the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Non-Administrator) tutorials to learn how to install the tools.

**Note:** Please note that the D365FO instance has to be provision to the same Azure AD tenant as where the Registered Application is created.
## **Add configuration**
When we have the URL, ClientId, ClientSecret and Guid of the Azure AD tenant, we can save them, so we don't need to remember them. Type the following command:

```
Add-D365ODataConfig -Name TEST -Tenant 3718c2ef-850b-462a-93e9-58a26d54346e -url https://CUSTOMER.cloudax.dynamics.com -ClientId 60adecfa-99bc-47c7-b0cd-0ba61a91375f -ClientSecret du1234/mM4N7F1234Gf3TWp/1234jqn7RcbpG4C1234=
```

**Note:** It is possible to Copy & Paste the different values into the PowerShell console / window. One trick is using Alt+Tab to switch between your editor and the PowerShell console. Another trick is to only click on the top bar of the PowerShell console when you want to give it focus.

[[images/tutorials/Add-Config.gif]]

## **Closing comments**
In this tutorial we showed you how to add a configuration for D365FO environment. This enables the module to load the configuration into memory and use the values for the different parameters needed across the module. Visit the **Tutorial** and **How-To** sections to see how to use the configuration.