class ruby {
  include ruby::setup
  include ruby::rehash

  Class['ruby::setup'] ~> Class['ruby::rehash']

}

class ruby::setup {

  rbenv::install { $user : }

  rbenv::compile {
    $ruby_version:
      user => $user,
      global => true
  }
   
  Rbenv::Gem {
    user => $user,
    ruby => $ruby_version,
  }

  rbenv::gem {
    [
      'passenger'
    ]:
  }
   
  file {
    "$home/.bash_profile":
      content => template('bash_profile'),
      owner => $user,
      mode => 644;
  }

}

class ruby::rehash {

  exec {'rehash':
    user => $user,
    cwd => $home,
    path => ['/bin', '/usr/bin', "$home/.rbenv/bin"],
    environment => ["HOME=$home"],
    command => 'rbenv rehash'
  }

}
