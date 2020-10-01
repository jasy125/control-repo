class linux_profile::test (
  $mytest = 'notfound',
){

$mytest = $inux_profile::test

  notify{ "My test ${mytest}" :}
}
