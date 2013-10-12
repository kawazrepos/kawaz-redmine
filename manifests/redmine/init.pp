import '../definitions.pp'
import 'classes/*'

class kawaz_redmine {
  require iptables

  iptables::allow { 'tcp/80': port => '80', protocol => 'tcp' }

  Class['package::install'] 
  -> Class['user'] 
  -> Class['database'] 
  -> Class['redmine']
  -> Class['server']
  -> Class['plugin']

  require package::install
  require user
  require database
  require redmine
  require server
  require plugin
}

class { 'kawaz_redmine': }
