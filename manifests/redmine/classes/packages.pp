class package::install {
  package { 'git': }
  package { 'mercurial': }
  package { 'libxml2-devel': }
  package { 'libxslt-devel': }
  package { 'mysql-devel': }
  package { 'ImageMagick': }
  package { 'ImageMagick-devel': }
  package { 'libcurl-devel': }
  package { 'httpd-devel': }
  package { 'apr-devel': }
  package { 'libicu.x86_64-devel': }
  package { 'apr-util-devel': require => Package['apr-devel'] }

  exec { 'fetch-redis':
    user => 'root',
    cwd => '/root',
    path => ['/bin', '/usr/bin'],
    command => 'wget http://redis.googlecode.com/files/redis-2.6.10.tar.gz',
    creates => '/root/redis-2.6.10.tar.gz'
  }

  exec { 'expand-redis':
    user => 'root',
    cwd => '/root',
    path => ['/bin', '/usr/bin'],
    command => 'tar xvf redis-2.6.10.tar.gz',
    creates => '/root/redis-2.6.10',
    require => Exec['fetch-redis']
  }

  exec { 'install-redis':
    user => 'root',
    cwd => '/root/redis-2.6.10',
    path => ['/bin', '/usr/bin'],
    command => 'make;make install',
    require => Exec['expand-redis']
  }

}
