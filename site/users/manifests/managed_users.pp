#
define users::managed_users (
    $group       = $title,
    $user        = $title,
    $shell       = '/bin/bash',
) {

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

  file { "/home/${user}/.ssh":
    ensure => directory,
    owner  => $title,
    group  => $group,
    mode   => '0700',
  }
}

