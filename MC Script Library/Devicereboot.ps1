#Connect-AzureAD 
#Connect-MSGraph
$list = Import-Csv "C:\Users\Melanie\OneDrive - Dairy Farmers of America, Inc\Documents\MC Script Library\RebootNow\Intune - Dynamic DBHRkiosk Deployment - Devices_2022-7-31.csv"
#$count = 0
foreach ($line in $list) {
$hostname = $line.Hostname
$DeviceId = $line.id
$DeviceName = $line.displayName
#Graph API Calls
$clientId = "a92ae052-067a-4493-8618-c2751dbd1232"  
$clientSecret = "ht67Q~rWEvuXVBFGtBlask-vmP~tC6PKeIrC~"  
$tenantName = "dfamilk.com"  
#$resource = "https://graph.microsoft.com/"  
   
$tokenBody = @{  
    Grant_Type    = "client_credentials"  
    Scope         = "https://graph.microsoft.com/.default"  
    Client_Id     = $clientId  
    Client_Secret = $clientSecret  
} 
#This invoke will give you a token that you can use for authorization throughout your script
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantName/oauth2/v2.0/token" -Method POST -Body $tokenBody  

#This URL is your lookup query. You then create variables from the lookup.  
#$URL = "https://graph.microsoft.com/v1.0//deviceManagement/managedDevices?`$filter`=startsWith(devicename,'$hostname')" 
#$Device = Invoke-RestMethod -Headers @{Authorization = "Bearer $($tokenResponse.access_token)"} -Uri $URL 

#$Value = $device.Value

#$AzureADdevice = Get-AzureADDevice -SearchString $deviceName
#$AzureObjectID = $AzureADdevice.objectID
#$Serial = $value.SerialNumber

#$APDevice = Get-AutopilotDevice | Where-Object serialNumber -eq "$Serial" 
#$APDeviceID = $APDevice.ID


#In our use, we want to reboot the device.

    $rebootURL = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/$DeviceID/rebootNow" 
    Invoke-RestMethod -Headers @{Authorization = "Bearer $($tokenResponse.access_token)"} -Uri $rebootURL -body $WipeBody -Method POST -ContentType "application/json"

Write-Output  $DeviceName $deviceID
}