# d365fo.integration
Powershell functions for integration with D365FO

Available on Powershellgallery
[d365fo.integrations](https://www.powershellgallery.com/packages/d365fo.integrations)

```
install-Module -Name d365fo.integrations
```



*Before the communication works with D365FO, please remember to create the App registration in your Azure Active Directory and register the ClientId under Azure Active Directory Applications*

The module is based upon json settings.

Templates for the settings is avaliable through the following commands

**OData**

```
Get-OdataTemplate
```



**Recurring Data Jobs**

```
Get-IntegrationTemplate
```


## OData

### How to Get

*This is based upon the configuration file is loaded into a variable as a string called $Config*

1. Lets get the Data Entities

```
$dataEntity = Get-ODataEntity -Configuration $Config -Entity 'data'
```


2. Lets convert the result into a json object

```
$dataEntityJson = convertfrom-json $dataentity
```


3. Lets find some something regarding workers and sort the result

```
$dataEntityJson.value | where-object name -like '*Worker*' |Sort-Object -Descending -Property name
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
$worker = Get-ODataEntity -Configuration $Config -Entity "data/Workers?`$filter=PersonnelNumber eq '4711'" | ConvertFrom-Json`
```


1. Lets find his name, firstname and lastname

```
$worker.value | Select-Object -Property Name,FirstName,LastName
```


| Name | FirstName | LastName
|----|---------|--------
|D365 Integration|D365|Integration


### How to Post


1. Lets first find a Entity we can use 

```
$dataEntityJson = Get-ODataEntity -Configuration $Config -Entity "data" | convertfrom-json
$dataEntityJson.value | where-object name -like "*Title*"
```


| name |kind | url
|---- |  ---- | ---
Titles | EntitySet | Titles


2. Lets find it in the metadata and get the EntitySet

```
$metaData = Get-ODataEntity -Configuration $Config -Entity "data/$metadata"
$xml = New-Object -TypeName System.Xml.XmlDocument
$xml.LoadXml($metadata)
$man = New-Object -TypeName System.Xml.XmlNameSpaceManager($xml.NameTable)
$man.addNameSpace("edm","http://docs.oasis-open.org/odata/ns/edm")   
$xml.SelectSingleNode("//edm:EntitySet[@Name='Titles']",$man) | select-object EntityType
```


|EntityType|
|----|
|Microsoft.Dynamics.DataEntities.Title|

1. Finding the EntityType 

```
$xml.selectSingleNode("//edm:EntityType[@Name='Title']",$man)
```


4. Based on the EntityType the design of the json should look like, lets do a batch insert

5. Lets create 2 json files

```
'{ "@odata.type": "#Microsoft.Dynamics.DataEntities.Title","TitleId" : "Jedi Initiate"}' | Out-file C:\temp\jediInitiate.json 
```


```
'{ "@odata.type": "#Microsoft.Dynamics.DataEntities.Title","TitleId" : "Jedi Padawan"}' | Out-file C:\temp\jediPadawn.json
```


6. Lets create them.

```
New-ODataEntity -Configuration $config -PayloadFiles @("data/Titles","C:\temp\jediPadawan.json","data/Titles","C:\temp\jediInitiate.json")
```


7. Lets take a look

```
$titles = Get-ODataEntity -Configuration $Config -ConfigurationType String -Entity "data/Titles" | ConvertFrom-Json
```


|TitleId
|-------
|Jedi Padawan
|Jedi Initiate




