Write-Host "Performing the WinRM setup necessary to get the host ready for packer to run Chef..."

# parts of this are from https://github.com/luciusbono/Packer-Windows10/blob/master/configure-winrm.ps1
# and https://github.com/rgl/windows-2016-vagrant/blob/master/winrm.ps1

# Supress network location Prompt
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force

# Does a lot: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/enable-psremoting?view=powershell-6
Enable-PSRemoting -SkipNetworkProfileCheck -Force
Set-NetConnectionProfile -NetworkCategory Private

Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP" -RemoteAddress Any # allow winrm over public profile interfaces

winrm set "winrm/config" '@{MaxTimeoutms="1800000"}'
winrm set "winrm/config/winrs" '@{MaxMemoryPerShellMB="2048"}'
winrm set "winrm/config/service" '@{AllowUnencrypted="true"}'
winrm set "winrm/config/service/auth" '@{Basic="true"}'

#Set-NetConnectionProfile -NetworkCategory Public

Write-Host "Install Vbox Guest Additions..."
# There needs to be Oracle CA (Certificate Authority) certificates installed in order
# to prevent user intervention popups which will undermine a silent installation.
cd E:\cert
.\VBoxCertUtil.exe add-trusted-publisher vbox*.cer --root vbox*.cer
cd E:\
.\VBoxWindowsAdditions.exe /S

exit 0
