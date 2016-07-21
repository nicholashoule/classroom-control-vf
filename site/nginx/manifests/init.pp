# class nginx.pp
# 
# @Authors Nicholas Houle
# 
# Copyright 2016
class nginx (){

  package { 'nginx':
    ensure => latest,
  }

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { 'createDir nginx':
    ensure => directory,
    path   => [ '/etc/nginx', '/var/www', '/var/www/html' ],
  }

  file { 'create nginx config':
    ensure  => file,
    path    => '/etc/nginx/nginx.conf',
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => [ Package['nginx'], File['createDir nginx'] ],
    notify  => Service['nginx']
  }

  file { 'create nginx conf.d config':
    ensure  => file,
    path    => '/etc/nginx/conf.d/default.conf',
    source  => 'puppet:///modules/nginx/default.conf',
    require => [ Package['nginx'], File['createDir nginx'] ],
    notify  => Service['nginx']
  }

  file { 'create nginx html index':
    ensure  => file,
    path    => '/var/www/html/index.html',
    source  => 'puppet:///modules/nginx/index.html',
    require => [ Package['nginx'], File['createDir nginx'] ],
    notify  => Service['nginx']
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File['create nginx config']
  }
}
