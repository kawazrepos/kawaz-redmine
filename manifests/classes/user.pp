class user {
  user { $user:
    ensure     => present,
    comment    => $user,
    home       => $home,
    password   => sha1($user_password),
    managehome => true,
    shell      => '/bin/bash'
  }
}
