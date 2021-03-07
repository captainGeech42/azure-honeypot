# https://cloudblogs.microsoft.com/industry-blog/en-gb/technetuk/2016/06/08/setting-up-active-directory-via-powershell/

param  (
    [Parameter(Mandatory=$true)][string]$domain,
    [Parameter(Mandatory=$true)][System.Security.SecureString]$dsrm_password
)

workflow Install-AD {
    param  (
        [Parameter(Mandatory=$true)][string]$domain,
        [Parameter(Mandatory=$true)][System.Security.SecureString]$dsrm_password
    )

    $ErrorActionPreference = "Stop"

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
                       -NoRebootOnCompletion

    Write-Host "Rebooting"
    Restart-Computer -Wait

    Import-Module ActiveDirectory

    # Configure password policy
    $domain = Get-ADDomain
    Set-ADDefaultDomainPasswordPolicy -Identity $domain
                                      -ComplexityEnabled $True
                                      -ReversibleEncryptionEnabled $False
                                      -MinPasswordAge 1.0:0:0.0
                                      -MaxPasswordAge 365.0:0:0.0

    # Get names
    $user_data = (Invoke-RestMethod -Uri "https://randomuser.me/api/?results=48&password=upper,lower,special,14-20&nat=us").results

    # Make users
    $user_data | %{
        # Make sure there are no invalid characters in the name
        $name = "$($_.name.first).$($_.name.last)".ToLower()
        if ($name.contains("'")) {
            continue
        }

        $pw = ConvertTo-SecureString -AsPlainText $_.login.password -Force

        $user = New-ADUser -Enabled $True
                           -Name $name
                           -GivenName $_.name.first
                           -Surname $_.name.last
                           -AccountPassword $pw
    }
}

Install-AD -domain $domain -dsrm_password $dsrm_password