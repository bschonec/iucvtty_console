class iucvtty_console::autologout (
  $logout_timeout
) {
  if is_numeric($logout_timeout) and $logout_timeout>0 {
    $_ensure=file
  } else {
    $_ensure=absent
  }

  file { '/etc/profile.d/ttyS_autologout.sh':
    ensure  => $_ensure,
    content => template('iucvtty_console/ttyS_autologout.sh.erb'),
  }
}
