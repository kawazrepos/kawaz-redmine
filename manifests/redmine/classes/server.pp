class server {
  
  Class['server::setup'] 
  -> Class['server::module']

  require server::setup
  require server::permission
  require server::module
}

class server::setup {

  class { 'apache':
    default_mods => false,
    default_vhost => false,
    service_enable => true
  }

  apache::vhost { 'redmine.kawaz.org':
    port    => '80',
    docroot => "$redminedir/public",
    docroot_owner => $redmine_user,
    docroot_group => $redmine_user,
    priority => 1
  }
 
}

class server::permission {
  file { $redmine_home:
    owner => $redmine_user,
    group => $redmine_user,
    mode => '755'
  }
}

class server::module {
  exec { 'install_passenger':
    user => $redmine_user,
    cwd => $redmine_home,
    path => [$redmine_ruby_path, '/usr/bin', '/bin'],
    environment => ["HOME=$redmine_home"],
    command => "passenger-install-apache2-module -a",
    require => Class['server::setup'],
  }

  exec { 'get_snippet':
    user => 'root',
    cwd => $redmine_home,
    path => [$redmine_ruby_path, '/usr/bin', '/bin'],
    environment => ["HOME=$redmine_home"],
    command => "passenger-install-apache2-module --snippet > /etc/httpd/conf.d/passenger.conf",
    notify => Service['httpd']
  }
}

