#Connect-AzureAD
#Connect-MSGraph
$IntuneGroupObjectID = "ced30773-300f-4ed5-9296-dbbfeef4bda0" #Object ID of the group in intune make sure to change this
$list = Import-Csv "C:\Users\mcredeu\OneDrive - Dairy Farmers of America, Inc\Documents\MC Script Library\AddToIntuneGroup\Adobe All Apps.csv" 
Foreach ($line in $list) {
$user = $line.Username
$email = $line.email #ensure you headers that are set to 
$count = 0


$clientId = "a92ae052-067a-4493-8618-c2751dbd1232"  
$clientSecret = "ht67Q~rWEvuXVBFGtBlask-vmP~tC6PKeIrC~"  
$tenantName = "dfamilk.com"  
$resource = "https://graph.microsoft.com/"  
$URL = "https://graph.microsoft.com/v1.0/users/$email"  
  
$tokenBody = @{  
    Grant_Type    = "client_credentials"  
    Scope         = "https://graph.microsoft.com/.default"  
    Client_Id     = $clientId  
    Client_Secret = $clientSecret  
}   
  

$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantName/oauth2/v2.0/token" -Method POST -Body $tokenBody  
$AzureUser = Invoke-RestMethod -Headers @{Authorization = "Bearer $($tokenResponse.access_token)"} -Uri $URL 


#Variables from user pull based on email
$UserDisplayname = $AzureUser.displayname
$upn = $AzureUser.userPrincipalName
$AzureUserID = $AzureUser.Id

#Variables for the associated user device
$Azuredevice = Get-AzureADUserRegisteredDevice -ObjectId $AzureUserID
$deviceCount = $device.Count

if ($deviceCount -gt 1) {

foreach ($device in $azureDevice) {
$deviceName = $device.displayname
Write-Output $deviceName
$AzureObjectID = $Device.ObjectID
$AzureDeviceID = $Device.DeviceID
$AzureDeviceName= $Device.Displayname
#Add-AzureADGroupMember -ObjectId $IntuneGroupObjectID -RefObjectId $AzureObjectID 

}
}
else {
    write-output $AzureDeviceName $AzureObjectID
    $AzureObjectID = $AzureDevice.ObjectID
    $AzureDeviceID = $AzureDevice.DeviceID
    $AzureDeviceName= $AzureDevice.Displayname
    #Add-AzureADGroupMember -ObjectId $IntuneGroupObjectID -RefObjectId $AzureObjectID 
    }




                        $newCSV = @()
                        $row = New-Object PSObject
                        $row | Add-Member -MemberType NoteProperty -Name "Display Name" -Value "$UserDisplayName"
                        $row | Add-Member -MemberType NoteProperty -Name "UPN" -Value "$UPN"
                        $row | Add-Member -MemberType NoteProperty -Name "Device" -Value "$AzureDeviceName"
                        $row | Add-Member -MemberType NoteProperty -Name "AzureUserID" -Value "$AzureUserID"
                        $row | Add-Member -MemberType NoteProperty -Name "AzureDeviceObjectID" -Value "$AzureObjectID"
                        $row | Add-Member -MemberType NoteProperty -Name "AzureDeviceID" -Value "$AzureDeviceID"
                                
                        $newCSV += $row 
                
                        #Export to CSV file
                        $newCSV | Export-Csv "c:\temp\Userdevicesadded.csv"  -NoTypeInformation -Append 


}



