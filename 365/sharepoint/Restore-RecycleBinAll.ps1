#Ensure Powershell 7 is installed and Pnp Online Module has been installed
#Connect-PnPOnline -url https://mysharepointsite/site/si1 -Interactive
#cd to the directory you downloaded the script eg cd \Downloads
#run the script via .\restore-recycle.ps1


# =================================================================== #
#         Load SharePoint PnP PowerShell Module
# =================================================================== #

$ErrorActionPreference = 'Stop'

# =================================================================== #
#            RESTORE RECYCLE BIN IN BATCHES USING REST API
# =================================================================== #
$firstLevelItems = @(Get-PnPRecycleBinItem -FirstStage -RowLimit 99999999)
$secondLevelItems = @(Get-PnPRecycleBinItem -SecondStage -RowLimit 99999999)

Write-Host "First Stage Recycle Bin Items: $($firstLevelItems.Count)" -ForegroundColor Cyan
Write-Host "Second Stage Recycle Bin Items: $($secondLevelItems.Count)" -ForegroundColor Yellow

$restoreSet = $firstLevelItems + $secondLevelItems
Write-Host "Both Stages Recycle Bin Items: $($restoreSet.Count)" -ForegroundColor Cyan

$restoreFileSorted = $restoreSet | Where-Object { $_.ItemType -eq "File" } | Sort-Object DirName, LeafName
Write-Host "Both Stages Recycle Bin, Documents count: $($restoreFileSorted.Count)" -ForegroundColor Yellow

function Restore-RecycleBinItem {
    param(
        [Parameter(Mandatory)]
        [String]
        $Ids
    )
    
    $siteUrl = (Get-PnPSite).Url
    $apiCall = "$siteUrl/_api/site/RecycleBin/RestoreByIds"
    $body = "{""ids"":[$Ids]}"   
    
    try {
        Invoke-PnPSPRestMethod -Method Post -Url $apiCall -Content $body -ErrorAction Stop
    }
    catch {
        Write-Host "Error restoring items: $($_.Exception.Message)"
        # Handle the error as needed
        # For example, skip the item if it cannot be restored
        return
    }
}

$restoreList = $restoreFileSorted | Select-Object Id, ItemType, LeafName, DirName

$restoreListCount = $restoreList.Count
$start = 0
$leftToProcess = $restoreListCount - $start

$stopWatch = [System.Diagnostics.Stopwatch]::StartNew()

# Batch restore up to 200 at a time
while ($leftToProcess -gt 0) {
    $numToProcess = if ($leftToProcess -lt 200) { $leftToProcess } else { 200 }

    Write-Host -ForegroundColor Yellow "Building statement to restore the following $numToProcess files"
    $Ids = @()

    for ($i = 0; $i -lt $numToProcess; $i++) {
        $cur = $start + $i
        $curItem = $restoreList[$cur]
        
        $Ids += $curItem.Id
    }

    Write-Host -ForegroundColor Yellow "Performing API Call to Restore items from RecycleBin..."
    $Ids_As_string = [System.String]::Join(",", $($Ids | ForEach-Object { '"{0}"' -f $_ }))
    
    Restore-RecycleBinItem -Ids $Ids_As_string

    $start += 200
    $leftToProcess = $restoreListCount - $start
}

$stopWatch.Stop()
Write-Host "Time it took to restore $restoreListCount documents from the $($SiteURL) : $($stopWatch.Elapsed.ToString())" -ForegroundColor Cyan
