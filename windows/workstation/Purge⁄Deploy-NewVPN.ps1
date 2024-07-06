#Delete all VPN Connections and Deploy 1 VPN. Change Values as Required


# Get a list of all VPN connections
$vpnConnections = Get-VpnConnection

 

# Loop through and delete all VPN connections
foreach ($vpnConnection in $vpnConnections) {
    Write-Host "Deleting VPN connection $($vpnConnection.Name)..."
    Remove-VpnConnection -Name $vpnConnection.Name -Force -PassThru
    Write-Host "VPN connection $($vpnConnection.Name) has been deleted."
}

 

Add-VpnConnection -AllUserConnection -Name test-vpn -ServerAddress enterserveraddresshere -TunnelType SSTP -EncryptionLevel Optional -AuthenticationMethod PAP -UseWinlogonCredential  -RememberCredential -SplitTunneling -DnsSuffix enteryourdomain.local -Force
