class test () {
  cron { 'taste_os scan as user': 
          command => "${destination_dir}/taste_os.sh -c ${destination_dir}/config.sh -p ${destination_dir} -d 120 > /dev/null 2>&1", 
          hour => $cron_hour, 
          minute => $cron_minute, 
          user => $taste_os_user_name, 
      },
}
