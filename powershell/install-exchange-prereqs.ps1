$ErrorActionPreference = "Stop"

# Install dependencies
Write-Host "Installing Windows features"
Install-WindowsFeature RSAT-Clustering-CmdInterface, NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS

# Install UCMA
Write-Host "Installing UCMA"
Invoke-WebRequest -Uri "https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe" -OutFile "$Env:Temp\ucma_setup.exe"

& "$Env:Temp\ucma_setup.exe" /q

# Install .NET 4.8
# https://www.reddit.com/r/PowerShell/comments/jsuxmg/installing_net_framework_48_as_a_feature/gc1qsqd/
Write-Host "Installing .NET 4.8"
Start-BitsTransfer -Source 'https://go.microsoft.com/fwlink/?linkid=2088631' -Destination "$Env:Temp\Net4.8.exe"
& "$Env:Temp\Net4.8.exe"

# Install Visual C++ 2013
Write-Host "Installing Visual C++ 2013"
Invoke-WebRequest -Uri "https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe" -OutFile "$Env:Temp\vcpp.exe"
& "$Env:Temp\vcpp.exe" /q

Write-Host "Please go through the graphical .NET installer and then reboot before continuing Exchange deployment"