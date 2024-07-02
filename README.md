# Azure_Scripts

## Get-AzureADPSPermissions_graph.ps1

Updated version of `Get-AzureADPSPermissions` that uses the Graph Powershell SDK cmdlets. This script was originally created by @psignoret (https://gist.github.com/psignoret), which uses the old Azure AD Powershell modules.

### Syntax
~~~
Get-AzureADPSPermissions_graph.ps1 [-DelegatedPermissions] [-ApplicationPermissions] [[-UserProperties] <String[]>]
    [[-ServicePrincipalProperties] <String[]>] [-ShowProgress] [[-PrecacheSize] <Int32>] [<CommonParameters>]
~~~

### Example
Generates a CSV report of all permissions granted to non-Microsoft enterprise apps.
~~~
.\Get-AzureADPSPermissions_graph.ps1 | Export-Csv -Path "permissions.csv" -NoTypeInformation
~~~

### More help
~~~
Get-Help .\Get-AzureADPSPermissions_graph.ps1 -detailed
~~~

## Get-CAPOverview.ps1

Lists a quick overview of all Conditional Access Policies using the Graph API through Azure CLI.

### Example
Display all CAPs that are enabled, excluding off and report-only policies, in a table format.
~~~
.\Get-CAPOverview.ps1 | Where {$_.enabled} | format-table
~~~

## Get-EntepriseAppsPermissions_api.ps1

Script that lists delegated and application permissions for every Enterprise App that is not a Microsoft application using the Graph API through Azure CLI.

### Example
Lists delegated and application permissions for every Enterprise App.
~~~
.\Get-EntepriseAppsPermissions_api.ps1 | Export-Csv -Path "permissions.csv" -NoTypeInformation
~~~

### More help
~~~
Get-Help .\Get-EntepriseAppsPermissions_api.ps1 -examples
~~~
