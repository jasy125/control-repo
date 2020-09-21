class windows_profile::event_viewer (
  $log_folder = 'C:\\Config',
) {
  # Creamos el directorio para albergar los logs
  file { 'log folder':
    ensure => directory,
    path   => $log_folder,
  }
  # Configuración de Event Viewer
  registry::value { 'Application':
    key   => 'HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application',
    value => 'File',
    data  => "${log_folder}\Application.evtx",
    type  => 'expand',
  }

  registry::value { 'Setting0':
      key   => 'HKLM\System\CurrentControlSet\Services\Puppet',
      value => '(default)',
      data  => "Hello World!",
  }

  registry::value { 'PagingFiles':
      key  => 'HKLM:\\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PagingFiles',
      data  => ['c:\pagefile.sys 300 300','h:\pagefile.sys 4000 4050'],
      type => 'array',
  }
}

