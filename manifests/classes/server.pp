class server {
  include server::setup
  include server::module

  Class['server::setup'] -> Class['server::module']
}

class server::setup {
  include apache

  apache::vhost { $host:
    port    => '80',
    docroot => "$redminedir/public",
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
}
