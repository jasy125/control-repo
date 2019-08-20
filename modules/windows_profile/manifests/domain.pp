class windows_profile::domain {

  $domaincontrollerfeatures = ['AD-Domain-Services','DNS']

  windowsfeature { $domaincontrollerfeatures:
    ensure => present,
    installmanagementtools => true,
  }

  /*
  dsc_windowsfeature  { 'addsinstall':
            dsc_ensure => 'Present',
            dsc_name => 'AD-Domain-Services',
 
        }
dsc_windowsfeature  {'addstools':
            dsc_ensure => 'Present',
            dsc_name => 'RSAT-ADDS',
        }
  
  */

  dsc_xaddomain   { 'primaryDC':
    subscribe => Dsc_windowsfeature['addsinstall'],
            dsc_domainname => 'ad.jsserv.local',
    dsc_domainadministratorcredential => {
              'user' => 'jsadmin',
              'password' => Sensitive('Puppetlabs')
    },
    dsc_safemodeadministratorpassword   => {
            'user' => 'jsadmin',
              'password' => Sensitive('Puppetlabs')
    },
      dsc_databasepath => 'c:\NTDS',
      dsc_logpath => 'c:\NTDS',
  }

  reboot {'dsc_reboot':
      message => 'DSC has requested a reboot',
      when => pending,
  }
}
