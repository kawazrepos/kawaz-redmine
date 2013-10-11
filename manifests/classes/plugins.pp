class plugin {
  include plugin::install
  include plugin::bundle

  Class['redmine']
  -> Class['plugin::install']
  -> Class['plugin::bundle']
}

class plugin::install {
  include plugin::install::redmine_git_hosting
  include plugin::install::redmine_github_hook
  include plugin::install::redmine_code_review
  include plugin::install::redmine_local_avatars
}

class plugin::install::redmine_local_avatars {
  exec {'install_redmine_local_avatars':
    user => $redmine_user,
    cwd => "$redminedir/plugins",
    path => $default_pathes,
    command => "git clone https://github.com/ncoders/redmine_local_avatars.git",
    creates => "$redminedir/plugins/redmine_local_avatars",
    require => File["$redminedir/plugins"]
  }
}

class plugin::install::redmine_git_hosting {
  exec {'install_redmine_git_hosting':
    user => $redmine_user,
    cwd => "$redminedir/plugins",
    path => $default_pathes,
    command => "git clone https://github.com/jbox-web/redmine_git_hosting.git",
    creates => "$redminedir/plugins/redmine_git_hosting",
    require => File["$redminedir/plugins"]
  }
}

class plugin::install::redmine_code_review {
  exec {'install_redmine_code_review':
    user => $redmine_user,
    cwd => "$redminedir/plugins",
    path => $default_pathes,
    command => "hg clone https://bitbucket.org/haru_iida/redmine_code_review",
    creates => "$redminedir/plugins/redmine_code_review",
    require => File["$redminedir/plugins"]
  }
}

class plugin::install::redmine_github_hook {
  exec {'install_redmine_github_hook':
    user => $redmine_user,
    cwd => "$redminedir/plugins",
    path => $default_pathes,
    command => "git clone https://github.com/koppen/redmine_github_hook.git",
    creates => "$redminedir/plugins/redmine_github_hook",
    require => File["$redminedir/plugins"]
  }
}

class plugin::bundle {
  exec {'plugin::bundle':
    user => $redmine_user,
    cwd => "$redminedir",
    path => $default_pathes,
    environment => ['RAILS_ENV=production'],
    command => "bundle install;rake redmine:plugins:migrate",
    require => Class['plugin::install']
  }

}
