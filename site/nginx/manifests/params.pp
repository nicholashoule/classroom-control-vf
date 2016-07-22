ass nginx::params {
  case $::osfamily {
    'RedHat': {
       $package       = 'nginx'
       $nginx_user    = 'root'
       $nginx_group   = 'root'
       $httpd_docroot = '/var/www/html'
    }
    'Debian': {
       $package       = 'nginx'
       $httpd_user    = 'www-data'
       $httpd_group   = 'www-data'
       $httpd_docroot = '/var/www'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::osfamily}")
    }
  }
}
