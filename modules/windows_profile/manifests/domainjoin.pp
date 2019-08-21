class windows_profile::domainjoin (
  $domain = 'ad.jsserv.local',
  $admin = 'admin',
  $passw = 'Qu@lity!',
  $machine_ou = 'OU=Computers,DC=ad,DC=jsserv,DC=local',
) {

    #Set Creds for creating the computer object
    $creds = "\$pscreds = New-Object System.Management.Automation.PSCredential( '${admin}', '${passw}' ); \
     Add-Computer -DomainName ${domain} -OUPath ${machine_ou} -Restart -Force -Cred ${pscreds};"

  exec { 'join_domain':

  command => $creds,
  provider => powershell,
  logoutput => true,
  unless => "if ((Get-WMIObject Win32_ComputerSystem).Domain -ne '${domain}') { exit 1 }",
  }

}
