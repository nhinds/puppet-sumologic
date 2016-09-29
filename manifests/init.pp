# Class: sumologic
# ===========================
#
# Installs and configures a sumo logic collector
#
# Parameters
# ----------
#
# * `accessid`
# The ID of the access key used to register the collector. Required.
#
# * `accesskey`
# The access key used to register the collector. Required.
#
# * `user`
# The user to run the collector as. Defaults to 'sumo'.
#
# * `manage_user`
# Whether to ensure the user exists. Defaults to true.
#
# * `clobber`
# Whether to clobber (replace) existing collectors in Sumo Logic. Defaults to false.
#
# * `ephemeral`
# Whether the collector should be marked as ephemeral in Sumo Logic (to be deleted after it goes offline for a certain period of time).
# Defaults to false.
#
# * `collector_name`
# The name of the collector in Sumo Logic. Defaults to the node's FQDN.
#
# * `install_dir`
# The directory to install the collector to. Defaults to '/opt/SumoCollector'.
#
# * `installer_url`
# The URL to download the collector installer from. Must be the installer URL, not the RPM or DEB file URL.
# Defaults to 'https://collectors.sumologic.com/rest/download/linux/64'
#
# * `installer_file`
# The file to store the installer in once it has been downloaded. Defaults to '/opt/sumo-installer.sh'.
#
# Copyright
# ---------
#
# Copyright 2016 Nicholas Hinds, unless otherwise noted.
#
class sumologic(
  $accessid       = undef,
  $accesskey      = undef,
  $user           = 'sumo',
  $manage_user    = true,
  $clobber        = false,
  $ephemeral      = false,
  $collector_name = $::fqdn,
  $install_dir    = '/opt/SumoCollector',
  $installer_url  = 'https://collectors.sumologic.com/rest/download/linux/64',
  $installer_file = '/opt/sumo-installer.sh',
) {
  if ($accessid == undef or $accesskey == undef) {
    fail('accessid and accesskey are required')
  }
  validate_string($accessid, $accesskey, $user, $collector_name, $installer_url)
  validate_absolute_path($install_dir, $installer_file)
  validate_bool($manage_user, $clobber, $ephemeral)

  if ($manage_user) {
    user { $user:
      ensure => present,
      system => true,
      before => Class['sumologic::install'],
    }
  }

  class { 'sumologic::install':
    accessid       => $accessid,
    accesskey      => $accesskey,
    user           => $user,
    clobber        => $clobber,
    ephemeral      => $ephemeral,
    collector_name => $collector_name,
    install_dir    => $install_dir,
    installer_url  => $installer_url,
    installer_file => $installer_file,
  }
  contain sumologic::install

}
