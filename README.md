# d365fo.integration
Powershell functions for integration with D365FO

Available on Powershellgallery
[d365fo.integrations](https://www.powershellgallery.com/packages/d365fo.integrations)

`install-Module -Name d365fo.integrations`


*Before the communication works with D365FO, please remember to create the App registration in your Azure Active Directory and register the ClientId under Azure Active Directory Applications*

The module is based upon json settings.

Templates for the settings is avaliable through the following commands

**OData**

`Get-OdataTemplate`


**Recurring Data Jobs**

`Get-IntegrationTemplate`

## OData

### An Example

*This is based upon the configuration file is loaded into a variable as a string called $Config*

1. Lets get the Data Entities

`$dataEntity = Get-ODataEntity -Configuration $Config -ConfigurationType String -Entity 'data'`

2. Lets convert the result into a json object

`$dataEntityJson = convertfrom-json $dataentity`

3. Lets find some containing something regarding workers and sort the result

`$dataEntityJson.value | where-object name -like '*Worker*' |Sort-Object -Descending -Property name`

Some of the enties returned :

|name|kind|url|
|----|----|---|
WorkerTrustedPositions|EntitySet|WorkerTrustedPositions
WorkerTaxRegions|EntitySet|WorkerTaxRegions
WorkerTaxCodeParameters|EntitySet|WorkerTaxCodeParameters
WorkerTasks|EntitySet|WorkerTasks
WorkerSummaries|EntitySet|WorkerSummaries
WorkerSkills|EntitySet|WorkerSkills
Workers|EntitySet|Workers

4. Lets find a worker, lets take 4711, and just convert him to json rightaway

``$worker = Get-ODataEntity -Configuration $Config -ConfigurationType String -Entity "data/Workers?`$filter=PersonnelNumber eq '4711'" | ConvertFrom-Json`` 

5. Lets find his name, firstname and lastname
``$worker.value | Select-Object -Property Name,FirstName,LastName``

| Name | FirstName | LastName
|----|---------|--------
|D365 Integration|D365|Integration











