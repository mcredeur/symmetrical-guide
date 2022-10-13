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

function AssignGroupTag {
#Connect to Azure AD and MSGraph
Connect-AzureAD
Connect-MSGraph

#Import the .csv file
$list = Import-Csv "C:\Temp\HRKioskTest.csv"
$count = 0

#Loop through each line of the .csv file
    foreach ($line in $list) { 
    #Pull the data from the .csv and assign it to a variable
    $Device = $line.Device
    $DeviceID = $line.DeviceID
    $GroupTag = "HRKiosk"



    set-autopilotdevice -ID "$DeviceID" -groupTag "$GroupTag"
    $count = $count + 1
    Write-Output "$Device has been updated in Intune with GroupTag Name HRKiosk `n" | Green
    

#This is a standard .csv report to verify everything the script did.

    $newCSV = @()
$row = New-Object PSObject
$row | Add-Member -MemberType NoteProperty -Name "Device" -Value "$Device"
$row | Add-Member -MemberType NoteProperty -Name "DeviceID" -Value "$DeviceID"
$row | Add-Member -MemberType NoteProperty -Name "GroupTag" -Value "$GroupTag"



$newCSV += $row 
$newCSV | Export-Csv "C:\Temp\Report.csv"  -NoTypeInformation -Append 
}
}
#Call the function
AssignGroupTag