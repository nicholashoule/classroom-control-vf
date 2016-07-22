# class blog.pp
# 
# @Authors Nicholas Houle
# 
# Copyright 2016
class profile::blog {

	class { 'apache': }
	include '::apache::mod::php'

	::apache::vhost { '54.191.160.21':
	  port             => '80',
	  docroot          => '/var/www/wordpress',
	  fallbackresource => '/index.php',
	  ip_based         => true,
	}

	class { '::mysql::server': }
	class { '::mysql::bindings':
	  php_enable => true,
	}

	class { 'wordpress':
	  install_dir => '/var/www/wordpress',
	}
}