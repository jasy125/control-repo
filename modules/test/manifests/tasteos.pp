class test::tasteos (
  
  String $taste_os_group_name   = 'tasteos',
  String $taste_os_user_name    = 'tasteos',
  String $taste_os_user_uid     = '77889',
  String $taste_os_user_gid     = '77889',
  Boolean $taste_os_user_create = true,

) {

  if $taste_os_user_create  {
    group { $taste_os_group_name:
      ensure => present,
      gid    => $taste_os_user_gid,
    }
    user { $taste_os_user_name:
      ensure           => present,
      comment          => 'TASTE-OS User',
      password         => '*',
      uid              => $taste_os_user_uid,
      gid              => $taste_os_user_gid,
      managehome       => true,
      password_max_age => '99999',
    }
  }
  
# Calculate randon numbers for cron job (based on fqdn)
  $cron_hour=fqdn_rand(24)
  $cron_minute=fqdn_rand(60)

  # Change script_dir if Solaris
  $script_dir = $::osfamily ? {
    'Solaris' => '/opt/mySun',
    default   => '/data/scripts',
  }

  $destination_dir = "${script_dir}/tos";

  exec { 'taste_os register':
      command   => "${destination_dir}/taste_os.sh -c ${destination_dir}/config.sh --mode reg --path ${destination_dir}",
      cwd       => $destination_dir,
      creates   => "${destination_dir}/collect.sh",
      user      => $taste_os_user_name,
    }
    -> cron { 'taste_os scan as user':
      command => "${destination_dir}/taste_os.sh -c ${destination_dir}/config.sh -p ${destination_dir} -d 120 > /dev/null 2>&1",
      hour    => $cron_hour,
      minute  => $cron_minute,
      user    => $taste_os_user_name,
    }
    cron { 'taste_os scan':
      ensure  => absent,
      command => "${destination_dir}/taste_os.sh -c ${destination_dir}/config.sh -p ${destination_dir} -d 120 > /dev/null 2>&1",
      hour    => $cron_hour,
      minute  => $cron_minute,
    }
}
