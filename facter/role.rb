# Puppet fact to determine role
# Expects hostname in the format $role-$count, for example 'bastion-1' as the
# first host with the 'bastion' role.

Facter.add(:role) do
  setcode do
    Facter.value(:hostname).scan(/^(.*)-\d+$/)[0][0]
  end
end
