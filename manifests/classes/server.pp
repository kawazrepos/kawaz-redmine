class server {
  include server::setup
  include server::permission
  include server::module
  include server::httpd

  Class['server::setup'] 
  -> Class['server::module']
  ~> Class['server::httpd']
}

class server::setup {

  class { 'apache':
    default_mods => false,
    default_vhost => false,
    service_enable => true
  }

  apache::vhost { $host:
    port    => '80',
    docroot => "$redminedir/public",
    docroot_owner => $user,
    docroot_group => $user,
    priority => 1
  }

}

class server::permission {
  file { $home:
    recurse => true,
    owner => $user,
    group => $group,
    mode => '755'
  }
}

class server::module {
  exec { 'install_passenger':
    user => $user,
    cwd => $home,
    path => [$ruby_path, '/usr/bin', '/bin'],
    environment => ["HOME=$home"],
    command => "passenger-install-apache2-module -a",
    require => Class['server::setup']
  }

  exec { 'get_snippet':
    user => 'root',
    cwd => $home,
    path => [$ruby_path, '/usr/bin', '/bin'],
    environment => ["HOME=$home"],
    command => "passenger-install-apache2-module --snippet > /etc/httpd/conf.d/passenger.conf",
  }
}

class server::httpd {
}

