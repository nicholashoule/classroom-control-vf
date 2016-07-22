# class blog.pp
# 
# @Authors Nicholas Houle
# 
# Copyright 2016
class profile::blog {

	class { 'apache': }
	include '::apache::mod::php'

	::apache::vhost { 'localhost':
	  name             => '',
	  port             => '80',
	  docroot          => '/var/www/wordpress',
	  fallbackresource => '/index.php',
	}

	class { '::mysql::server': }
	class { '::mysql::bindings':
	  php_enable => true,
	}

	class { 'wordpress':
	  install_dir => '/var/www/wordpress',
	}
}