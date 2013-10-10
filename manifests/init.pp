import 'classes/*'

class kawaz_development {
  include iptables

  iptables::allow { 'tcp/80': port => '80', protocol => 'tcp' }

  Class['package::install'] 
  -> Class['user'] 
  -> Class['database'] 
  -> Class['redmine']
  -> Class['server']
  -> Class['plugin']

  include package::install
  include user
  include database
  include redmine
  include server
  include plugin
}

class { 'kawaz_development': }
