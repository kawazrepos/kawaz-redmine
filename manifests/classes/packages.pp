class package::install {
  package { 'libxml2-devel': }
  package { 'libxslt-devel': }
  package { 'mysql-devel': }
  package { 'ImageMagick': }
  package { 'ImageMagick-devel': }
  package { 'libcurl-devel': }
  package { 'httpd-devel': }
  package { 'apr-devel': }
  package { 'apr-util-devel': require => Package['apr-devel'] }
}
