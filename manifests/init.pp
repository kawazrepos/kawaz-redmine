import 'classes/*'

class kawaz_redmine {
  include package::install
  include user
  include ruby
  include database
  include redmine
  include server
  include iptables

  iptables::allow { 'tcp/80': port => '80', protocol => 'tcp' }

  Class['package::install'] 
  -> Class['user'] 
  -> Class['ruby'] 
  -> Class['database'] 
  -> Class['redmine']
  -> Class['server']

}

class { 'kawaz_redmine': }
