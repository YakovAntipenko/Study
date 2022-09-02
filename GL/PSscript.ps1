# First Machine
winrm set winrm/config/client '@{TrustedHosts = "20.238.4.213"}'
$username = 'adminuser'
$pass = ConvertTo-SecureString -string 'P@$$w0rd1234!' -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $pass
$s = New-PSSession -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck)

Invoke-Command -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred -ScriptBlock {Remove-WebAppPool -Name *}
Invoke-Command -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred -ScriptBlock {Remove-Website -Name *}
Invoke-Command -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred -ScriptBlock {Remove-Item -Recurse -Force  C:\inetpub\wwwroot\}
Invoke-Command -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred -ScriptBlock {New-Item -ItemType Directory -Force -Path "C:\inetpub\wwwroot\"}

Copy-Item -Path C:\Default.html -Destination 'C:\inetpub\wwwroot\Default.html' -ToSession $s
<# Enter-PSSession -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred #>
Invoke-Command -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred -ScriptBlock {New-WebAppPool -Name "MyWebsitePool"}
Invoke-Command -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred -ScriptBlock {New-IISSite -Name 'MyWebsite' -PhysicalPath 'C:\inetpub\wwwroot\' -BindingInformation "*:80:"}
Invoke-Command -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred -ScriptBlock {Import-Module WebAdministration; Set-ItemProperty 'IIS:\Sites\MyWebsite' applicationPool "MyWebsitePool"}
Invoke-Command -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred -ScriptBlock {Start-IISSite -Name 'MyWebsite'}
Invoke-Command -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred -ScriptBlock {Get-IISSite}

# Second Machine
winrm set winrm/config/client '@{TrustedHosts = "20.238.5.249"}'
$username = 'adminuser'
$pass = ConvertTo-SecureString -string 'P@$$w0rd1234!' -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $pass
$s = New-PSSession -ConnectionUri 'http://20.238.5.249:5985' -Credential $cred -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck)

Invoke-Command -ConnectionUri 'http://20.238.5.249:5985' -Credential $cred -ScriptBlock {Remove-WebAppPool -Name *}
Invoke-Command -ConnectionUri 'http://20.238.5.249:5985' -Credential $cred -ScriptBlock {Remove-Website -Name *}
Invoke-Command -ConnectionUri 'http://20.238.5.249:5985' -Credential $cred -ScriptBlock {Remove-Item -Recurse -Force  C:\inetpub\wwwroot\}
Invoke-Command -ConnectionUri 'http://20.238.5.249:5985' -Credential $cred -ScriptBlock {New-Item -ItemType Directory -Force -Path "C:\inetpub\wwwroot\"}

Copy-Item -Path C:\Default.html -Destination 'C:\inetpub\wwwroot\Default.html' -ToSession $s
<# Enter-PSSession -ConnectionUri 'http://20.238.4.213:5985' -Credential $cred #>
Invoke-Command -ConnectionUri 'http://20.238.5.249:5985' -Credential $cred -ScriptBlock {New-WebAppPool -Name "MyWebsitePool"}
Invoke-Command -ConnectionUri 'http://20.238.5.249:5985' -Credential $cred -ScriptBlock {New-IISSite -Name 'MyWebsite' -PhysicalPath 'C:\inetpub\wwwroot\' -BindingInformation "*:80:"}
Invoke-Command -ConnectionUri 'http://20.238.5.249:5985' -Credential $cred -ScriptBlock {Import-Module WebAdministration; Set-ItemProperty 'IIS:\Sites\MyWebsite' applicationPool "MyWebsitePool"}
Invoke-Command -ConnectionUri 'http://20.238.5.249:5985' -Credential $cred -ScriptBlock {Start-IISSite -Name 'MyWebsite'}
Invoke-Command -ConnectionUri 'http://20.238.5.249:5985' -Credential $cred -ScriptBlock {Get-IISSite}