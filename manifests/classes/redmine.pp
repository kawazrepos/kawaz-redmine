class redmine {
  include redmine::install
  include redmine::setup

  Class['redmine::install'] -> Class['redmine::setup']
}

class redmine::install {
  exec { 'fetch_redmine':
    user => $user,
    cwd => $installdir,
    path => ['/usr/bin'],
    command => "wget ${redmine_url}",
    creates => "$installdir/redmine-${redmine_version}.tar.gz",
    require => File[$installdir]
  }

  file { $installdir:
    ensure => 'directory',
    owner => $user,
    mode => '0755'
  }

  exec { 'expand_redmine':
    user => $user,
    cwd => $installdir,
    path => ['/bin'],
    command => "tar zxvf redmine-${redmine_version}.tar.gz",
    creates => $redminedir,
    require => Exec["fetch_redmine"]
  }

}


class redmine::setup {
  file { "${redminedir}/config/database.yml":
    ensure => 'present',
    owner => $user,
    mode => '0755',
    content => template('database.yml.erb')
  }
  
  exec { "bundle_install":
    user => $user,
    cwd => $redminedir,
    path => [$ruby_path, '/bin', '/usr/bin', '/usr/lib/mysql'],
    command => "bundle install",
    require => File["${redminedir}/config/database.yml"]
  }

  exec { 'create_secret_token':
    user => $user,
    cwd => $redminedir,
    path => [$ruby_path, '/bin', '/usr/bin'],
    environment => ["HOME=$home"],
    command => "bundle exec rake generate_secret_token",
    require => Exec['bundle_install']
  }

  exec { 'db:migrate':
    user => $user,
    cwd => $redminedir,
    path => [$ruby_path, '/bin', '/usr/bin'],
    environment => ['RAILS_ENV=production', "HOME=$home"],
    command => "bundle exec rake db:migrate",
    require => Exec['create_secret_token']
  }

}

include redmine
