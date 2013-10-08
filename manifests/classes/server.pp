class server {
  include server::setup
  include server::module

  Class['server::setup'] -> Class['server::module']
}

class server::setup {

  apache::vhost { $host:
    port    => '80',
    docroot => "$redminedir/public",
  }

}

class server::module {
  exec {
    user => $user,
    pwd => $home,
    path => [$ruby_path, '/usr/bin', '/bin'],
    environment => ["HOME=$home"],
    command => "passenger-install-apache2-module"
    require => Class['server::setup']
  }
}
