class nginx::params {

  case $facts['osfamily'] {
    'redhat' : {
      $package      = [ 'nginx', 'nginx-filesystem' ]
      $owner        = 'root'
      $group        = 'root'
      $docroot      = '/var/www'
      $confdir      = '/etc/nginx'
      $service_user = 'nginx'
    }
    'debian' : {
      $package      = 'nginx'
      $owner        = 'root'
      $group        = 'root'
      $docroot      = '/var/www'
      $confdir      = '/etc/nginx'
      $service_user = 'www-data'
    }
    default : {
      fail("Module ${module_name} is not supported on ${facts['osfamily']}")
    }
  }

}
