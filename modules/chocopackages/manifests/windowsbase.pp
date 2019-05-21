class chocopackages::windowsbase {

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

  
    file { "${win_common_desktop_directory}\\PuppetLabs.URL":
            ensure  => present,
            content => "[InternetShortcut]\nURL=http://puppetlabs.com",
         }

    file { "${win_common_desktop_directory}\\BBC.URL":
            ensure  => present,
            content => "[InternetShortcut]\nURL=http://bbc.com",
         }

    file { 'C:/newfile.txt': 
        ensure => present,
        content => "my text file",
    }
    acl {'c:/newfile':
        purge => true,
        permissions => [
          {identity => 'Administrator', rights => ['write','read','execute']}
        ],
        owner => 'Administrators'
        group => 'Users',
        inherit_parent_permissions => false,
    }   
}
