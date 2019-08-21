class windows_profile::domain (
  $user = 'admin',
  $passw = 'Qu@lity!',
  $dc = 'ad.jsserv.local',
  $dcdbpath = 'C:\NTDS',
  $dclogpath = 'c:\NTDS',

) {

/*
  $domaincontrollerfeatures = ['AD-Domain-Services','DNS']

  windowsfeature { $domaincontrollerfeatures:
    ensure => present,
    installmanagementtools => true,
  }
  */

  dsc_windowsfeature  { 'addsinstall':
            dsc_ensure => 'Present',
            dsc_name => 'AD-Domain-Services',

  }
  dsc_windowsfeature  {'addstools':
            dsc_ensure => 'Present',
            dsc_name => 'RSAT-ADDS',
  }
  dsc_windowsfeature  {'DNS':
            dsc_ensure => 'Present',
            dsc_name => 'DNS',
  }

  dsc_xaddomain   { 'primaryDC':
    subscribe      => Dsc_windowsfeature['addsinstall'],
    dsc_domainname => $dc,

    dsc_domainadministratorcredential => {
            'user'     => $user,
            'password' => Sensitive($passw)
    },

    dsc_safemodeadministratorpassword   => {
            'user'     => $user,
            'password' => Sensitive($passw)
    },

    dsc_databasepath => $dcdbpath,
    dsc_logpath => $dclogpath,
  }

  reboot {'dsc_reboot':
      message => 'DSC has requested a reboot',
      when => pending,
  }
}
