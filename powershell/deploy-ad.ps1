# https://cloudblogs.microsoft.com/industry-blog/en-gb/technetuk/2016/06/08/setting-up-active-directory-via-powershell/

param  (
    [Parameter(Mandatory=$true)][string]$domain,
    [Parameter(Mandatory=$true)][System.Security.SecureString]$dsrm_password
)

# Install AD DS
Install-WindowsFeature AD-Domain-Services, RSAT-AD-Tools

Import-Module ADDSDeployment

# Create forest
Install-ADDSForest -DomainMode "WinThreshold"
                   -ForestMode "WinThreshold"
                   -SafeModeAdministratorPassword $dsrm_password
                   -DomainName $domain
                   -InstallDns $True
                   -Force $True