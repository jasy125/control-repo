plan pullp::pullp_test {

  # Define the puppet master
  $self = 'pe-201950-master.puppetdebug.vlan'

  # Pull in passwords
  $presults = run_command('/root/prov/scripts/pullp', $self).first
  out::message("Output is ${presults}")

  return ({ 'return' => $presults })
}
