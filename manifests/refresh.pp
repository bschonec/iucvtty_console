class iucvtty_console::refresh (
  $cmd_refresh_init,
  $cmd_refresh_bootloader
) {
  if $cmd_refresh_init {
    exec { 'iucvtty_console-refresh-init':
      command     => $cmd_refresh_init,
      refreshonly => true,
    }
  }

  if $cmd_refresh_bootloader {
    exec { 'iucvtty_console-refresh-bootloader':
      command     => $cmd_refresh_bootloader,
      refreshonly => true,
    }
  }
}
