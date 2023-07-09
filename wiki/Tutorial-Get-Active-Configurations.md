# **Get active D365FO environment configuration**

This tutorial will show you how to list the current (if any) D365FO environment configuration.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.integrations module installed
  
Please visit the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Administrator) or the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Non-Administrator) tutorials to learn how to install the tools.

## **Get active configurations**
If we want to know more about which default values the module is currently using, we can query the module for its currently active configuration. Type the following command:

```
Get-D365ActiveODataConfig
```

[[images/tutorials/Get-Active-Config.gif]]

## **Closing comments**
In this tutorial we showed you how to get currently active configurations. You can use this to see if the details are correct while troubleshooting your work against the D365FO environment.