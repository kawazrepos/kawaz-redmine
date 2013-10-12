class database {
  Class['database::setup'] -> Class['database::create']

  require database::setup
  require database::create
}

class database::setup {
  class { '::mysql::server':
    override_options => { 
      'mysqld' => { 'character-set-server' => 'utf8' },
      'mysql' => { 'default-character-set' => 'utf8' } 
    },
    root_password => $root_password
  }
}

class database::create {
  mysql::db { $redmine_db_name:
    user     => $redmine_db_username,
    password => $redmine_db_password,
    host     => 'localhost',
    grant    => ['ALL'],
  }
}


