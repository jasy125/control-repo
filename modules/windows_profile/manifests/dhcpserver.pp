class windows_profile::dhcpserver(
  $startip = '192.168.0.1',
  $endip = '192.168.0.25',
  $scopename = 'jsnet',
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
  }



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
    subscribe         => dsc_xdhcpserverauthorization['dhcpauthorization'],
  }

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
