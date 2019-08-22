class windows_profile::domain (
  $user = 'admin',
  $passw = 'Qu@lity!',
  $dc = 'jsserv.local',
  $dcnetbois = 'jsservlocal',
  $dcdbpath = 'c:\NTDS',
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
  $domaincontrollerfeatures = ['AD-Domain-Services','DNS']

  windowsfeature { $domaincontrollerfeatures:
    ensure => present,
    installmanagementtools => true,
  }
  Import-DscResource -ModuleName PSDesiredStateConfiguration
  Import-DscResource -ModuleName xActiveDirectory
  Import-DscResource -ModuleName NetworkingDsc

  */

  dsc_windowsfeature  { 'addsinstall':
            dsc_ensure => 'Present',
            dsc_name   => 'AD-Domain-Services',

  }
  dsc_windowsfeature  {'addstools':
            dsc_ensure => 'Present',
            dsc_name   => 'RSAT-ADDS',
  }
  dsc_windowsfeature  {'DNS':
            dsc_ensure => 'Present',
            dsc_name   => 'DNS',
  }

  dsc_xaddomain   { 'primaryDC':
    subscribe                         => Dsc_windowsfeature['addsinstall'],
    dsc_domainname                    => $dc,
    dsc_domainnetbiosname             => $dcnetbois,
    dsc_forestmode                    => $forestmode,
    dsc_domainmode                    => $domainmode,
    dsc_databasepath                  => $dcdbpath,
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
  # Investigate building this into an array loop, build loop in order of ou top down ie layer one layer two based on layer one with key pair hash

$oupathmaster.each | String $ou | {
  dsc_xadorganizationalunit  { "Create ${ou}":
      dsc_ensure                          => 'Present',
      dsc_name                            => $ou,
      dsc_path                            => $domaincontainer,
      dsc_description                     => "Top Level OU - ${ou}",
      dsc_protectedfromaccidentaldeletion => true,
      #subscribe                           => Dsc_xaddomain['primaryDC'],
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

  }
  dsc_xadorganizationalunit  {'CreateDesktopOU':
      dsc_ensure                          => 'Present',
      dsc_name                            => 'desktop',
      dsc_path                            => "OU=UK,${domaincontainer}",
      dsc_protectedfromaccidentaldeletion => true,
      subscribe                           => Dsc_xadorganizationalunit['CreateUKOU'],
      dsc_credential => {
        'user'     => $user,
        'password' => Sensitive($passw)
      },
  }

  dsc_xadorganizationalunit  {'CreatePuppetOU':
      dsc_ensure                          => 'Present',
      dsc_name                            => 'puppet',
      dsc_path                            => $domaincontainer,
      dsc_description                     => 'Top Level OU Puppet',
      dsc_protectedfromaccidentaldeletion => true,
      #subscribe      => Dsc_xaddomain['primaryDC'],
      dsc_credential => {
        'user'     => $user,
        'password' => Sensitive($passw)
      },
  }
  dsc_xadorganizationalunit  {'CreateWindowsOU':
      dsc_ensure                          => 'Present',
      dsc_name                            => 'windows',
      dsc_path                            => "OU=puppet,${domaincontainer}",
      dsc_protectedfromaccidentaldeletion => true,
      subscribe                           => Dsc_xadorganizationalunit['CreatePuppetOU'],
      dsc_credential => {
        'user'     => $user,
        'password' => Sensitive($passw)
      },
  }
*/
  # Lets create the OU needed for the computers.
  /*

   xWaitForADDomain 'WaitForDomainInstall' {
      DomainName = $Node.DomainName;
      DomainUserCredential = $DomainCredential;
      RebootRetryCount = 2;
      RetryCount = 10;
      RetryIntervalSec = 60;
      DependsOn = '[xADDomain]ADDomainInstall';
    }

    xADOrganizationalUnit 'CreateAccountsOU' {
      Name = 'Accounts';
      Path = $DomainContainer;
      Ensure = 'Present';
      Credential = $DomainCredential;
      DependsOn = '[xWaitForADDomain]WaitForDomainInstall';
    }
    dsc_xaddomaincontroller
*/
/*
  reboot {'dsc_reboot':
      message => 'DSC has requested a reboot',
      when => pending,
  }
  */
}
