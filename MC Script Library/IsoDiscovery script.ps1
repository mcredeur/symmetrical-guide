#Discovery script

$Path = "REGISTRY::HKCR\Windows.IsoFile\shell\mount"

# Check registry value and if key is detected delete it
Try {
    $Registry = Test-Path $Path
    If ($Registry -eq $true){
        Write-Warning "Not Compliant"
        Exit 1
    } Else {
     Write-Output "Compliant"
    Exit 0
 } 
}
Catch {
    Write-Warning "Not Compliant"
    Exit 1
} 