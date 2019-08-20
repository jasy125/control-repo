class windows_profile::domain {

  $domaincontrollerfeatures = ['AD-Domain-Services','DNS']

  windowsfeature { $domaincontrollerfeatures:
    ensure => present,
    installmanagementtools => true,
  }

  /*
  $domaincontrollerfeatures = ['AD-Domain-Services','DNS']
  
  dsc_windowsfeature {'$domaincontrollerfeatures':
    dsc_ensure = 'present'
    
  }
  
  */

}
