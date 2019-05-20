class chocopackages::installfirefox () {

    package { 'firefox':
      ensure   => installed,
      provider => 'chocolatey',
    }
}
