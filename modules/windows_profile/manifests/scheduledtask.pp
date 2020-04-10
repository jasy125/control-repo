class windows_profile::scheduledtask (
  Hash $scheduledtask = {},
  ) {

      notify{"Schedule Task Runner":}
      $scheduledtask.each | $_k, $_v | {
        dsc_scheduledtask { $_k:
          * => $_v,
        }
      }
    }
