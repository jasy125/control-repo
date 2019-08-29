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
