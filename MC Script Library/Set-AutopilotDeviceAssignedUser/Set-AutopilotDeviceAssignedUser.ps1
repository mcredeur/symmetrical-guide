function Green
{
    process { Write-Host $_ -ForegroundColor Green }
}

function Red
{
    process { Write-Host $_ -ForegroundColor Red }
}

function Yellow
{
    process { Write-Host $_ -ForegroundColor Yellow }
}

function AssignUserAutopilotDevice {
#Connect to Azure AD and MSGraph
#Connect-AzureAD
#Connect-MSGraph

#Import the .csv file
$list = Import-Csv "C:\Temp\BevSo_assets_Wtags.csv"

$count = 0

Foreach ($item in $list) {
    #Pull Variables from CSV
    $User = $item.AssignedTo 
    $User = $User.trim()
    $AssetTag = $item.AssetTag
    $serialNumber = $item.SerialNumber

    Write-Output $User
    #Pull Azure AD Device ID
    $AutopilotDevice = Get-AzureADDevice -SearchString $serialNumber
    $DeviceID = $AutopilotDevice.ObjectID

    #Pull User UPN from their displayname
    $AzureADUser = Get-AzureADUser -Filter "startswith(DisplayName,'$user')"
    #$AzureADUser = Get-AzureADUser -SearchString $User
    $UPN = $AzureADUser.userPrincipalName
    if ($upn -match "EXT") {
        $arrUPN = $upn.split(" ")
        $UPN = $arrUPN[1]
        }


    #objectID of the Intune - Autopilot Deployment - Devices
    $ObjectID = "3d44a1ca-db10-41eb-99fe-5c9ac3dd1471" 

    #Add-AzureADGroupMember -InformationAction SilentlyContinue -ObjectId "$ObjectID" -RefObjectId "$DeviceID" 
    Set-AutoPilotDevice -id "$DeviceID" -userPrincipalName "$UPN" -addressableUserName "$User" -displayName "$User"
    

    $count = $count + 1
    Write-Output "$AssetTag has been assigned to $UPN in Intune `n" | Green
    Write-Output "$AssetTag has been added to Intune - AutoPilot - Devices group with Device ID $DeviceID `n" | Green

    #This is a standard .csv report to verify everything the script did
        $newCSV = @()
        $row = New-Object PSObject
        $row | Add-Member -MemberType NoteProperty -Name "UPN" -Value "$UPN"
        $row | Add-Member -MemberType NoteProperty -Name "AssignedTo" -Value "$User"
        $row | Add-Member -MemberType NoteProperty -Name "AssetTag" -Value "$AssetTag"
        $row | Add-Member -MemberType NoteProperty -Name "DeviceID" -Value "$DeviceID"
        $row | Add-Member -MemberType NoteProperty -Name "serialNumber" -Value "$serialNumber"
        $row | Add-Member -MemberType NoteProperty -Name "ObjectID" -Value "Intune - AutoPilot Deployment - Devices"
        

        $newCSV += $row
        $newCSV | Export-Csv "C:\Temp\BevSo_assets_Wtags_Report.csv" -NoTypeInformation -Append
        }
}

#Call the function
AssignUserAutopilotDevice