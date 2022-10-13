$application = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -match "cyber"}
$application.Uninstall()
