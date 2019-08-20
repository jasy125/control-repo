class chocopackages::adconfig {
  
  package {'plexmediaserver':
    ensure =>latest,
  }

  exec{'bbc':
    provider => 'powershell',
    command => '$sh = New-Object -comObject WScript.Shell; $short = $sh.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Tiled\Tiled.lnk"); $short.TargetPath = "C:\Program Files (x86)\Tiled\Tiled.exe"; $short.Save();'
  }
}
