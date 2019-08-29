class windows_profile::domainjoin (
  $domain = 'jsserv.local',
  $admin = 'admin@jsserv.local',
  $passw = 'Qu@lity!',
  $secure_password = false,
  $machine_ou = 'OU=server,OU=puppet,DC=jsserv,DC=local',
  $dnsserverip = '192.168.0.19',
  $compname = $facts['hostname'],
) {

#Set network default gateway to ip of the domain server first.
dsc_dnsserveraddress { 'dnsserveraddress':
    dsc_address        => $dnsserverip,
    dsc_interfacealias => 'Ethernet',
    dsc_addressfamily  => 'IPv4',
  }

/*
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
    Add-Computer -DomainName '${domain}' -OUPath '${machine_ou}' -Restart -Force -Cred \$creds; \
    if (-not \$?) { \
    write-error 'Error: Unable to join domain'; \
    exit 30; \
    } \
    exit 0"
    
  exec { 'join_domain':
    command => $code,
    provider => powershell,
    logoutput => true,
    unless => "if ((Get-WMIObject Win32_ComputerSystem).Domain -ne ${domain}) { exit 1 }",
  }
*/
  dsc_computer { 'joindomain':
    dsc_name        => $compname,
    dsc_domainname  => $domain,
    dsc_joinou      => $machine_ou,
    dsc_description => "Newly Joined ${compname}",
    dsc_credential  => {
      user     => $admin,
      password => Sensitive($passw)
    },
    subscribe       => Dsc_dnsserveraddress['dnsserveraddress'],
  }

  reboot {'dsc_reboot':
      message => 'DSC has requested a reboot',
      when    => pending,
  }
}
