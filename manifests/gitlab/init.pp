import '../definitions.pp'
import 'classes/*'

class kawaz_gitlab {
  include iptables

  iptables::allow { 'tcp/8080': port => '8080', protocol => 'tcp' }

  require package::install
  require user
  require database
  require gitlab
  require server

  Class['package::install']
  -> Class['user']
  -> Class['database'] 
  -> Class['gitlab']
  -> Class['server']


}

class { 'kawaz_gitlab': }
