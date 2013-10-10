# database
$root_password = 'hogehoge'
#server
$port = 80
$host = 'redmine.kawaz.org'

################
# Redmine      #
################
$redmine_user = 'redmine'
$redmine_home = "/home/$redmine_user"
$redmine_user_password = 'hogehoge'

# Ruby
$redmine_ruby_version = '1.9.3-p448'
$redmine_ruby_path = "$redmine_home/.rbenv/shims"

$redmine_db_name = 'db_redmine'
$redmine_db_username = 'redmine_user'
$redmine_db_password = 'hogehoge'

$redmine_version = "2.3.3"
$redmine_url = "http://rubyforge.org/frs/download.php/77138/redmine-${redmine_version}.tar.gz"
$redminedir = "$redmine_home/redmine-$redmine_version"

##############
# GitLab     #
##############



$default_pathes = ['/bin', '/usr/bin', $redmine_ruby_path]
