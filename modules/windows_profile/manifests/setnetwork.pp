Class windows_profile::setnetwork (

  $ipadd = $fact['networking']['interfaces']['Ethernet']['ip'],
  $defaultgateway = '192.168.0.1',
  $dnsadd = '127.0.0.1, 8.8.8.8',
  $dnsvalidate = true,
  $firewall = { firewall => [
              { firewall => 'domain',  set => false },
              { firewall => 'public',  set => false },
              { firewall => 'private', set => false }],
              }

) {

  dsc_ipaddress { 'setipaddress':
    dsc_addressfamily  => 'IPV4',
    dsc_interfacealias => 'Ethernet',
    dsc_ipaddress      => $ipadd,
  }

  dsc_defaultgatewayaddress {'setdefaultgateway':
    dsc_address        => $defaultgateway,
    dsc_interfacealias => 'Ethernet',
    dsc_addressfamily  => 'IPV4',
  }

  dsc_dnsserveraddress {'setdns':
    dsc_address        => $dnsadd,
    dsc_interfacealisa => 'Ethernet',
    dsc_addressfamily  => 'IPV4',
    dsc_validate       => $validate,
  }

  $firewall[firewall].each | $key | {
    dsc_firewallprofile {"${key[firewall]}":
      dsc_name    => "${key[firewall]}",
      dsc_enabled => "${key[set]}",
    }
  }

}
