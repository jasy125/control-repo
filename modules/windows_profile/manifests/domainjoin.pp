class windows_profile::domainjoin (
  $domain = 'ad.jsserv.local',
  $admin = 'adjsservlocal\admin',
  $passw = 'Qu@lity!',
  $machine_ou = 'OU=Computers,DC=ad,DC=jsserv,DC=local',
) {

#Set Creds for creating the computer object
  $code = " \
  \$secStr=ConvertTo-SecureString '${passw}' -AsPlainText -Force; \
  if (-not \$?) { \
  write-error 'Error: Unable to convert password string to a secure string'; \
  exit 10; \
  } \
  \$creds=New-Object System.Management.Automation.PSCredential( '${admin}', \$secStr ); \
  if (-not \$?) { \
  write-error 'Error: Unable to create PSCredential object'; \
  exit 20; \
  } \
  Add-Computer -DomainName ${domain} -OUPath '${machine_ou}' -Restart -Force -Cred \$creds; \
  if (-not \$?) { \
  write-error 'Error: Unable to join domain'; \
  exit 30; \
  } \
  exit 0"

    
  exec { 'join_domain':
  command => $code,
  provider => powershell,
  logoutput => true,
  unless => "if ((Get-WMIObject Win32_ComputerSystem).Domain -ne '${domain}') { exit 1 }",
  }
}
