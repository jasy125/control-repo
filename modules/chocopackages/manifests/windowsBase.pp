class chocopackages::windowsbase {

    package { 'firefox':
      ensure   => latest,
    }

    package { 'chrome':
      ensure => latest,
    }
 /*   
    package { '7zip':
      ensure => latest,
    },
   
    package {'adobereader':
      ensure => latest,
    },

    package {'vlc':
      ensure => latest,
    },
    package {'putty':
      ensure => latest,
    },

    package {'notepadplusplus':
      ensure => latest,
    },

    package {'ccleaner':
      ensure => latest,
    },

    package {'treesizefree':
      ensure => latest,
    },
    */
}
