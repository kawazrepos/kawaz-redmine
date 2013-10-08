import 'classes/*'

class kawaz_redmine {
  include package::install
  include user
  include ruby
  include database
  include redmine

  Class['package::install'] 
  -> Class['user'] 
  -> Class['ruby'] 
  -> Class['database'] 
  -> Class['redmine']

}

class { 'kawaz_redmine': }
