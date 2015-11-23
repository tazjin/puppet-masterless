# Puppet should not create a local filebucket for backups.
# All configuration file versions are in git and should not
# be modified locally.
File {
  backup => false,
}

# Puppet classes and variables are assigned in Hiera.
# They can be assigned at host, role and common level. Classes from all levels
# will be included.
# See https://docs.puppetlabs.com/hiera/1/puppet.html for more information.

hiera_include('classes')
