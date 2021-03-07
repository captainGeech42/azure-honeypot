# https://www.itprotoday.com/email-and-calendaring/how-install-microsoft-exchange-server-2016-windows-server-2016-powershell

param  (
    [Parameter(Mandatory=$true)][string]$organization_name
    [Parameter(Mandatory=$true)][string]$exchange_iso_full_path
)

# Install dependencies
Install-WindowsFeature RSAT-Clustering-CmdInterface, NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS

# Install UCMA
Write-Host "Downloading UCMA Installer, please wait (~250mb)"
Invoke-WebRequest -Uri "https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe" -OutFile "ucma_setup.exe"

# Mount Exchange ISO
$drive = (Mount-DiskImage -ImagePath $exchange_iso_path -Passthru | Get-Volume).DriveLetter

# Preparing AD
Write-Host "Preparing AD Schema"
iex "${drive}:\Setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms"

Write-Host "Preparing Active Directory"
iex "${drive}:\Setup.exe /PrepareAD /OrganizationName:${organization_name} /IAcceptExchangeServerLicenseTerms"

# Install Mailbox server role
Write-Host "Installing Mailbox server role"
iex "${drive}:\Setup.exe /mode:Install /role:Mailbox /OrganizationName:${organization_name} /IAcceptExchangeServerLicenseTerms /CustomerFeedbackEnabled:False"