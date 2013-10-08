class database {
  include database::setup
  include database::create

  Class['database::setup'] -> Class['database::create']
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
  mysql::db { $db_name:
    user     => $username,
    password => $password,
    host     => 'localhost',
    grant    => ['ALL'],
  }
}


