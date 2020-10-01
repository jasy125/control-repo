class linux_profile::test (
){

$mytest = $linux_profile::test

  notify{ "My test ${mytest}" :}
}
