# **Get D365FO OData entities**

This tutorial will show you how to list OData entities from a D365FO environment.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.integrations module installed
* A D365FO configuration that has been marked as active
  
Please visit the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Administrator) or the [Install as a Administrator](https://github.com/d365collaborative/d365fo.integrations/wiki/Tutorial-First-Time-Install-Non-Administrator) tutorials to learn how to install the tools.

## **Get all entities that contains 'Sales'**
If we want to list all the entities that contains the word 'Sales', we can query the D365FO environment for that information. Type the following command:

```
Get-D365ODataPublicEntity -EntityNameContains Sales
```

[[images/tutorials/Get-Public-OData-Entities-Contains-Full.gif]]


## **Get all entities that contains 'Sales' - output names only**
If we want to list the names of all the entities that contains the word 'Sales', we can query the D365FO environment for that information. Type the following command:

```
Get-D365ODataPublicEntity -EntityNameContains Sales -OutNamesOnly
```

[[images/tutorials/Get-Public-OData-Entities-Contains-NamesOnly.gif]]

## **Closing comments**
In this tutorial we showed you how you can query the D365FO environment and have it list OData entities. We showed how you can search for keywords across different names of the entities, to help you narrow down the list of entities you are getting back.