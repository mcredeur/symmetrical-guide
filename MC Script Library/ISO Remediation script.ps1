#Remediation script

$Path = "REGISTRY::HKCR\Windows.IsoFile\shell\mount"

Remove-item -path $path -Recurse