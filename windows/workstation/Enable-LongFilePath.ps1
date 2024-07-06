#Enables Long Paths in Windows

# Define the registry path and key
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
$registryKey = "LongPathsEnabled"

# Check if the registry key already exists
if (-not (Test-Path $registryPath)) {
    # Create the registry key if it doesn't exist
    New-Item -Path $registryPath -Force
}

# Set the LongPathsEnabled registry key value to 1
New-ItemProperty -Path $registryPath -Name $registryKey -Value 1 -PropertyType DWORD -Force

Write-Host "Long paths have been enabled in Windows."
