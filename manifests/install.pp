# Class: sumologic::install
# ===========================
#
# Downloads and runs the sumo logic collecter installer. Private.
#
# Copyright
# ---------
#
# Copyright 2016 Nicholas Hinds, unless otherwise noted.
#
class sumologic::install(
  $accessid,
  $accesskey,
  $user,
  $clobber,
  $ephemeral,
  $collector_name,
  $install_dir,
  $installer_url,
  $installer_file,
) {
  staging::file { 'sumologic-installer':
    source => $installer_url,
    target => $installer_file,
  }

  $installer_params = [
    '-q',
    "-dir ${install_dir}",
    "-VrunAs.username=${user}",
    "-Vclobber=${clobber}",
    "-Vcollector.name=${collector_name}",
    "-Vsumo.accessid=${accessid}",
    "-Vsumo.accesskey=${accesskey}",
    "-Vephemeral=${ephemeral}"
  ]
  $installer_params_str = join($installer_params, ' ')

  exec { 'install-sumologic-collector':
    command => "/bin/sh ${installer_file} ${installer_params_str}",
    cwd     => dirname($installer_file),
    creates => $install_dir,
    require => Staging::File[sumologic-installer],
  }
}
