class chocopackages::windowsbase (

String $badmail = 'D:\\inetpub\\mailroot\\Badmail',
#String $badmail = "\x00",
String $powershell = "-File C:/UserRights.psm1 -NoProfile -NoLogo -NonInteractive",
String $filter = "\"*${userright}*\"",
String $ps_exe = 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -NoLogo -NonInteractive',
String $account_to_manage = "some"
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

    package{'choco install teamspeak-server':
      ensure => latest
    }

    package{'choco install teamspeak':
      ensure => latest
    }
    package { 'chocolatey-misc-helpers.extension':
      ensure => 'present'
    }
    package{'plexmediaserver':
      ensure => latest
    }
    package { 'sonarr':
      ensure => 'present'
    }
    package { 'radarr':
      ensure => 'present'
    }
    package { 'sabnzbd':
      ensure => 'present'
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
/*
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

  # Working Exec
exec { "Grant-Privilege-${userright}-${securityprincipal}":
    # Working:
    command   => "${ps_exe} -Command \"& {Import-Module ${powershell}; Grant-UserRight -Account \'${account_to_manage}\' -Right ${userright} }\"",
    onlyif    => "${ps_exe} -Command \"& {Import-Module ${powershell}; If (Test-AccountHasUserRight -Right ${userright} -Account \'${account_to_manage}\') { Exit 1 } Else { Exit 0 } }\"",
    logoutput => true,
    require   => File[$powershell],
  }


  registry_value { 'HKLM\\Software\\Wow6432Node\\Interwoven\\Worksite\\imEmailSvcBad Directory':
  ensure => present,
  type => string,
  data => "${badmail}",
  }
*/


}
