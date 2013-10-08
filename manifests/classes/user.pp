class user {
  user { $user:
    ensure     => present,
    comment    => $user,
    home       => $home,
    managehome => true,
    shell      => '/bin/bash'
  }
}
