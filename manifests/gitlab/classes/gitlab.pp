class gitlab {
  Class['gitlab::ruby']
  ->Class['gitlab::shell']
  ->Class['gitlab::repository']
  ->Class['gitlab::install']
  ->Class['gitlab::configure']
  ->Class['gitlab::setup']
  ->Class['gitlab::restart']

  require gitlab::ruby
  require gitlab::shell
  require gitlab::repository
  require gitlab::install
  require gitlab::configure
  require gitlab::setup
  require gitlab::restart
}

class gitlab::ruby {
  Class['gitlab::ruby::setup']
  ~> Class['gitlab::ruby::rehash']

  require gitlab::ruby::setup
  require gitlab::ruby::rehash
}

class gitlab::ruby::setup {
  rbenv::install { $gitlab_user: }

  rbenv::compile {
    $gitlab_ruby_version:
      user => $gitlab_user,
      global => true
  }

  Rbenv::Gem {
    user => $gitlab_user,
    ruby => $gitlab_ruby_version,
  }

  rbenv::gem {
    [
      'passenger'
    ]:
  }

  file { "$gitlab_home/.bashrc":
    ensure => 'present',
    content => template('bashrc'),
    owner => $gitlab_user,
    mode => 644,
    require => Class['user']
  }

}

class gitlab::ruby::rehash {
  exec {'rehash':
    user => $gitlab_user,
    cwd => $gitlab_home,
    path => ['/bin', '/usr/bin', "$gitlab_home/.rbenv/bin"],
    environment => ["HOME=$gitlab_home"],
    command => 'rbenv rehash',
    require => Class['gitlab::ruby::setup']
  }
}


class gitlab::shell {
  
  exec { 'gitlab-shell::clone':
    user => $gitlab_user,
    cwd  => $gitlab_home,
    path => ['/bin', '/usr/bin', $gitlab_ruby_path],
    command => 'git clone https://github.com/gitlabhq/gitlab-shell.git',
    creates => "$gitlab_home/gitlab-shell",
    require => Class['gitlab::ruby::setup']
  }

  exec { 'gitlab-shell::version':
    user => $gitlab_user,
    cwd  => "$gitlab_home/gitlab-shell",
    path => ['/bin', '/usr/bin', $gitlab_ruby_path],
    command => 'git checkout v1.7.1',
    require => Exec['gitlab-shell::clone']
  }

  file { "$gitlab_home/gitlab-shell/config.yml":
    ensure => 'present',
    owner => $gitlab_user,
    content => template('config.yml.erb'),
    require => Exec['gitlab-shell::version']
  }

  exec { 'gitlab-shell::install':
    user => $gitlab_user,
    cwd => "$gitlab_home/gitlab-shell",
    path => ['/bin', '/usr/bin', $gitlab_ruby_path],
    command => "$gitlab_ruby_path/ruby bin/install",
    require => File["$gitlab_home/gitlab-shell/config.yml"]
  }

}

class gitlab::repository {
  file { "$gitlab_home/repositories":
    ensure => 'directory',
    owner => $gitlab_user,
    group => $gitlab_user
  }
}

class gitlab::install {
  exec { 'gitlab::clone':
    user => $gitlab_user,
    cwd  => $gitlab_home,
    path => ['/bin', '/usr/bin', $gitlab_ruby_path],
    command => 'git clone https://github.com/gitlabhq/gitlabhq.git gitlab',
    creates => "$gitlab_home/gitlab",
    require => Class['gitlab::shell']
  }

  exec { 'gitlab::version':
    user => $gitlab_user,
    cwd  => "$gitlab_home/gitlab",
    path => ['/bin', '/usr/bin', $gitlab_ruby_path],
    command => 'git checkout 6-1-stable',
    require => Exec['gitlab::clone']
  }

}

class gitlab::configure {
  file { "$gitlabdir/config/gitlab.yml":
    ensure => 'present',
    owner => $gitlab_user,
    group => $gitlab_user,
    content => template('gitlab.yml.erb'),
    require => Class['gitlab::install']
  }

  file { "$gitlabdir/log":
    ensure => 'directory',
    owner => $gitlab_user,
    mode => '755'
  }

  file { "$gitlabdir/tmp":
    ensure => 'directory',
    owner => $gitlab_user,
    mode => '755'
  }

  file { "$gitlabdir/tmp/pids":
    ensure => 'directory',
    owner => $gitlab_user,
    mode => '755'
  }

  file { "$gitlabdir/tmp/sockets":
    ensure => 'directory',
    owner => $gitlab_user,
    mode => '755'
  }

  file { "$gitlabdir/config/database.yml":
    ensure => 'present',
    owner => $gitlab_user,
    mode => '600',
    content => template('database_gitlab.yml.erb')
  }
}

class gitlab::setup {
  exec { 'gitlab::setup::bundle_install':
    user => $gitlab_user,
    cwd  => $gitlabdir,
    path => ['/bin', '/usr/bin', $gitlab_ruby_path],
    environment => ["HOME=$gitlab_home"],
    command => "bundle install --deployment --without development test postgres aws",
    timeout     => 1800,
    require => Class['gitlab::configure']
  }

  # exec { 'gitlab::setup::setup':
  #   user => $gitlab_user,
  #   cwd => $gitlabdir,
  #   path => ['/bin', '/usr/bin', $gitlab_ruby_path],
  #   environment => ["HOME=$gitlab_home", "RAILS_ENV=production"],
  #   command => 'yes | bundle exec rake gitlab:setup',
  #   require => Exec['gitlab::setup::bundle_install']
  # }

}

class gitlab::restart {
  exec { 'gitlab::restart::script':
    user => 'root',
    cwd => $gitlabdir,
    path => ['/bin', '/usr/bin', $gitlab_ruby_path],
    environment => ["HOME=$gitlab_home", "RAILS_ENV=production"],
    command => 'cp lib/support/init.d/gitlab /etc/init.d/gitlab',
    require => Class['gitlab::setup']
  }

  exec { 'gitlab::restart::script::mod':
    user => 'root',
    cwd => $gitlabdir,
    path => ['/bin', '/usr/bin', $gitlab_ruby_path],
    environment => ["HOME=$gitlab_home", "RAILS_ENV=production"],
    command => 'chmod +x /etc/init.d/gitlab',
    require => Exec['gitlab::restart::script']
  }

  # exec { 'gitlab::restart':
  #   user => 'root',
  #   cwd => $gitlabdir,
  #   path => ['/bin', '/usr/bin', $gitlab_ruby_path],
  #   environment => ["HOME=$gitlab_home", "RAILS_ENV=production"],
  #   command => '/etc/init.d/gitlab restart',
  #   require => Exec['gitlab::restart::script::mod']
  # }

}
