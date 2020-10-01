class linux_profile::test (
  $mytest = 'notfound',
){

$mytest = $linux_profile::test

  notify{ "My test ${mytest}" :}
}
