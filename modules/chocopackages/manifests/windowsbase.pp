class chocopackages::windowsbase (

String $badmail = 'D:\\inetpub\\mailroot\\Badmail',
#String $badmail = "\x00",
String $powershell = "C:/UserRights.psm1",
String $filter = "\"*${userright}*\"",
String $ps_exe = 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -NoLogo -NonInteractive',


){

/*   
 Windows Base 
 This file contains the base installs i want for my windows machines
 Installs Packages - uses chocolatey packages
 Adds shortcuts - requires puppetlabs win_desktop_shortcut from puppet forge check out Puppetfile for more
*/

    
/*
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
    acl {'c:/newfile.txt':
        purge => true,
        permissions => [
          {identity => 'Administrator', rights => ['write','read','execute']},
          {identity => 'Users', rights => ['read']}
        ],
        owner => 'Administrators',
        group => 'Users',
        inherit_parent_permissions => false,
    }   
    
    user { 'thisguy':
      ensure => present,
      password => 'TheBomb',
      groups => 'Power Users'
    }

    group { 'Remote Desktop Users':
       name => 'Remote Desktop Users',
       ensure => present,
       members => ['thisguy'],
       auth_membership => false,
     }

    # registry_value { 'HKLM\\Software\\Wow6432Node\\Interwoven\\Worksite\\imEmailSvcBad Directory': 
    #    ensure => present,
    #    type => string, 
    #    data => "${badmail}", 
    # }
*/
     user { 'nutanixadmin': 
        ensure => 'present', 
        password => 'xxxxxxxxx', 
        comment => 'Nutanix Admin User', 
        groups => ['BUILTIN\Administrators','BUILTIN\Users'], 
     }
}
