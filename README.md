# sumologic

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Installs the [Sumo Logic](https://www.sumologic.com/) Collector.

Includes support for running as a non-root user.

## Usage

Basic usage requires declaring the `sumologic` class and providing the
`accessid` and `accesskey` parameters. This will download and install the
collector with the module's default parameters.

```
class { sumologic:
  accessid  => '...',
  accesskey => '...',
}
```

By default, the collector will run as the `sumo` user. To run as another user,
such as `root`, specify the `user` parameter (and optionally the `manage_user`
parameter):

```
class { sumologic:
  accessid    => '...',
  accesskey   => '...',
  user        => root,
  manage_user => false,
}
```

See the parameter reference below for more configuration.

## Reference

### Classes

#### Public classes
* [`sumologic`](#sumologic-1): Installs and configures a sumo logic collector

### `sumologic`

#### Parameters

##### `accessid`
The ID of the access key used to register the collector. Required.

##### `accesskey`
The access key used to register the collector. Required.

##### `user`
The user to run the collector as. Defaults to `'sumo'`.

##### `manage_user`
Whether to ensure the user exists. Defaults to `true`.

##### `clobber`
Whether to clobber (replace) existing collectors in Sumo Logic. Defaults to
`false`.

##### `ephemeral`
Whether the collector should be marked as ephemeral in Sumo Logic (to be
deleted after it goes offline for a certain period of time). Defaults to
`false`.

##### `collector_name`
The name of the collector in Sumo Logic. Defaults to the node's `fqdn`.

##### `install_dir`
The directory to install the collector to. Defaults to `'/opt/SumoCollector'`.

##### `installer_url`
The URL to download the collector installer from. Must be the installer URL,
not the RPM or DEB file URL.
Defaults to `'https://collectors.sumologic.com/rest/download/linux/64'`

##### `installer_file`
The file to store the installer in once it has been downloaded. Defaults to
`'/opt/sumo-installer.sh'`.

## Limitations

Only installs the collector, does not manage sources, etc.

Does not modify settings (e.g. collector name, user) if they change after the
initial installation.

Tested on Ubuntu.

## Development

Fork and PR. Please add a test for your change and ensure the existing tests pass with `rake test`.
