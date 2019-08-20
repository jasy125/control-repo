class domaincontroller::domain {

  $domaincontrollerfeatures = ['AD-Domain-Services','DNS']

  windowsfeature { $domaincontrollerfeatures:
    ensure => present,
    installmanagementtools => true,
  }

  reboot {'after_DNS':
    when  => pending,
    subscribe => Windowsfeature['DNS'],
  }

}
