class plugin {
  include plugin::install
  include plugin::bundle

  Class['plugin::install'] 
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
    user => $user,
    cwd => "$redminedir/plugins",
    path => $default_pathes,
    command => "git clone https://github.com/ncoders/redmine_local_avatars.git",
    created => File["$redminedir/plugins/redmine_local_avatars"]
  }
}

class plugin::install::redmine_git_hosting {
  exec {'install_redmine_git_hosting':
    user => $user,
    cwd => "$redminedir/plugins",
    path => $default_pathes,
    command => "git clone https://github.com/jbox-web/redmine_git_hosting.git",
    created => File["$redminedir/plugins/redmine_git_hosting"]
  }
}

class plugin::install::redmine_code_review {
  exec {'install_redmine_code_review':
    user => $user,
    cwd => "$redminedir/plugins",
    path => $default_pathes,
    command => "hg clone https://bitbucket.org/haru_iida/redmine_code_review",
    created => File["$redminedir/plugins/redmine_code_review"]
  }
}

class plugin::install::redmine_github_hook {
  exec {'install_redmine_github_hook':
    user => $user,
    cwd => "$redminedir/plugins",
    path => $default_pathes,
    command => "git clone https://github.com/koppen/redmine_github_hook.git",
    created => File["$redminedir/plugins/redmine_github_hook"]
  }
}

class plugin::bundle {
  exec {'plugin::bundle':
    user => $user,
    cwd => "$redminedir",
    path => $default_pathes,
    environment => ['RAILS_ENV=production'],
    command => "bundle install;rake redmine:plugins:migrate",
  }

}
