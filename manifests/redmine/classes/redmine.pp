class redmine {
  require redmine::ruby
  require redmine::install
  require redmine::setup

  Class['redmine::ruby'] 
  -> Class['redmine::install'] 
  -> Class['redmine::setup']
}

class redmine::ruby {
  require redmine::ruby::setup
  require redmine::ruby::rehash

  Class['redmine::ruby::setup'] ~> Class['redmine::ruby::rehash']

}

class redmine::ruby::setup {

  rbenv::install { $redmine_user: }

  rbenv::compile {
    $redmine_ruby_version:
      user => $redmine_user,
      global => true
  }
   
  Rbenv::Gem {
    user => $redmine_user,
    ruby => $redmine_ruby_version,
  }

  rbenv::gem {
    [
      'passenger'
    ]:
  }
   
  file { "$redmine_home/.bashrc":
      content => template('bashrc'),
      owner => $redmine_user,
      mode => 644;
  }

}

class redmine::ruby::rehash {

  exec {'rehash':
    user => $redmine_user,
    cwd => $redmine_home,
    path => ['/bin', '/usr/bin', "$redmine_home/.rbenv/bin"],
    environment => ["HOME=$redmine_home"],
    command => 'rbenv rehash'
  }

}

class redmine::install {
  exec { 'fetch_redmine':
    user => $redmine_user,
    cwd => $redmine_home,
    path => ['/usr/bin'],
    command => "wget ${redmine_url}",
    creates => "$redmine_home/redmine-${redmine_version}.tar.gz",
    require => Class['user']
  }

  exec { 'expand_redmine':
    user => $redmine_user,
    cwd => $redmine_home,
    path => ['/bin'],
    command => "tar zxvf redmine-${redmine_version}.tar.gz",
    creates => $redminedir,
    require => Exec["fetch_redmine"]
  }

  file { $redminedir:
    ensure => 'directory',
    owner => $redmine_user,
    group => $redmine_user,
    mode => '0755',
    recurse => true,
    require => Exec['expand_redmine']
  }
}


class redmine::setup {
  file { "${redminedir}/config/database.yml":
    ensure => 'present',
    content => template('database.yml.erb')
  }
  
  exec { "bundle_install":
    user => $redmine_user,
    cwd => $redminedir,
    path => [$redmine_ruby_path, '/bin', '/usr/bin', '/usr/lib/mysql'],
    command => "bundle install",
    require => [File["${redminedir}/config/database.yml"], 
                Class['redmine::ruby::setup'],
                Class['package::install']
    ],
  }

  exec { 'create_secret_token':
    user => $redmine_user,
    cwd => $redminedir,
    path => [$redmine_ruby_path, '/bin', '/usr/bin'],
    environment => ["HOME=$redmine_home"],
    command => "bundle exec rake generate_secret_token",
    require => Exec['bundle_install']
  }

  exec { 'db:migrate':
    user => $redmine_user,
    cwd => $redminedir,
    path => [$redmine_ruby_path, '/bin', '/usr/bin'],
    environment => ['RAILS_ENV=production', "HOME=$redmine_home"],
    command => "bundle exec rake db:migrate",
    require => Exec['create_secret_token']
  }

  file { "$redminedir/plugins":
    ensure => 'directory'
  }

}

class redmine::restart {
  file {"$redminedir/tmp/restart.txt":
    present => true,
    subscribe => Class['plugin::bundle']
  }
}
