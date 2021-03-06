## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Disable filebucket by default for all File resources:
File { backup => false }

#include '::users'
#include '::skeleton'

# Randomize enforcement order to help understand relationships
ini_setting { 'random ordering':
  ensure  => present,
  path    => "${settings::confdir}/puppet.conf",
  section => 'agent',
  setting => 'ordering',
  value   => 'title-hash',
}

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  # class { 'my_class': }
  notify { "Default node. hostname: ${::hostname}!": }
}

node /^nicholashoule$/ {
  include '::users'
  include '::skeleton'
  include '::memcached'
  include '::profile::blog'

  users::managed_user { 'bob': }
  users::managed_user { 'nick': }
  users::managed_user { 'jim': }
}

file { '/etc/motd':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => "\nMOTD:\n\nToday we learned how to manage our Puppet node\n\n",
}

if $facts['is_virtual'] != 'physical' {

  notify { 'Discovered: Virtual Machine.':
    loglevel => 'info',
  }

  case $facts['virtual'] {
    'docker': {
      $_vm_name = upcase($facts['virtual'])
      notify { "Hypervisor: ${_vm_name}":
        loglevel => 'info',
      }
    }
  default: {
      fail("Unsupported hypervisor: ${facts['virtual']}")
    }
  }

}

exec { 'motd-cowsay':
  path    => ['/bin', '/sbin', '/usr/local/bin'],
  command => "cowsay 'Welcome to ${::fqdn}' > /etc/motd",
  require => File['/etc/motd']
}

host { 'localhost':
  ensure       => present,
  ip           => '127.0.0.1',
  host_aliases => ['local', 'testing.puppetlabs.vm'],
  comment      => 'Handle the localhost'
}

host { 'testing.puppetlabs.vm':
  ensure => absent,
}

$message = hiera('message')
notify { $message: }



