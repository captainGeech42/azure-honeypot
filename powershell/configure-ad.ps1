# Run this script after deploy-ad.ps1

$ErrorActionPreference = "Stop"

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