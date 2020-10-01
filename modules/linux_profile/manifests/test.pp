class linux_profile::test (
  $mytest,
){

$mytest = $linux_profile::test

  notify{ "My test ${mytest}" :}
}
