param  (
    [Parameter(Mandatory=$true)][string]workspace_id,
    [Parameter(Mandatory=$true)][System.Security.SecureString]$workspace_key,
)

Write-Host "Installing Microsoft Monitoring Agent"
Start-BitsTransfer -Source "https://go.microsoft.com/fwlink/?LinkId=828603" -Destination "$Env:Temp\mma.exe"
& "$Env:Temp\mma.exe" /c "/t:$Env:Temp\mma_out\"
& "$Env:Temp\mma_out\setup.exe" /qn NOAPM=1 ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_AZURE_CLOUD_TYPE=0 OPINSIGHTS_WORKSPACE_ID="$workspace_id" OPINSIGHTS_WORKSPACE_KEY="$workspace_key" AcceptEndUserLicenseAgreement=1

# TODO: Sysmon

# TODO: Powershell logging