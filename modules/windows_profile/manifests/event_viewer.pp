class windows_profile::event_viewer (
  String $log_folder = lookup('profile::windows_base::event_viewer::log_folder', {'default_value' => 'C:\\Config' }),
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

