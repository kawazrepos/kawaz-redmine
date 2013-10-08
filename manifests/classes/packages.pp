class package::install {
  package { 'libxml2-devel': }
  package { 'libxslt-devel': }
  package { 'mysql-devel': }
  package { 'libjpeg-devel': }
  package { 'libpng-devel': }
  package { 'ImageMagick': 
    require => [Package['libjpeg-devel'], Package['libpng-devel']]
  }
  package { 'ImageMagick-devel': 
    require => [Package['libjpeg-devel'], Package['libpng-devel']]
  }
  package { 'curl-devel': }
}
