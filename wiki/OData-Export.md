_This is based upon a Authority configuration is loaded into $Config_

On how to do this, please take a look at the Authority configuration page

_The module is allready installed and importet, if not you can do the following_
```
Install-Module -Name d365fo.integrations
Import-Module d365fo.integrations
```

1. Lets get the Data Entities

```
$dataEntity = Export-D365OData @Config -Entity 'data'
```


2. Lets convert the result into a json object

```
$dataEntityJson = convertfrom-json $dataentity
```


3. Lets find some something regarding workers and sort the result

```
$dataEntityJson.value `
| where-object name -like '*Worker*' `
| Sort-Object -Descending -Property name
```


Some of the entries returned :

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

```
$worker = Export-D365OData @Config `
-Entity "data/Workers?`$filter=PersonnelNumber eq '4711'" `
| ConvertFrom-Json`
```


1. Lets find his name, firstname and lastname

```
$worker.value | Select-Object -Property Name,FirstName,LastName
```


| Name | FirstName | LastName
|----|---------|--------
|D365 Integration|D365|Integration