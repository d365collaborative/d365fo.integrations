_This is based upon a Authority configuration is loaded into $Config_

On how to do this, please take a look at the Authority configuration page

_The module is allready installed and importet, if not you can do the following_
```
Install-Module -Name d365fo.integrations
Import-Module d365fo.integrations
```

Lets import some users

1. Create a Import job, goto  Modules > System Administration > Data Management > Import

ex:
[[images/UserImport.PNG]]
2. Create a Recurring Data Job
Save the ID, we need it when uploading a package
ex:
[[images/UserImportRecurring.png]]

3. Locate the data job, goto Workspaces > System Administration > Data Management > Data Management IT
[[images/UserImportRecurringInfo.png]]

4. Locate the job **ID**
[[images/UserImportRecurringDetails.png]]

Lets update a file to using powershell
```
Import-D365DMFPackage @config `
-JobId "{0643859C-D633-4B7A-B573-8220793CD34C}" `
-FileName "C:\Temp\UserExport.zip"
```
5. Lets take a look in D365FO to see uploaed and processed
[[images/UserImportRecurringDetails2.png]]


