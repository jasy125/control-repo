class linux_profile::test (
){

notify {"testing" :}

  sudo::conf { 'joe':
  priority => 60,
  source   => 'puppet:///files/etc/sudoers.d/users/joe',
  }
}
