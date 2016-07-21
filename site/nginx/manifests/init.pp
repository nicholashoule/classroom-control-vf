# class nginx.pp
# 
# @Authors Nicholas Houle
# 
# Copyright 2016
class nginx (){

  package { 'nginx':
    ensure => latest,
    before => File['create config']
  }

  file { 'createDir nginx':
    ensure => directory,
    path   => '/etc/nginx'
  }

  file { 'create nginx config':
    ensure  => file,
    path    => '/etc/nginx/nginx.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [ Package['nginx'], File['createDir nginx'] ],
    notify  => Service['nginx']
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File['create nginx config']
  }
}
