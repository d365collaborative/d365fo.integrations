# **Get D365FO environment configurations**

This tutorial will show you how to list all stored configurations and there different values.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.integrations module installed
  
Please visit the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Administrator) or the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Non-Administrator) tutorials to learn how to install the tools.

## **Get all configurations**
When working with configurations we can select a configuration and load that into memory. If we only want to do that for the current PowerShell session, we use the -Temporary parameter. This should be considered a safety mechanism. Type the following command:

```
Get-D365ODataConfig
```

[[images/tutorials/Get-All-Configs.gif]]

## **Closing comments**
In this tutorial we showed you how to get all stored configurations. You can use this to see if you need to change a stored value, or use the name with the `Set-D365ActiveODataConfig` cmdlet.