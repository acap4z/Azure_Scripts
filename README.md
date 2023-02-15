# Azure_Scripts

## Get-AzureADPSPermissions_graph.ps1

Updated version of `Get-AzureADPSPermissions`, a script that was originally created by @psignoret using the now deprecated Azure AD module (https://gist.github.com/psignoret).

~~~
Get-Help .\Get-AzureADPSPermissions_graph.ps1 -detailed

SYNOPSIS
    Lists delegated permissions (OAuth2PermissionGrants) and application permissions (AppRoleAssignments).


SYNTAX
    C:\Users\Alberto\Desktop\Get-AzureADPSPermissions_graph.ps1 [-DelegatedPermissions] [-ApplicationPermissions] [[-UserProperties] <String[]>]
    [[-ServicePrincipalProperties] <String[]>] [-ShowProgress] [[-PrecacheSize] <Int32>] [<CommonParameters>]

PARAMETERS
    -DelegatedPermissions [<SwitchParameter>]
        If set, will return delegated permissions. If neither this switch nor the ApplicationPermissions switch is set,
        both application and delegated permissions will be returned.

    -ApplicationPermissions [<SwitchParameter>]
        If set, will return application permissions. If neither this switch nor the DelegatedPermissions switch is set,
        both application and delegated permissions will be returned.

    -UserProperties <String[]>
        The list of properties of user objects to include in the output. Defaults to DisplayName only.

    -ServicePrincipalProperties <String[]>
        The list of properties of service principals (i.e. apps) to include in the output. Defaults to DisplayName only.

    -ShowProgress [<SwitchParameter>]
        Whether or not to display a progress bar when retrieving application permissions (which could take some time).

    -PrecacheSize <Int32>
        The number of users to pre-load into a cache. For tenants with over a thousand users,
        increasing this may improve performance of the script.

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

    -------------------------- EXAMPLE 1 --------------------------

    PS C:\>.\Get-AzureADPSPermissions.ps1 | Export-Csv -Path "permissions.csv" -NoTypeInformation

    Generates a CSV report of all permissions granted to all apps.




    -------------------------- EXAMPLE 2 --------------------------

    PS C:\>.\Get-AzureADPSPermissions.ps1 -ApplicationPermissions -ShowProgress | Where-Object { $_.Permission -eq "Directory.Read.All" }

    Get all apps which have application permissions for Directory.Read.All.




    -------------------------- EXAMPLE 3 --------------------------

    PS C:\>.\Get-AzureADPSPermissions.ps1 -UserProperties @("DisplayName", "UserPrincipalName", "Mail") -ServicePrincipalProperties @("DisplayName",
    "AppId")

    Gets all permissions granted to all apps and includes additional properties for users and service principals.
~~~
