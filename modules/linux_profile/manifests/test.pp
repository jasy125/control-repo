class linux_profile::test (
){

$mytest = "$linux_profile::test"

  notify{ "$mytest" :}

  sudo::conf { 'joe':
  priority => 60,
  source   => 'puppet:///files/etc/sudoers.d/users/joe',
  }
}
