# Sets up and configures a masterless Puppet setup, using a systemd service and
# the specified interval to time Puppet runs.
# The interval argument is a systemd interval specification, see systemd.time(7)

class puppet ($interval) {
    include base::systemd

    package { 'puppet':
      ensure => installed,
    }

    # Puppet's configuration is stored in /etc/puppet
    # The configuration is maintained in git and should not be edited on the
    # machines themselves.
    # This script will update the contents of the repository and run puppet-apply
    # locally.
    file { '/usr/bin/git-puppet':
      ensure => present,
      mode   => '0755',
      source => 'puppet:///modules/puppet/git-puppet',
    }

    # Systemd unit for Puppet runs
    file { '/usr/lib/systemd/system/git-puppet.service':
      ensure => present,
      source => 'puppet:///modules/puppet/git-puppet.service',
      notify => Exec['systemctl daemon-reload'],
    }

    # Systemd timer for Puppet runs
    file { '/usr/lib/systemd/system/git-puppet.timer':
      ensure  => present,
      content => template('puppet/git-puppet.timer'),
      require => File['/usr/lib/systemd/system/git-puppet.service'],
      notify  => Exec['systemctl daemon-reload'],
    }

    service { 'git-puppet.timer':
      ensure  => running,
      enable  => true,
      require => File['/usr/lib/systemd/system/git-puppet.timer'],
    }

  }
