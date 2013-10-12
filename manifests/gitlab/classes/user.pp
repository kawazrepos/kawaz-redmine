class user {
  user { $gitlab_user:
    ensure     => present,
    comment    => $gitlab_user,
    home       => $gitlab_home,
    managehome => true,
    shell      => '/bin/bash'
  }
}
