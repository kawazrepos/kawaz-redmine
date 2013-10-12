class user {
  user { $redmine_user:
    ensure     => present,
    comment    => $redmine_user,
    home       => $redmine_home,
    managehome => true,
    shell      => '/bin/bash'
  }
}
