Masterless Puppet setup
=======================

The Puppet setup used is masterless, meaning that instead of a central Puppet
master compiling the catalogue every machine periodically fetches its own copy
of the repository and uses `puppet apply`.

The contents of this repository are to be placed directly in `/etc/puppet`.

[Hiera][] is used for assigning classes to hosts and for maintaining variables
that might differ between roles or hosts.

The *role* of every machine is determined by its hostname as such:

    /^(?<role>.*)-\d+$/

As an example, the host `bastion-1` has role `bastion`, the host `varnish-1`
has role `varnish` and so on.

Hiera variables are stored in the `hiera` folder using this structure:

```
hiera
├── common.yaml
└── roles
    └── somerole.yaml
└── hosts
    └── somerole-2.aws.company.no.yaml
```

## Scheduled runs

Runs are scheduled through a `systemd.timer` unit. By default Puppet is run once
every 30 minutes, however this can be configured by changing the Hiera variable
`puppet::interval`.

Commands to check on the status of the current runs (require root):

```
# See log output from last runs
journalctl -f -u git-puppet

# See status of timer
systemctl status git-puppet.timer

# See status of run
systemctl status git-puppet.service
```

## Branches

There is support for testing configuration from different branches, for example
when building a new module.

The script that runs Puppet will check for the file `/etc/puppet/deploy-branch`
and will use the content of the file as a remote branch to check out from `git`
when running Puppet. You can use those branches to quickly let Puppet run with
configuration changes that are either temporary or not yet ready for `master`.

Example:
```shell
# Let's say we have a branch 'test-branch' which contains some changes that should
# not be rolled out on every machine, only on the one we are logged in to:

$ echo 'test-branch' > /etc/puppet/deploy-branch
$ systemctl start git-puppet

# The branch will now be changed to the new branch. Don't forget to revert it later!

```

## Puppet dependencies

Puppet modules from external sources such as the Puppet Forge can be included in
the `Puppetfile` in the repository root. They are fetched and installed by
[Librarian][] on every run.
