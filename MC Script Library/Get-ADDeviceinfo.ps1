#Connect-AzureAD
#Connect-MSGraph
$list = Import-csv "C:\Temp\Intune - Testing - Personal Ownership_2022-7-13.csv"
#$count = 0
foreach ($line in $list) {
$hostname = $line.Displayname #change the device name to Displayname in the csv
$Deviceinfo = Get-ADComputer -Filter 'Name -eq $hostname' -Properties *

$DistinguishedName = $deviceinfo.DistinguishedName  
$Location = $Deviceinfo.Location  
$whenChanged = $Deviceinfo.whenChanged
$whenCreated = $Deviceinfo.whenCreated
$Description = $Deviceinfo.Description 
$OperatingSystem = $Deviceinfo.OperatingSystem


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

#Values pulled from Azure AD
$Value = $device.Value
$DeviceId = $Value.id
$SerialNumber =$Value.serialNumber
$DeviceName = $Value.deviceName

#need to investigate why below wont work pretty sure I don't have the object ID
#$DeviceOwner = Get-AzureADDeviceRegisteredOwner -ObjectId $DeviceId


$newCSV = @()
$row = New-Object PSObject
$row | Add-Member -MemberType NoteProperty -Name "Hostname" -Value "$Hostname"
$row | Add-Member -MemberType NoteProperty -Name "DeviceOwner" -Value "$DeviceOwner"
$row | Add-Member -MemberType NoteProperty -Name "DistinguishedName" -Value "$DistinguishedName"
$row | Add-Member -MemberType NoteProperty -Name "AADSerial" -Value "$SerialNumber"
$row | Add-Member -MemberType NoteProperty -Name "AADDeviceName" -Value "$DeviceName"
$row | Add-Member -MemberType NoteProperty -Name "whenChanged" -Value "$whenChanged"
$row | Add-Member -MemberType NoteProperty -Name "whenCreated" -Value "$whenCreated"
$row | Add-Member -MemberType NoteProperty -Name "Description" -Value "$Description"
$row | Add-Member -MemberType NoteProperty -Name "OperatingSystem" -Value "$OperatingSystem"

$newCSV += $row 
$newCSV | Export-Csv "C:\Temp\ADDeviceinfo\Intune - Testing - Personal Ownership_2022-7-13_CSREPORT.csv"  -NoTypeInformation -Append 
}

