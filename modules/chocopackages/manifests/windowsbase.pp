class chocopackages::windowsbase {

/*   
 Windows Base 
 This file contains the base installs i want for my windows machines
*/


    package { 'firefox':
      ensure   => latest,
    }

    package { 'googlechrome':
      ensure => latest,
    }

    package { '7zip':
      ensure => latest,
    }

    package {'adobereader':
      ensure => latest,
    }

    package {'vlc':
      ensure => latest,
    }

    package {'putty':
      ensure => latest,
    }

    package {'notepadplusplus':
      ensure => latest,
    }

    package {'ccleaner':
      ensure => latest,
    }

    package {'treesizefree':
      ensure => latest,
    }
}
