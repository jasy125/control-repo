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
}

