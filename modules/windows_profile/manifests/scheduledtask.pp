class windows_profile::scheduledtask (
  Hash $scheduledtask = {},
  ) {
      $scheduledtask.each | $_k, $_v | {
        dsc_scheduledtask { $_k:
          * => $_v,
        }
      }
    }
