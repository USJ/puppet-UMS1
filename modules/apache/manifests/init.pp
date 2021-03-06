class apache {
  # Make sure apache is present
  package {'apache2':
    ensure => 'present',
  }

  # Make sure apache is running
  service {'apache2':
    ensure  => running,
    # Make sure apache is installed before checking
    require => Package['apache2'],
  }

  # Create the logs folder to put the log files of the vhost
  file { [ '/srv/www', '/srv/www/myusj', '/srv/www/myusj/logs', '/srv/www/myusj/public_html' ]:
    ensure => 'directory',
  }

  # Create a virtual host file for our website
  file {'myusj-vhost':
    ensure  => present,
    path    => '/etc/apache2/sites-available/myusj.conf',
    owner   => 'root',
    group   => 'root',
    content => template('apache/vhost.erb'),
    # Make sure apache is installed before creating the file
    require => [ Package['apache2'], File ['/srv/www/myusj/logs'] ],
  }

  # Enable our virtual host
  file {'myusj-vhost-enable':
    ensure  => link,
    path    => '/etc/apache2/sites-enabled/myusj.conf',
    target  => '/etc/apache2/sites-available/myusj.conf',
    # Make sure apache and the vhost file are there before symlink
    require => [ Package['apache2'], File['myusj-vhost'] ],
    # Notify apache to restart
    notify  => Service['apache2'],
  }

  # Enable mod-rewrite
  file {'/etc/apache2/mods-enabled/rewrite.load':
    ensure  => 'link',
    target  => '/etc/apache2/mods-available/rewrite.load',
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  # Replace the apache user to vagrant
  file {'apache-envvars':
    ensure  => present,
    path    => '/etc/apache2/envvars',
    owner   => 'root',
    group   => 'root',
    content => template('apache/envvars.erb'),
    require => Package['apache2'],
    notify  => Service['apache2'],
  }
}