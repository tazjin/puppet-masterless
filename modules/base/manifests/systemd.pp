# Provides an exec for 'systemctl daemon-reload', the systemd command that
# reloads all unit files.
# When changing unit files in any manifest, you can simply use this code snippet
#   include base::systemd
#   ...
#   notify => Exec['systemctl daemon-reload'],

class base::systemd {
  exec {'systemctl daemon-reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }
}
