Connect-AzureAD
Connect-MSGraph
$IntuneGroupObjectID = "ced30773-300f-4ed5-9296-dbbfeef4bda0" #Object ID of the group in intune#
$list = Import-Csv "C:\Users\mcredeu\OneDrive - Dairy Farmers of America, Inc\Documents\MC Script Library\Get-DeviceInfo\Engagement_Survey_Devices.csv"
$count = 0
Foreach ($line in $list) {
$Hostname = $line.Device
$user = $line.User
$title = $line.Title


$clientId = "a92ae052-067a-4493-8618-c2751dbd1232"  
$clientSecret = "ht67Q~rWEvuXVBFGtBlask-vmP~tC6PKeIrC~"  
$tenantName = "dfamilk.com"  
$resource = "https://graph.microsoft.com/"  
$URL = "https://graph.microsoft.com/v1.0//deviceManagement/managedDevices?`$filter`=startsWith(devicename,'$hostname')"  # This should call the group name in the query. Calling top 100 groups for some reason.
  
  
$tokenBody = @{  
    Grant_Type    = "client_credentials"  
    Scope         = "https://graph.microsoft.com/.default"  
    Client_Id     = $clientId  
    Client_Secret = $clientSecret  
}   
  

$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantName/oauth2/v2.0/token" -Method POST -Body $tokenBody  
$Device = Invoke-RestMethod -Headers @{Authorization = "Bearer $($tokenResponse.access_token)"} -Uri $URL 



$Value = $device.Value
$DeviceId = $Value.id
$AzureDeviceID = $Value.azureADDeviceId
$DeviceName = $Value.DeviceName
$DeviceCount = $value.Count
$Serial = $value.SerialNumber
$user = $value.userDisplayName

$AzureDevice = Get-AzureADDevice -Filter "deviceId eq guid'$AzureDeviceID'" | select-object -Property *
$AzureObjectID = $AzureDevice.ObjectID
write-output $hostname $AzureObjectID

Add-AzureADGroupMember -ObjectId $IntuneGroupObjectID -RefObjectId $AzureObjectID 


                        $newCSV = @()
                        $row = New-Object PSObject
                        $row | Add-Member -MemberType NoteProperty -Name "Name" -Value "$User"
                        $row | Add-Member -MemberType NoteProperty -Name "Title" -Value "$Title"
                        $row | Add-Member -MemberType NoteProperty -Name "Device" -Value "$Hostname"
                                
                        $newCSV += $row 
                
                        #Export to CSV file
                        $newCSV | Export-Csv "c:\temp\EESKioskConfirmation.csv"  -NoTypeInformation -Append 


}

