# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include linux_profile::master
class linux_profile::master {

  file_line { 'add_LANG':
      path => '/etc/sysconfig/pe-puppetserver',
      line => 'LANG=en_US.UTF-8',
      notify => Service['pe-puppetserver'],
    }
}
