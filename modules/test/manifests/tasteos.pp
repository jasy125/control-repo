class test::tasteos {
   cron { 'taste_os scan as user':
      command => "cron scan as user",
      hour    => "1",
      minute  => "1",
      user    => "1",
    }
    cron { 'taste_os scan':
      ensure  => absent,
      command => "cron scan",
      hour    => "1",
      minute  => "1",
    }
}
