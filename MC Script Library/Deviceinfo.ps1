$Username = "Get-WmiObject Win32_LoggedOnUser -ComputerName $Computer"
$Hostname = "hostname"
$SerialNumber = "wmic bios get serialnumber"

$Username
$Hostname
$SerialNumber

Read-host