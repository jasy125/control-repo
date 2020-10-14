# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include diskconfig
class diskconfig {

  exec {"say-hello":
  command   => file('diskconfig/test.ps1'),
  provider  => powershell,
  logoutput => true,
  }
}
