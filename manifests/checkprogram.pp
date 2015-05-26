# Define: monit::checkprogram
#
# Check the exit status of a program or a script.
#
# Usage:
# With standard template:
# monit::checkprogram  { "name":
#   path         => "/usr/local/bin/test_myprogram.sh"
#   startprogram => "/etc/init.d/myprogram start"
#   stopprogram  => "/etc/init.d/myprogram stop"
# }
#
define monit::checkprogram (
  $program      = '',
  $processuid   = '',
  $processgid   = '',
  $template     = 'monit/checkprogram.erb',
  $path         = '',
  $startprogram = undef,
  $stopprogram  = undef,
  $exitcode     = '!= 0',
  $cycles       = '1',
  $failaction   = 'timeout',
  $depends      = [],
  $enable       = true ) {

  $ensure=bool2ensure($enable)

  include monit

  $real_program = $program ? {
    ''      => $name,
    default => $program,
  }

  $real_processuid = $processuid ? {
    ''      => $monit::process_user,
    default => $processuid,
  }

  $real_processgid = $processgid ? {
    ''      => $monit::process_group,
    default => $processgid,
  }


  file { "MonitCheckProgram_${name}":
    ensure  => $ensure,
    path    => "${monit::plugins_dir}/${name}",
    mode    => $monit::config_file_mode,
    owner   => $monit::config_file_owner,
    group   => $monit::config_file_group,
    require => Package[$monit::package],
    notify  => $monit::manage_service_autorestart,
    content => template($template),
    replace => $monit::manage_file_replace,
  }

}
