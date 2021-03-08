# https://cloudblogs.microsoft.com/industry-blog/en-gb/technetuk/2016/06/08/setting-up-active-directory-via-powershell/

param  (
    [Parameter(Mandatory=$true)][string]$domain,
    [Parameter(Mandatory=$true)][System.Security.SecureString]$dsrm_password
)

$ErrorActionPreference = "Stop"

# Install AD DS
Write-Host "Installing Active Directory Domain Services"
Install-WindowsFeature AD-Domain-Services, RSAT-AD-Tools

# Create forest
Write-Host "Creating AD Forest"
Import-Module ADDSDeployment
Install-ADDSForest -DomainMode "WinThreshold" `
                   -ForestMode "WinThreshold" `
                   -SafeModeAdministratorPassword $dsrm_password `
                   -DomainName $domain `
                   -InstallDns:$True `
                   -Force:$True `
                   -NoRebootOnCompletion

Write-Host "Please reboot this machine!"