<#
.SYNOPSIS
Script to backup and then delete all signature files from the signatures folder used by Microsoft Outlook on Windows.
.DESCRIPTION
This script is designed to be deployed by Microsoft Endpoint Manager or by Group Policy to delete signature files from a machine for the logged in user.
.NOTES
Date: 23rd January 2023.
.PRODUCTS
Exclaimer - Signatures for Office 365.
.USAGE
Check that the variables $SignaturesFolder and $SignaturesBackupFolder are set to the best values for your organisation.
The backup of the signature files is optional can can be removed if desired.
#>
#Declaring Signatures folder location
$SignaturesFolder = "$env:APPDATA\Microsoft\Signatures"
#Declaring Signature backup folder location
$SignaturesBackupFolder = "$env:APPDATA\Microsoft\SignaturesBackup"
#Backup Existing signature files
If (! (Test-Path -path "$SignaturesBackupFolder")){
Copy-Item -Path "$SignaturesFolder" -Destination "$SignaturesBackupFolder" -Recurse
}
#Delete original signature files
Get-ChildItem -Path "$SignaturesFolder" -Include *.* -Recurse | foreach { $_.Delete()}

powershell.exe rmdir "$SignaturesFolder"