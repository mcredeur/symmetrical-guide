Connect-AzureAD
Connect-MSGraph
$list = Import-Csv "C:\Users\mcredeu\OneDrive - Dairy Farmers of America, Inc\Documents\MC Script Library\Get-DeviceInfo\Intune - Testing - Personal Ownership_2022-7-13.csv"
#$count = 0
foreach ($line in $list) {
$hostname = $line.Displayname #change the device name to Displayname in the csv
#Graph API Calls
$clientId = "a92ae052-067a-4493-8618-c2751dbd1232"
$clientSecret = "ht67Q~rWEvuXVBFGtBlask-vmP~tC6PKeIrC~"
$tenantName = "dfamilk.com"
#$resource = "https://graph.microsoft.com/"
$tokenBody = @{
Grant_Type = "client_credentials"
Scope = "https://graph.microsoft.com/.default"
Client_Id = $clientId
Client_Secret = $clientSecret
}
#This invoke will give you a token that you can use for authorization throughout your script
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantName/oauth2/v2.0/token" -Method POST -Body $tokenBody

#This URL is your lookup query. You then create variables from the lookup.
$URL = "https://graph.microsoft.com/v1.0//deviceManagement/managedDevices?`$filter`=startsWith(devicename,'$hostname')"
$Device = Invoke-RestMethod -Headers @{Authorization = "Bearer $($tokenResponse.access_token)"} -Uri $URL


$Value = $device.Value
$DeviceId = $Value.id
$SerialNumber =$Value.serialNumber
$DeviceName = $Value.deviceName

$newCSV = @()
$row = New-Object PSObject
$row | Add-Member -MemberType NoteProperty -Name "SerialNumber" -Value "$SerialNumber"
$row | Add-Member -MemberType NoteProperty -Name "DeviceName" -Value "$DeviceName"

$newCSV += $row 
$newCSV | Export-Csv "C:\Users\mcredeu\OneDrive - Dairy Farmers of America, Inc\Documents\MC Script Library\Get-DeviceInfo\Intune - Testing - Personal Ownership_2022-7-13_CSREPORT.csv"  -NoTypeInformation -Append 
}


