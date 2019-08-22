class windows_profile::domain (
  $user = 'admin',
  $passw = 'Qu@lity!',
  $dc = 'jsserv.local',
  $dcnetbois = 'jsservlocal',
  $dcdbpath = 'c:\NTDS',
  $dclogpath = 'c:\NTDS',
  $forestmode = 'WinThreshold',
  $domainmode = 'WinThreshold',

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
    dsc_domainnetbiosname => $dcnetbois,
    dsc_domainadministratorcredential => $user,
    dsc_safemodeadministratorpassword => $passw,
    dsc_forestmode => $forestmode,
    dsc_domainmode => $domainmode,
    dsc_databasepath => $dcdbpath,
    dsc_logpath => $dclogpath,

    /*
    dsc_domainadministratorcredential => {
            'user'     => $user,
            'password' => Sensitive($passw)
    },

    dsc_safemodeadministratorpassword   => {
            'user'     => $user,
            'password' => Sensitive($passw)
    },
    */
  }
  xWaitForADDomain 'WaitForDomainInstall' {
      DomainName = $Node.DomainName;
      DomainUserCredential = $DomainCredential;
      RebootRetryCount = 2;
      RetryCount = 10;
      RetryIntervalSec = 60;
      DependsOn = '[xADDomain]ADDomainInstall';
    }

  # Lets create the OU needed for the computers.
  /*
  dsc_xWaitForADDomain => {},
  dsc_xADOrganizationalUnit => {},
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

  reboot {'dsc_reboot':
      message => 'DSC has requested a reboot',
      when => pending,
  }
}
