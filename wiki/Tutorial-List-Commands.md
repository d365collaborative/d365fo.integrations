# **List available commands from d365fo.integrations module**

This tutorial will show you how to list and search for commands that are available from the d365fo.integrations module.

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
If you want to see the entire list of available commands from the d365fo.integrations, you can ask PowerShell to list them for you. Type the following command:

```
Get-Command -Module d365fo.integrations
```

[[images/tutorials/First-Time-List-Commands.gif]]


## **Search for commands**
If you want to search for command that contains a specific word or phrase, you can ask PowerShell to search for commands in the d365fo.integrations module. Type the following command:

```
Get-Command *dmf* -Module d365fo.integrations
```

[[images/tutorials/First-Time-Search-Commands.gif]]

## **Closing comments**
In this tutorial we showed you how to list all of the functions that is part of the d365fo.integrations. We also showed how you can search for a specific keyword and find all commands containing that keyword.