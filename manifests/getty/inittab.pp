class iucvtty_console::getty::inittab (
  $ttys,
  $ttys_id,
  $speed,
  $term_type,
  $runlevels
) {
  augeas { "inittab-agetty-${ttys}":
    incl    => '/etc/inittab',
    lens    => 'Inittab.lns',
    context => "/files/etc/inittab/T${ttys_id}",
    notify  => Class['iucvtty_console::refresh'],
    changes => [
      "set runlevels ${runlevels}",
      'set action respawn',
      "set process '/sbin/getty -8L ${speed} ${ttys} ${term_type}'"
    ]
  }
}
