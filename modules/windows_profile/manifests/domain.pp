class windows_profile::domain (
  $user = 'Admin',
  $passw = 'Qu@lity!',
  $dc = 'jsserv.local',
  $dcnetbois = 'jsservlocal',
  $dclogpath = 'c:\NTDS',
  $forestmode = 'WinThreshold',
  $domainmode = 'WinThreshold',
  $domaincontainer = "dc=jsserv,dc=local",
  $oupathmaster = ['puppet','emea','amer','apac'],
  $oupathchild = { child => [
                  { ou => 'puppet', child =>'workstation'},
                  { ou => 'puppet', child=>'server'},
                  { ou => 'emea',   child =>'server'},
                  { ou => 'amer',   child =>'workstation'},
                  { ou => 'apac',   child => 'server'} ],
  }

) {
/*
   Install the Windows Features required for Domain Controller, AD Domain Services, AD Tools and DNS
*/
  dsc_windowsfeature { 'addsinstall':
            dsc_ensure => 'Present',
            dsc_name   => 'AD-Domain-Services',

  }
  dsc_windowsfeature {'addstools':
            dsc_ensure => 'Present',
            dsc_name   => 'RSAT-ADDS',
  }
  dsc_windowsfeature {'DNS':
            dsc_ensure => 'Present',
            dsc_name   => 'DNS',
  }

  /*
    Set the dns server address to be its loopback address
  */

  dsc_dnsserveraddress {'dnsserveraddress':
    dsc_address        => '127.0.0.1',
    dsc_interfacealias => 'Ethernet',
    dsc_addressfamily  => 'IPv4',
    subscribe          => Dsc_windowsfeature['DNS'],
  }

  /*
    Build the Primary DC and set the mode and paths etc
  */

  dsc_xaddomain { 'primaryDC':
    subscribe                         => Dsc_windowsfeature['addsinstall'],
    dsc_domainname                    => $dc,
    dsc_domainnetbiosname             => $dcnetbois,
    dsc_forestmode                    => $forestmode,
    dsc_domainmode                    => $domainmode,
    dsc_logpath                       => $dclogpath,

    dsc_domainadministratorcredential => {
            'user'     => $user,
            'password' => Sensitive($passw)
    },

    dsc_safemodeadministratorpassword => {
            'user'     => $user,
            'password' => Sensitive($passw)
    },
  }

  /*
    Wait for the DC Forest to be built and completed
  */

  dsc_xwaitforaddomain {'dscforestwait':
    dsc_domainname           => $dc,
    dsc_domainusercredential => {
            'user'     => $user,
            'password' => Sensitive($passw)
    },
    dsc_retrycount           => '5',
    dsc_retryintervalsec     => '60',
    dsc_rebootretrycount     => '2',
    subscribe                => Dsc_xaddomain['primaryDC'],
  }

  /*
    Make sure our user is a domain admin
  */
  dsc_xaduser {'adminUser':
    dsc_domainname           => $dc,
    dsc_username             => $user,
    dsc_userprincipalname    => "${user}@${dc}",
    dsc_password             => {
            'user'     => $user,
            'password' => Sensitive($passw)
    },
    dsc_passwordneverexpires => true,
    dsc_ensure               => 'Present',
    subscribe                => Dsc_xwaitforaddomain['dscforestwait'],
  }

/*
  dsc_xgroup { 'addAdmin' :
    dsc_groupname        => 'Domain Admins',
    dsc_memberstoinclude => "${user}@${dc}",
    dsc_ensure           => 'Present',
    dsc_credential       => {
            'user'     => $user,
            'password' => Sensitive($passw)
    },
    subscribe            => Dsc_xaduser['adminUser']
  }
*/
  # Investigate building this recursive structure

$oupathmaster.each | String $ou | {
  dsc_xadorganizationalunit  { "Create ${ou}":
      dsc_ensure                          => 'Present',
      dsc_name                            => $ou,
      dsc_path                            => $domaincontainer,
      dsc_description                     => "Top Level OU - ${ou}",
      dsc_protectedfromaccidentaldeletion => true,
      subscribe                           => Dsc_xaddomain['primaryDC'],
      dsc_credential                      => {
        'user'     => $user,
        'password' => Sensitive($passw)
      },
  }
}

$oupathchild[child].each | $key | {
  dsc_xadorganizationalunit  { "Create ${key[ou]}-${key[child]}":
      dsc_ensure                          => 'Present',
      dsc_name                            => "${key[child]}",
      dsc_path                            => "OU=${key[ou]},${domaincontainer}",
      dsc_description                     => "Top Level OU - ${key[child]}",
      dsc_protectedfromaccidentaldeletion => true,
      subscribe                           => Dsc_xadorganizationalunit["Create ${key[ou]}"],
      dsc_credential                      => {
        'user'     => $user,
        'password' => Sensitive($passw)
      },
  }
}
/*
 #Lets create the OU needed for the computers.
  dsc_xadorganizationalunit  {'CreateUKOU':
      dsc_ensure                          => 'Present',
      dsc_name                            => 'uk',
      dsc_path                            => $domaincontainer,
      dsc_description                     => 'Top Level OU',
      dsc_protectedfromaccidentaldeletion => true,
      subscribe                           => Dsc_xaddomain['primaryDC'],
      dsc_credential                      => {
        'user'     => $user,
        'password' => Sensitive($passw)
      },
  }

  dsc_xadorganizationalunit  {'CreateServersOU':
      dsc_ensure                          => 'Present',
      dsc_name                            => 'servers',
      dsc_path                            => "OU=UK,${domaincontainer}",
      dsc_protectedfromaccidentaldeletion => true,
      subscribe                           => Dsc_xadorganizationalunit['CreateUKOU'],
      dsc_credential                      => {
        'user'     => $user,
        'password' => Sensitive($passw)
      },

   xWaitForADDomain 'WaitForDomainInstall' {
      DomainName = $Node.DomainName;
      DomainUserCredential = $DomainCredential;
      RebootRetryCount = 2;
      RetryCount = 10;
      RetryIntervalSec = 60;
      DependsOn = '[xADDomain]ADDomainInstall';
    }

*/

  reboot {'dsc_reboot':
      message => 'DSC has requested a reboot',
      when => pending,
  }
}
