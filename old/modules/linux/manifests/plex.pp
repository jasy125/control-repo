class linux::plex {
  class {'plexmediaserver':
    plex_user                                 => 'foo',
    plex_media_server_home                    => '/usr/share/lib/plexmediaserver',
    plex_media_server_application_support_dir => "`getent passwd $PLEX_USER|awk -F : '{print $6}'`/My Documents/Application Support",
    plex_media_server_max_plugin_procs        => '7',
    plex_media_server_max_stack_size          => '20000',
    plex_media_server_max_lock_mem            => '4000',
    plex_media_server_max_open_files          => '1024',
    plex_media_server_tmpdir                  => '/var/tmp',
  }
}
