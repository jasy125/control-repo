class chocopackages::installfirefox () {

    package { 'firefox':
      ensure   => latest,
      provider => 'chocolatey',
    }
}
