# class nginx.pp
# 
# @Authors Nicholas Houle
# 
# Copyright 2016
class nginx (
  $root          = undef,
  $nginx_pkg     = $nginx::params::package,
  $nginx_owner   = $nginx::params::owner,
  $nginx_group   = $nginx::params::group,
  $nginx_confdir = $nginx::params::confdir,
  $nginx_docroot = $nginx::params::docroot,
  $nginx_svc     = $nginx::params::service_user,
) inherits nginx::params {

  # Determine the docroot to use.
  # If the user passed in a value for the $docroot paramter, use that.
  # If the user did not pass in $docroot, use the value from the case statement.
  $www_docroot = $root ? {
    undef   => $nginx_docroot,
    default => $root,
  }

  $_nginx_dirs = [ $nginx_confdir, "${nginx_confdir}/conf.d", $www_docroot, "${www_docroot}/html" ]

  package { $nginx_pkg:
    ensure => latest,
  }

  File {
    owner   => $nginx_owner,
    group   => $nginx_group,
    mode    => '0644',
  }

  file { $_nginx_dirs:
    ensure => directory,
  }

  file { 'create nginx config':
    ensure  => file,
    path    => "${nginx_confdir}/nginx.conf",
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => [ Package[$nginx_pkg], File[$_nginx_dirs] ],
    notify  => Service[$nginx_svc]
  }

  file { 'create nginx conf.d config':
    ensure  => file,
    path    => "${nginx_confdir}/conf.d/default.conf",
    source  => 'puppet:///modules/nginx/default.conf',
    require => [ Package[$nginx_pkg], File[$_nginx_dirs] ],
    notify  => Service[$nginx_svc]
  }

  file { 'create nginx html index':
    ensure  => file,
    path    => "${www_docroot}/html/index.html",
    source  => 'puppet:///modules/nginx/index.html',
    require => [ Package[$nginx_pkg], File[$_nginx_dirs] ],
    notify  => Service[$nginx_svc]
  }

  service { $nginx_svc:
    ensure    => running,
    enable    => true,
    subscribe => File['create nginx config']
  }
}
