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

  apache::vhost { 'gitlab.kawaz.org':
    port    => '8080',
    docroot => "$gitlabdir/public",
    docroot_owner => $gitlab_user,
    docroot_group => $gitlab_user,
    priority => 1
  }
 
}

class server::permission {
  file { $gitlab_home:
    owner => $gitbal_user,
    group => $gitlab_user,
    mode => '755'
  }
}

class server::module {
  exec { 'install_passenger':
    user => $gitlab_user,
    cwd => $gitlab_home,
    path => [$gitlab_ruby_path, '/usr/bin', '/bin'],
    environment => ["HOME=$gitlab_home"],
    command => "passenger-install-apache2-module -a",
    require => [Class['server::setup'], Class['gitlab::restart']]
  }

  exec { 'get_snippet':
    user => 'root',
    cwd => $gitlab_home,
    path => [$gitlab_ruby_path, '/usr/bin', '/bin'],
    environment => ["HOME=$gitlab_home"],
    command => "passenger-install-apache2-module --snippet > /etc/httpd/conf.d/passenger.conf",
    notify => Service['httpd'],
    require => Exec['install_passenger']
  }
}

