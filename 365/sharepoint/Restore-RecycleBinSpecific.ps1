#Bulk Restore Contents from SP Recycle Bin, Requires PnPOnline Module

# SharePoint site URL:
$spUrl = "https://spsiteurlhere"

# Connect to SharePoint
Connect-PnPOnline -Url $spUrl -Interactive 

# Set the restore date to x days in the past
$today = (Get-Date) 
$dateFrom = $today.date.addDays(-11)
$dateTo = $today.date.addDays(1)

# Set user to find files from
$deletedByUser = "user@example.com"

# Show dates
write-host "Finding files from $dateFrom to $dateTo" -ForegroundColor Cyan

# Get all items that are deleted x days ago, select the last 10 items and display a list with all properties
Get-PnPRecycleBinItem | Where-Object {($_.DeletedDate -gt $dateFrom -and $_.DeletedDate -lt $dateTo) -and ($_.DeletedByEmail -eq $deletedByUser)}  | Select-Object -last 10 | ft *

# Confirm test results
$confirmation = Read-Host "Are the result as aspected? [y/n]"
if ($confirmation -eq 'y') {
  # Proceed
  Write-Host "Restoring items" -ForegroundColor Cyan

  Get-PnPRecycleBinItem -firststage | 
    Where-Object {($_.DeletedDate -gt $dateFrom -and $_.DeletedDate -lt $dateTo) -and ($_.DeletedByEmail -eq $deletedByUser)} | 
    Restore-PnpRecycleBinItem -Force

  Write-Host "Restore completed" -ForegroundColor Green
}
