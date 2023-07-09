# **Set active D365FO environment configuration**

This tutorial will show you how to add and store a configuration for a D365FO environment, so that you don't have to remember the different parameter values and don't need to copy and paste it all the time.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.integrations module installed
* Name of a previous created configuration
  
Please visit the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Administrator) or the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Non-Administrator) tutorials to learn how to install the tools.

## **Set active configuration - temporarily**
When working with configurations we can select a configuration and load that into memory. If we only want to do that for the current PowerShell session, we use the -Temporary parameter. This should be considered a safety mechanism. Type the following command:

```
Set-D365ActiveODataConfig -Name TEST -Temporary
```

[[images/tutorials/Set-Active-Config-Temporary.gif]]

## **Closing comments**
In this tutorial we showed you how to set a configuration for D365FO environment as the active one. This loads the different values into memory and the module will use these values as default for the different parameters across the different cmdlets in the module. Visit the **Tutorial** and **How-To** sections to see how to use the other cmdlets.