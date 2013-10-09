$user = 'redmine'
$home = "/home/$user"
$user_password = 'hogehoge'

# Ruby
$ruby_version = '1.9.3-p448'
$ruby_path = "$home/.rbenv/shims"

# database
$root_password = 'hogehoge' # You should change this.
$db_name = 'db_redmine'
$username = 'redmine_user'
$password = 'hogehoge'

#redmine
$redmine_version = "2.3.3"
$redmine_url = "http://rubyforge.org/frs/download.php/77138/redmine-${redmine_version}.tar.gz"
$installdir = "$home/redmine"
$redminedir = "${installdir}/redmine-${redmine_version}"

#server
$port = 80
$host = 'redmine.kawaz.org'

$default_pathes = ['/bin', '/usr/bin', $ruby_path]
