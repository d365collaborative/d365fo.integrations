# Authority configuration

## Setup
When doing integrations into D365FO a few basic things needs to be setup.

We need an Authority, ClientId and ClientSecret.

Microsoft have create a small guide on how to create the setup up.
This is located here : [install-configure-warehousing-app](https://docs.microsoft.com/en-us/dynamics365/unified-operations/supply-chain/warehousing/install-configure-warehousing-app)
Skip when reaching **Configure the application**

## Usage
All functions needs the parameters everytime.
To make this easy it is possible to persist the variable between sessions

Storing a Authority configuration is done like this
We also stores the url for the environment you need to call

```
# Old school multi line
Set-D365AuthorityConfig `
-D365FOUrl  "https://usnconeboxax1aos.cloud.onebox.dynamics.com" `
-Authority "https://sts.windows.net/yourdomain" `
-ClientId "YourClientId" `
-ClientSecret "YourClientSecret" `
-Persist `
-ConfigName "Config1"

# Hashtable parameters
$params = @{}
$params.D365FOUrl = "https://usnconeboxax1aos.cloud.onebox.dynamics.com"
$params.Authority = "https://sts.windows.net/yourdomain"
$params.ClientId = "YourClientId"
$params.ClientSecret = "YourClientSecret"
$params.ConfigName = "Config1"
Set-D365AuthorityConfig @params -Persist
```
Getting the configuration is done like this
```
$config = Get-D365AuthorityConfig -ConfigName "Config1"
```
Calling a method with the configuration stored in $config can be done like this
```
Import-D365DMFPackage @config -Entity "data/Titles"
```
