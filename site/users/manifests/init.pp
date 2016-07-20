# class users.pp
# 
# @Authors Nicholas Houle
# 
# Copyright 2016
class users (){

  user { 'fundamentals':
    ensure => present,
  }

}
