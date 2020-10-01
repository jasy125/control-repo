# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include linux_profile
class linux_profile (
  $mytest = 'cantfind',
) {

  $mytest = $my::test

  notify {'$mytest1' :}

}
