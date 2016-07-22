# class blog.pp
# 
# @Authors Nicholas Houle
# 
# Copyright 2016
class profile::blog {

	class { 'apache':
  		mpm_module => 'prefork',
	}
	
	include '::apache::mod::php'

	::apache::vhost { '54.191.160.21':
	  ip               => '54.191.160.21',
	  port             => '80',
	  docroot          => '/var/www/wordpress',
	  fallbackresource => '/index.php',
	  ip_based         => true,
	}

	class { '::mysql::server':
	  root_password           => 'strongpassword',
	  remove_default_accounts => true,
	  override_options        => $override_options
	}

	class { 'wordpress':
	  install_dir => '/var/www/wordpress',
	  wp_owner    => 'wordpress',
	  wp_group    => 'wordpress',
	  db_user     => 'wordpress',
	  db_password => 'strongpassword',
	}
}