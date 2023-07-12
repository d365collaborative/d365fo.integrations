# **d365fo.integrations**
Powershell module to assist with the different OData & DMF tasks during a Dynamics 365 Finace & Operations (D365FO) project.

Read more about D365FO on [docs.microsoft.com](https://docs.microsoft.com/en-us/dynamics365/unified-operations/fin-and-ops/index)

Available on Powershellgallery
[d365fo.integrations](https://www.powershellgallery.com/packages/d365fo.integrations)

The work with this module is a spin off from the work done with the somewhat more know community module, [d365fo.tools](https://github.com/d365collaborative/d365fo.tools).

## Table of contents
* [Getting started](#getting-started)
* [Getting help](#getting-help)
* [Contributing](#contributing)
* [Dependencies](#dependencies)

## **Getting started**
### **Install the latest module**
```
Install-Module -Name d365fo.integrations
```

### **Install without administrator privileges**
```
Install-Module -Name d365fo.integrations -Scope CurrentUser
```
### **List all available commands / functions**

```
Get-Command -Module d365fo.integrations
```

### **Update the module**

```
Update-Module -name d365fo.integrations
```

### **Update the module - force**

```
Update-Module -name d365fo.integrations -Force
```
## **Getting help**

Since the project started we have adopted and extended the comment based help inside each cmdlet / function.

**Getting help starts inside the PowerShell console**

Getting help is as easy as writing **Get-Help CommandName**

```
Get-Help Get-D365ODataEntityData
```

*This will display the available default help*

Getting the entire help is as easy as writing **Get-Help CommandName -Full**

```
Get-Help Get-D365ODataEntityData -Full
```

*This will display all available help content there is for the cmdlet / function*

Getting all the available examples for a given command is as easy as writing **Get-Help CommandName -Examples**

```
Get-Help Get-D365ODataEntityData -Examples
```

*This will display all the available **examples** for the cmdlet / function* 

We know that when you are learning about new stuff and just want to share your findings with your peers, working with help inside a PowerShell session isn't that great.

We have implemented **platyPS** (https://github.com/PowerShell/platyPS) to generate markdown files for each cmdlet / function available in the module. These files are hosted here on github for you to consume in your web browser and the give you the look and feel of other documentation sites.

The generated help markdown files are located inside the **'docs'** folder in this repository. Click this [link](https://github.com/d365collaborative/d365fo.integrations/tree/master/docs) to jump straight inside.

## Contributing

Want to contribute to the project? We'd love to have you! Visit our [contributing.md](https://github.com/d365collaborative/d365fo.integrations/blob/master/contributing.md) for a jump start.

## Dependencies

This module depends on other modules. The dependencies are documented in the [dependency graph](https://github.com/d365collaborative/d365fo.integrations/network/dependencies) and the Dependencies section of the Package Details of the [package listing](https://www.powershellgallery.com/packages/d365fo.integrations) in the PowerShell Gallery.