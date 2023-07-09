_This is based upon a Authority configuration is loaded into $Config_

On how to do this, please take a look at the Authority configuration page

_The module is allready installed and importet, if not you can do the following_
```
Install-Module -Name d365fo.integrations
Import-Module d365fo.integrations
```

1. Lets first find a Entity we can use 

```
$dataEntityJson = Export-D365OData @Config -Entity "data" `
| convertfrom-json $dataEntityJson.value `
| where-object name -like "*Title*"
```


| name |kind | url
|---- |  ---- | ---
Titles | EntitySet | Titles


2. Lets find it in the metadata and get the EntitySet

```
$metaData = Export-D365OData @Config -Entity 'data/$metadata'
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
'{ "@odata.type": "#Microsoft.Dynamics.DataEntities.Title","TitleId" : "Jedi Padawan"}' | Out-file C:\temp\jediPadawan.json
```


6. Lets create them.

```
New-D365Rest -Configuration $config -PayloadFiles @("data/Titles","C:\temp\jediPadawan.json","data/Titles","C:\temp\jediInitiate.json")
```


7. Lets take a look

```
$titles = Get-ODataEntity -Configuration $Config -ConfigurationType String -Entity "data/Titles" | ConvertFrom-Json
```


|TitleId
|-------
|Jedi Padawan
|Jedi Initiate
