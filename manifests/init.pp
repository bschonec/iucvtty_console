class iucvtty_console (
  $enabled                = $iucvtty_console::params::enabled,
  $su_login               = $iucvtty_console::params::su_login,
  $runlevels              = $iucvtty_console::params::runlevels,
  $logout_timeout         = $iucvtty_console::params::logout_timeout,
  $template_file          = $iucvtty_console::template_file,
  $terminal_id            = $iucvtty_console::terminal_id,
  $allow_from             = $iucvtty_console::allow_from,
  $iucvtty_file           = $iucvtty_console::iucvtty_file,
  $login_program          = $iucvtty_console::login_program,
  $login_options          = ''
) inherits iucvtty_console::params {

  $refresh_init_exec = 'refresh_init'

  validate_bool($enabled)
  validate_string($runlevels)
  validate_re($runlevels, '^\d+$')
  validate_re($logout_timeout, '^\d+$')

  validate_absolute_path($login_program)

  if $cmd_refresh_init { validate_absolute_path($cmd_refresh_init) }

  package {'s390utils-iucvterm':
    ensure => installed,
  }

  case $::operatingsystemmajrelease {

    # RHEL7 has built-in systemd scripts so this section is very easy.
    7: {
        service {"iucvtty-login@${terminal_id}":
        ensure => $enabled,
        enable => $enabled,
      }
    } # 7

    6: {
      case $enabled {
        true: {
          # Create the upstart file then start the 'service'.
          $file_ensure = file
          $cmd_refresh_init = $iucvtty_console::cmd_start_init
          File[$iucvtty_file] ~> Exec[$refresh_init_exec]
        }
    
        default: {
          # Stop the upstart 'service' then delete the file.
          $file_ensure = absent
          $cmd_refresh_init = $iucvtty_console::cmd_stop_init
          Exec[$refresh_init_exec] ~> File[$iucvtty_file]
        }
      } # case
    
      file {$iucvtty_file:
        ensure  => $::iucvtty_console::file_ensure,
        mode    => $::iucvtty_console::iucvtty_file_mode,
        owner   => $::iucvtty_console::iucvtty_file_owner,
        group   => $::iucvtty_console::iucvtty_file_group,
        content => template("${name}/${template_file}"),
      }

      # To avoid running the exec on every run and to ensure that the 
      # exec *does* run when $enabled=false, put in an 'onlyif' parameter. 
      exec {$refresh_init_exec:
        command     => $cmd_refresh_init,
        onlyif      => "/usr/bin/test -f ${iucvtty_file}",
        refreshonly => $enabled,
        logoutput   => true,
      }
    }
    default: {
      fail("Unsupported OS version: ${::operatingsystem} ${::operatingsystemmajrelease}")
    }
  }


}
