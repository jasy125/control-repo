class windows_profile::dhcpserver(
  $startip = '192.168.0.1',
  $endip = '192.168.0.25',
  $scopename = '192.168.0.x',
  $subnetmask = '255.255.255.0',
  $leaseduration = '30',
  $state = 'active',
  $scopeid = '192.168.0.0',
  $dnsserverips = '10.234.1.209',
  $dnsdomain = 'jsserv.local',

){

/*
https://gallery.technet.microsoft.com/scriptcenter/xDhcpServer-PowerShell-f739cf90

*/
  dsc_windowsfeature {'installdhcp':
    dsc_ensure => 'Present',
    dsc_name   => 'DHCP',
  }

  dsc_windowsfeature {'installrsatdhcp':
    dsc_ensure => 'Present',
    dsc_name   => 'rsat-dhcp',
  }

  dsc_xdhcpserverauthorization {'dhcpauthorization':
    dsc_ensure => 'Present',
    dsc_ipaddress => '192.168.0.16',
  }

  exec {'dhcpauthor':
    command  => "Add-DhcpServerinDC",
    provider => powershell,
  }

  /* 
    add dhcp groups 
  */

  dsc_xgroup {'dhcpAdmins':
    dsc_groupname   => 'DHCP Administrators',
    dsc_ensure      => 'Present',
    dsc_description => 'Security group for DHCP Admins',

  }
  dsc_xgroup {'dhcpUsers':
    dsc_groupname => 'DHCP Users',
    dsc_ensure    => 'Present',
    dsc_description => 'DHCP Users',
  }

  /*
  Restart DHCP service
  */

  dsc_xdhcpserverscope { 'dhcpscope':
    dsc_ipstartrange  => $startip,
    dsc_ipendrange    => $endip,
    dsc_name          => $scopename,
    dsc_subnetmask    => $subnetmask,
    dsc_leaseduration => $leaseduration,
    dsc_state         => $state,
    dsc_ensure        => 'Present',
    dsc_addressfamily => 'IPv4',
    dsc_scopeid       => $scopeid,
    subscribe         => Dsc_xdhcpserverauthorization['dhcpauthorization'],
  }

dsc_xdhcpserveroptionvalue { 'dhcpserveroption':
  dsc_optionid      => $scopeid,
  dsc_value         => $startip,
  dsc_addressfamily => 'IPv4',
  dsc_ensure        => 'Present',
  dsc_vendorclass   => '',
  dsc_userclass     => '',
}

#Setting Scope Gateway
dsc_xdhcpscopeoptionvalue { 'dhcpOptionGateway':
  dsc_scopeid => $scopeid,
  dsc_optionid => '3',
  dsc_value => $dnsserverips,
  dsc_vendorclass =>'',
  dsc_userclass =>'',
  dsc_addressfamly => 'IPv4',
}

#Setting Scope DNS Server
dsc_xdhcpscopeoptionvalue { 'dhcpDNSServer':
  dsc_scopeid => $scopeid,
  dsc_optionid => '6',
  dsc_value => $dnsserverips,
  dsc_vendorclass =>'',
  dsc_userclass =>'',
  dsc_addressfamly => 'IPv4',
}

#Setting Scope DNS Domain Name
dsc_xdhcpscopeoptionvalue { 'dhcpDNSServerName':
  dsc_scopeid => $scopeid,
  dsc_optionid => '15',
  dsc_value => $dnsdomain,
  dsc_vendorclass =>'',
  dsc_userclass =>'',
  dsc_addressfamly => 'IPv4',
}

#xDhcpServerAuthorization - use exec to execute this on the domain controller ( Add-DhcpServerInDC -DnsName dc01.mikefrobbins.com) $compname and $currentIp should be auto found.
# invoke-command -ComputerName $dnsserverips -ScriptBlock { Add-DhcpServerInDC -DnsName $compname -IPAddress $currentIp}

  dnsname
  ipaddress

/*
dsc_xdhcpserverreservation { 'serverreservations':
  dsc_scopeid => $scopeid,
  dsc_ipaddress => 
  dsc_clientmacaddress =>
  dsc_name =>
  dsc_ensure =>
}
  */
}
