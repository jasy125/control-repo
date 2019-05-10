class devkey::notice (
$dev_hash = $facts['partitions'].filter |$device, $key| {$key['mount'] == '/' },
$dev_key = keys($dev_hash),
) {

notify { $dev_hash[$dev_key]['uuid']:},
#notify { ${dev_hash[$dev_key]['uuid']}: }, 
#notify { $dev_hash[${dev_key}]['uuid']: }, 
#notify { "${dev_hash[${dev_key}]['uuid']}: }, 
#notify { $dev_hash[$dev_hash.keys]['uuid']: },
##notify { "$dev_hash['$dev_key']['uuid']": }, 
}
