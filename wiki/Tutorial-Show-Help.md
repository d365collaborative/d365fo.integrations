# **Get help content for a command**

This tutorial will show you how to get the different kind of help content available for every command in the d365fo.integrations module.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.integrations module installed

Please visit the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Administrator) or the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Non-Administrator) tutorials to learn how to install the tools.

## **Start PowerShell**
Locate the PowerShell icon, if you don't have it on your desktop or in the task pane, we can locate it in the Windows Start Menu. Search for it or type PowerShell.

[[images/tutorials/First-Time-Start-PowerShell-Non-Administrator.gif]]

## **Import module**
You need to import / load the d365fo.integrations module into the current PowerShell console. Type the following command:

```
Import-Module -Name d365fo.integrations
```

[[images/tutorials/Import-Module-Administrator.gif]]

## **List all available commands**
For us to have something to work with, we need to get the list of available functions in the module. Type the following command:

```
Get-Command -Module d365fo.integrations
```

[[images/tutorials/First-Time-List-Commands.gif]]

## **Get help content for a specific function**
If you want to know more about a specific command, you can pass the name of the desired command to `Get-Help`. Type the following command:

```
Get-Help Get-D365ODataPublicEntity
```

[[images/tutorials/First-Time-Show-Help.gif]]

## **Get help content, including examples, for a specific function**
The help content for every function contains a high level explanation for each available parameter and examples. Type the following command:

```
Get-Help Get-D365ODataPublicEntity -Full
```

[[images/tutorials/First-Time-Show-Help-Full.gif]]

## **Get examples only, for a specific function**
The help content for every function contains at least 1 example on how run the function. Type the following command:

```
Get-Help Get-D365ODataPublicEntity -Examples
```

[[images/tutorials/First-Time-Show-Help-Examples-Only.gif]]


## **Closing comments**
In this tutorial we showed you how to list help content for a specific command, including the detailed parameter explanation and the examples.