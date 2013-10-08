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
    docroot_owner => $user,
    docroot_group => $user,
    default_mods => false
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
    require => Exec['install_passenger']
  }

}
