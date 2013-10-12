class database {
  class { '::mysql::server':
    override_options => { 
      'mysqld' => { 'character-set-server' => 'utf8' },
      'mysql' => { 'default-character-set' => 'utf8' } 
    },
    root_password => $root_password
  }

  mysql::db { $gitlab_db_name:
    user     => $gitlab_db_username,
    password => $gitlab_db_password,
    host     => 'localhost',
    grant    => ['ALL']
  }
}
