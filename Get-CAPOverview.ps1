<#
.SYNOPSIS
    Lists a quick overview of all Conditional Access Policies using the Graph API through Azure CLI.
	
.EXAMPLE
    PS C:\> .\Get-CAPOverview.ps1 | Export-Csv -Path "caps.csv" -NoTypeInformation
    Generates a CSV report of all CAPs.

.EXAMPLE
    PS C:\> .\Get-CAPOverview.ps1 | Where {$_.enabled} | format-table
    Displays all CAPs that are enabled, excluding off and report-only policies.
	
.NOTES
	Script created by @acap4z
	
	[Changelog]
	v1.0 (22/02/2023) - First version.
#>	

function getGrantType($cap){
    if(!($_.grantControls.authenticationStrength -eq $null)){
        return "MFA+"
    }elseif($_.grantControls.builtInControls -contains "mfa"){
        return "MFA"
    }elseif($_.grantControls.builtInControls -contains "block"){
        return "Block"
    }elseif($_.grantControls.builtInControls -eq $null){
        return "None"
    }else{
        return "Other"
    }    
}

function isScopedToAll($cap){
    if ($cap.conditions.users.includeUsers -eq "All"){
        return $true
    }else{
        return $false
    }
}

function hasUserExclusions($cap){
    if (getUserExclusions($cap).Count -eq 0 ){ 
        return $true
    }else {
        return $false
    }
}

function getUserExclusions($cap){
    $userScope = $cap.conditions.users.PSObject.properties
    $exclusions = @{}
    foreach ($property in $userScope){
        $exclusions[$property.Name] = $property.Value
    }
    return $exclusions
}

function isEnabled($cap){
    if ($cap.state -eq "enabled"){
        return $true;
    }else{
        return $false;
    }
}

function getConditions($cap){
    $conditions = @()
    # Check applications
    if(!($cap.conditions.applications.includeApplications -eq "All")){
        $conditions += "NotAllApps"
    }else{
        if(!($cap.conditions.applications.excludeApplications.Count -eq 0)){
            $conditions += "ExcludedApps"
        }
    }
    # Check if there are client apps
    if(!($cap.conditions.clientAppTypes -eq "all")){
        $conditions += "AppTypes"
    }
    # Check devices
     if(!($cap.conditions.devices -eq $null)){
        $conditions += "Devices"
    }   
    # Check locations
     if(!($cap.conditions.locations -eq $null)){
        $conditions += "Locations"
    }   
    # Check platforms
     if(!($cap.conditions.platforms -eq $null)){
        $conditions += "Platforms"
    }   
    # Check Sign-in Risk Levels
     if(!($cap.conditions.signInRiskLevels.Count -eq 0)){
        $conditions += "SignInRisk"
    }   
    # Check User Risk levels
     if(!($cap.conditions.userRiskLevels.Count -eq 0)){
        $conditions += "UserRisk"
    }  

    return $conditions

}

$all_caps = (az rest -u "https://graph.microsoft.com/beta/identity/conditionalAccess/policies" | convertfrom-json).value
if ($all_caps -eq $null){
    throw "You must call 'az login --allow-no-subscriptions' before running this script. This requires Azure CLI to be installed."
}

$all_caps | foreach-object{

    $grant = getGrantType($_)
    $scopedToAll = isScopedToAll($_)
    $hasExclusions = hasUserExclusions($_)
    $isEnabled = isEnabled($_)
    $conditions = getConditions($_)

    $cap = [ordered]@{
        "DisplayName" = $_.displayName
        "GrantType" = $grant
        "ScopedToAllUsers" = $scopedToAll
        "HasUserExclusions" = $hasExclusions
        "Conditions" = $conditions
        "Enabled" = $isEnabled
    }
	New-Object PSObject -Property $cap
}