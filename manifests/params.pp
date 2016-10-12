class iucvtty_console::params {
  $enabled = true
  $su_login = false                    # Uses /sbin/sulogin rather than /bin/login
  $runlevels = '12345'
  $logout_timeout = 0
  $allow_from     = Undef              # Undefined = allow from any z/VM user ID.
  $terminal_id = $::hostname           # identifies the z/VM IUCV connection.
  $iucvtty_binary    = '/usr/bin/iucvtty'
  $iucvtty_file_mode = '0644'
  $iucvtty_file_owner = 'root'
  $iucvtty_file_group = 'root'

  $login_program = $su_login ? {
    true    => '/sbin/sulogin',
    default => '/bin/login',
  }

  $iucvtty_service = 'iucvtty'


case $::operatingsystem {
        redhat: {
          case $::operatingsystemmajrelease {
            6: {
              $iucvtty_file     = "/etc/init/${iucvtty_service}.conf"
              $template_file    = 'iucvtty_upstart.conf.erb'
              $cmd_start_init = "/sbin/initctl start ${iucvtty_service}"
              $cmd_stop_init  = "/sbin/initctl stop ${iucvtty_service}"
            }
            7: {
              $iucvtty_file     = '/etc/init/iucvtty.conf'
              $template_file    = 'iucvtty_upstart.conf.erb'
              $cmd_start_init = "/sbin/initctl start ${iucvtty_service}"
              $cmd_stop_init  = "/sbin/initctl stop ${iucvtty_service}"
            }
            default: {
              fail("Unsupported OS version: ${::operatingsystem} ${::operatingsystemmajrelease}")
            }

          }
        }
      }
}
