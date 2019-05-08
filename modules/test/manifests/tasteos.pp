class test::tasteos {
   exec { 'taste_os register':
      user      => "1",
    }
    -> cron { 'taste_os scan as user':
      command => "cron",
      hour    => "1",
      minute  => "1",
      user    => "1",
    }
    cron { 'taste_os scan':
      ensure  => absent,
      command => "cron",
      hour    => "1",
      minute  => "1",
    }
}
