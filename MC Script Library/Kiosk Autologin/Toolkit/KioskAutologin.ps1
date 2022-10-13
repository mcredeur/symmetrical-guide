#This script creates a local Kioskuser account and then runs the Autologon64.exe to add that account to the autologin process. Either specify the file path to Autologon64 or make sure it is in the same dir as this script. K
$autologon = "Autologon64.exe"
$username = "KioskUser"
$domain = "local"
$password = "KioskUser@1"

$Localuseraccount = @{

    Name = 'KioskUser'

    Password = ("KioskUser@1" | ConvertTo-SecureString -AsPlainText -Force)
    AccountNeverExpires = $true
    PasswordNeverExpires = $true
    Verbose = $true
}
#Creates local account with a password that never expires
New-LocalUser @Localuseraccount
#Runs Autologin64.exe and sets the created account to be used for the autologin process.
Start-Process $autologon -ArgumentList $username,$domain,$password
