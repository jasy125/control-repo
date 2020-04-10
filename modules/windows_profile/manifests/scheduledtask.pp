class windows_profile::scheduledtask (
  Hash $scheduledtask = {},
  ) {

      notify{"Schedule Task Runner":}
      $scheduledtask.each | $_k, $_v | {
        notify{"before": }
        notify{ $_k :}
        notify{"after": }
        dsc_scheduledtask { $_k:
          * => $_v,
        }
      }
    }
