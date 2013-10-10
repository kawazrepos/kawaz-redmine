class user {
  user { $redmine_user:
    ensure     => present,
    comment    => $redmine_user,
    home       => $redmine_home,
    password   => sha1($redmine_user_password),
    managehome => true,
    shell      => '/bin/bash'
  }
}
