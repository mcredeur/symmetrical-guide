#Check and create Kiosk User
$password = ConvertTo-SecureString -String "KioskUser@1" -AsPlainText -Force
$op = Get-LocalUser | Where-Object {$_.Name -eq "KioskUser01"}
if ( -not $op)
 {
  New-LocalUser KioskUser01 -Password $password | Out-Null
 }

# Enable Autologon
$RegistryPath = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion'
$Name         = 'AutoAdminLogon'
$Value        = '1'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType STRING -Force

#Enable KioskUser0
$RegistryPath = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion'
$Name         = 'DefaultUserName'
$Value        = 'KioskUser0'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType STRING -Force

# Set Default Password
$RegistryPath = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion'
$Name         = 'DefaultPassword'
$Value        = 'KioskUser@1'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType STRING -Force