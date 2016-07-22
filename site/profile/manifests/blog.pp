# class blog.pp
# 
# @Authors Nicholas Houle
# 
# Copyright 2016
class profile::blog {

	class { 'apache': }
	include '::apache::mod::php'

	::apache::vhost { 'localhost':
	  port             => '80',
	  docroot          => '/var/www/wordpress',
	}

	class { '::mysql::server': }
	class { '::mysql::bindings':
	  php_enable => true,
	}

	class { 'wordpress':
	  install_dir => '/var/www/wordpress',
	}
}