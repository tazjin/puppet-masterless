Masterless Puppet with systemd
==============================

This repository is intended as a sort of "template" for masterless Puppet setups
on systemd-based distributions. This exact setup has been used on CentOS, but it
should work on many other distributions (such as Debian >= 8) as well.

This setup is opinionated and requires that the infrastructure adheres to things
such as a strict naming schema and version-controlled Puppet manifests in a git
repository.

## Bootstrapping

To bootstrap this repository on a machine, make sure you have installed
[Puppet][] as well as [librarian-puppet][].

```
# On Debian 8+
apt-get install puppet librarian-puppet git

# On CentOS 7+ (EPEL required)
yum install epel-release git && yum install puppet
gem install librarian-puppet
```

Make sure that the `root` user has an SSH key that can access your git-repo.
On BitBucket, you can use the deployment-key feature for read-only access keys.

Clone the repository using `git` to the destination folder, `/etc/puppet`. You
may have to remove this folder first.

```
rm -rf /etc/puppet && git clone git@githost.com:company/puppet.git /etc/puppet
```

After this, you may proceed by running Puppet manually once. This should set up
everything:

```
puppet apply --modulepath /etc/puppet/modules /etc/puppet/manifests
```

You should now have a host with a masterless Puppet setup. Use this for example
to create a base image that other machines can be created from.

## Hostnames

Hostnames are used to determine the *role* of a machine. Therefore you need to
stick to the strict host naming schema defined in [role.rb][]. You may amend the
regular expression in that module to fit your needs.

## More documentation

Please see [puppet.md][] for more detailed documentation on this Puppet setup.

[Puppet]: https://puppetlabs.com/
[librarian-puppet]: https://github.com/rodjek/librarian-puppet
[role.rb]: facter/role.rb
[puppet.md]: docs/puppet.md
