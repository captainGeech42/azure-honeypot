# Please run "install-exchange-prereqs.ps1" before this script

# https://www.itprotoday.com/email-and-calendaring/how-install-microsoft-exchange-server-2016-windows-server-2016-powershell

param  (
    [Parameter(Mandatory=$true)][string]$organization_name,
    [Parameter(Mandatory=$true)][string]$exchange_iso_full_path
)

$ErrorActionPreference = "Stop"

# Mount Exchange ISO
Write-Host "Mounting Exchange installation image"
$drive = (Mount-DiskImage -ImagePath $exchange_iso_full_path -Passthru | Get-Volume).DriveLetter

# Preparing AD
Write-Host "Preparing AD Schema"
& "${drive}:\Setup.exe" /PrepareSchema /IAcceptExchangeServerLicenseTerms

Write-Host "Preparing AD"
& "${drive}:\Setup.exe" /PrepareAD /OrganizationName:$organization_name /IAcceptExchangeServerLicenseTerms

# Install Mailbox server role
Write-Host "Installing Mailbox role (may take an hour or more)"
& "${drive}:\Setup.exe" /mode:Install /role:Mailbox /OrganizationName:$organization_name /IAcceptExchangeServerLicenseTerms /CustomerFeedbackEnabled:False