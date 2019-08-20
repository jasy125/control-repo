class windows_profile::domain {

  $domaincontrollerfeatures = ['AD-Domain-Services','DNS']

  windowsfeature { $domaincontrollerfeatures:
    ensure => present,
    installmanagementtools => true,
    name =>$domaincontrollerfeatures,
  }
 
 reboot { 'after':
  subscribe       => windowsfeature['DNS'],
 }

  /*
  $domaincontrollerfeatures = ['AD-Domain-Services','DNS']
  
  dsc_windowsfeature {'$domaincontrollerfeatures':
    dsc_ensure = 'present'
    
  }
  
  */

}
