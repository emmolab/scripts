####
#Script to backup all sql db's on windows and auto prune backups older than 7 days


$Servers = @( , "enterhostnamehere" );
$Destination = "enterbackupdestinationhere";

####
$Timestamp = Get-Date -Format "dd-MM-yyyy HH-mm"

foreach ( $Server in $Servers ) {
    $Records = sqlcmd -E -S $Server -d "master" `
            -Q "SET NOCOUNT ON; SELECT DISTINCT( name ) FROM sys.databases WHERE name NOT IN ( 'master', 'msdb', 'model', 'tempdb' )" -h -1;
    foreach ( $DatabaseName in $Records ) {
        $DatabaseName = $DatabaseName.Trim();
        $DestinationFile = $( $Destination + "\" + $Server + "__" + $DatabaseName + "__" + $Timestamp + ".bak" );
        Write-Output $( "Creating backup of ``" + $DatabaseName + "`` to disk: ``" + $DestinationFile + "``...");
               sqlcmd -E -S $Server -d master `
                -Q $( "BACKUP DATABASE [" + $DatabaseName + "] TO DISK = N'" + $DestinationFile + "' " + `
                        "WITH INIT, NOUNLOAD, NAME = N'" + $DatabaseName + " backup', NOSKIP, NOFORMAT");
        Write-Output "...done!";
    };
};

#delete files that are 7 days old
Get-ChildItem "enterbackupdestinationhere" | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-7))} | Remove-Item


