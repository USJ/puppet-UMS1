class php {
  # Make sure php5 is present
  package {'php5':
    ensure => 'present',
  }

  package {'php-apc':
    ensure => 'present',
    require => Package['php5'],
    notify  => Service['apache2'],
  }

  package {'php-pear':
    ensure => present,
    require => Package['php5'],
  }

  # Install PHP driver for mongo
  exec { 'php-mongo-driver':
      command => 'sudo pecl install mongo',
      unless  => 'pecl info mongo',
      path    => '/usr/bin/',
      require => [ Package['apache2'], Package['php5'], Package['php-pear'] ],
      notify  => Service['apache2'],
  }

  # Enable PHP driver for mongo
  file {'mongo-driver-enable':
      ensure  => present,
      path    => '/etc/php5/conf.d/mongo-driver-enable.ini',
      owner   => 'root',
      group   => 'root',
      content => 'extension=mongo.so',
      require => [ Package['apache2'], Package['php5'] ],
      notify  => Service['apache2'],
  }

  # List php enhancers modules
  $php_enhancers = [ 'php5-intl', 'php5-mysql', 'php5-fpm' ]
  # Make sure the php enhancers are installed
  package { $php_enhancers:
    ensure  => installed,
    require => Package['php5'],
    notify  => Service['apache2'],
  }

  # Create a php config file that meets the symfony requirements
  file {'symfony-php-conf':
    ensure  => present,
    path    => '/etc/php5/conf.d/symfony-php-conf.ini',
    owner   => 'root',
    group   => 'root',
    content => template('php/symfony-php-conf.erb'),
    require => Package['php5'],
  }
}