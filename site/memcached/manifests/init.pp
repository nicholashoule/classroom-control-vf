# class memcached.pp
# 
# @Authors Nicholas Houle
# 
# Copyright 2016
class memcached (){

  package { 'memcached':
    ensure => latest,
    before => File['create config']
  }

  file { 'create config':
    ensure  => file,
    path    => '/etc/sysconfig/memcached',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['memcached'],
    notify  => Service['memcached']
  }

  service { 'memcached':
    ensure    => running,
    enable    => true,
    subscribe => File['create config']
  }
}
