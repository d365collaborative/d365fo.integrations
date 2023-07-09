_This is based upon a Authority configuration is loaded into $Config_

On how to do this, please take a look at the Authority configuration page

_The module is allready installed and importet, if not you can do the following_
```
Install-Module -Name d365fo.integrations
Import-Module d365fo.integrations
```

Before there is something to Export, D365FO needs to generate something first

Lets export some users

1. Create a Export job, goto  Modules > System Administration > Data Management > Export

ex:
[[images/UserExport.png]]
2. Create a Recurring Data Job
Save the ID, we need it when requesting a package
ex:
[[images/UserExportRecurring.png]]

3. Locate the data job, goto Workspaces > System Administration > Data Management > Data Management IT
[[images/UserExportRecurringInfo.png]]

4. Locate the data job, goto Workspaces > System Administration > Data Management > Data Management IT
[[images/UserExportRecurringDetails.png]]

Lets download it using powershell
```
Export-D365DMFPackage @config `
-JobId "{09767400-4C9B-4D35-A0C1-B90240908933}" `
-FileName "C:\Temp\UserExport.zip"
```
5. Lets take a look in D365FO to see it was ack'ed
[[images/UserExportRecurringDetails2.png]]


