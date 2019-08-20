class windows_profile::domain {

  include windowsfeature
  $domaincontrollerfeatures = ['AD-Domain-Services','DNS']

  windowsfeature { $domaincontrollerfeatures:
    ensure => present,
    installmanagementtools => true,
  }

  reboot {'after_DNS':
    when  => pending,
    subscribe => Windowsfeature['DNS'],
  }

  /*
  $domaincontrollerfeatures = ['AD-Domain-Services','DNS']
  
  dsc_windowsfeature {'$domaincontrollerfeatures':
    dsc_ensure = 'present'
    
  }
  
  */

}
