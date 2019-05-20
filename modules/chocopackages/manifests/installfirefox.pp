class chocopackages::installfirefox () {

    package { 'firefox':
      ensure   => latest,
    }
}
