class windows_profile::windowsbase (

){

/*   
 Windows Base 
 This file contains the base installs i want for my windows machines
 Installs Packages - uses chocolatey packages
 Adds shortcuts - requires puppetlabs win_desktop_shortcut from puppet forge check out Puppetfile for more
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

    package {'notepadplusplus':
      ensure => latest,
    }

    package {'ccleaner':
      ensure => latest,
    }

    package{'teamviewer':
      ensure => 'present',
    }

    package { 'cpu-z.install':
      ensure => 'present'
    }

    package { 'procmon':
      ensure => 'present'
    }
}
