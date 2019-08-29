class windows_profile::domainjoin (
  $domain = "jsserv.local",
  $admin = 'admin@jsserv.local',
  $passw = 'Qu@lity!',
  $secure_password = false,
  $machine_ou = "OU=windows,OU=puppet,DC=jsserv,DC=local",
) {

#Set network default gateway to ip of the domain server first.
dsc_dnsserveraddress { 'dnsserveraddress':
    dsc_address        => $dnsserverip,
    dsc_interfacealias => 'Ethernet',
    dsc_addressfamily  => 'IPv4',
  }


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
