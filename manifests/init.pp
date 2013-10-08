import 'classes/*'

class kawaz_redmine {
  include user
  include ruby
  include database
  include redmine

  Class['user'] -> Class['ruby'] -> Class['database'] -> Class['redmine']

}

class { 'kawaz_redmine': }
