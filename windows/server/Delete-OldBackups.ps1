#Script to delete backup files older than 7 days

Get-ChildItem –Path "enterbackup path"| Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-7))} |Remove-Item  -Force -Recurse -Confirm: $false
