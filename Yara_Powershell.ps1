param (
    [string]$targetPath
)

# Set the path to the YARA executable
$yaraExe    = "C:\Windows\Temp\Yara\yara64.exe"

# Set the path to your YARA rules file
$rulesFile  = "C:\Windows\Temp\Yara\yara_rule.yar"

# Get last logged in User
$regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI'
$lastUser = (Get-ItemProperty -Path $regPath).LastLoggedOnUser -replace '.*\\', ''

# If $targetPath is empty, fallback to default path
if (-not $targetPath) {
    $targetPath = "C:\Users\$lastUser\Desktop"
}

# Get computer name and current date/time
$computerName = $env:COMPUTERNAME
$dateTime     = Get-Date -Format "dd_MM_yyyy_HH_mm"

# Define and ensure output folder
$outputDir  = "C:\Windows\Temp\Yara"
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory | Out-Null
}

# Build output .bat file path
$outputFileName = "Yara_${computerName}_${dateTime}.bat"
$outputFilePath = Join-Path -Path $outputDir -ChildPath $outputFileName

# Run YARA scan and collect output
Write-Host "Running YARA scan on: $targetPath"
$scanResults = & $yaraExe -r -g $rulesFile $targetPath 2>$null

# Write results to .bat file
foreach ($line in $scanResults) {
    'echo ' + $line | Out-File -FilePath $outputFilePath -Encoding ASCII -Append
}

# Summary
Write-Host "Scan complete. BAT file saved to: $outputFilePath"

# Cleanup - Delete all files except those containing the computer name
Write-Host "Cleaning up other files in $outputDir..."

Get-ChildItem -Path $outputDir -File | Where-Object {
    $_.Name -notmatch [regex]::Escape($computerName)
} | Remove-Item -Force

Write-Host "Cleanup complete. All files without '$computerName' in the name were deleted."





