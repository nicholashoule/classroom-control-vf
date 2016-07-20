# class skeleton.pp
# 
# @Authors Nicholas Houle
# 
# Copyright 2016
class skeleton (){

  file { 'createDir skel':
    ensure => directory,
    path   => '/etc/skel'
  }

  file { 'create skel':
    ensure  => file,
    path    => '/etc/skel/.bashrc',
    source  => 'puppet:///modules/skeleton/.bashrc',
    require => File['createDir skel']
  }
}
