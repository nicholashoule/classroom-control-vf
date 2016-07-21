#
define users::managed_users (
    $group       = $title,
    $user        = $title,
    $shell       = '/bin/bash',
    $enable_ssh  = true,
) {

  $_memory = '2048'

  $users.each |$item| {
    notify { $item:
      message  => "Managed Users: ${item}",
      loglevel => 'warning',
  }

  group { $group:
    ensure => present,
  }

  user { $user:
    ensure => present,
    gid    => $group,
    shell  => $shell,
    home   => "/home/${user}",
  }

  file { "/home/${user}":
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }

  if $enable_ssh == true {

    file { "/home/${user}/.ssh":
      ensure => directory,
      owner  => $title,
      group  => $group,
      mode   => '0700',
      notify => Exec["SSH key: ${user}"],
    }

    exec { "SSH key: ${user}":
      command => "ssh-keygen -t rsa -M '${_memory}' -f /home/${user}/.ssh/id_rsa",
      path    => [],
      creates => "/home/${user}/.ssh/id_rsa",
      require => File["/home/${user}/.ssh"],
    }
  }

}

