class mysql {
  # Make sure mysql is present
  package {'mysql-server':
    ensure => 'present',
  }

  service {'mysql':
    ensure  => running,
    # Make sure mysql-server is installed before checking
    require => Package['mysql-server'],
  }

  # Create ums db
  exec {'create-ums-db':
    unless  => '/usr/bin/mysql -uroot ums',
    command => '/usr/bin/mysql -uroot -e "create database ums;"',
    require => Service['mysql'],
  }


  # Create ums user and grant access
  exec {'create-grant-ums-user':
    unless  => '/usr/bin/mysql -uums -pums ums',
    command => "/usr/bin/mysql -uroot -e \"
      use mysql;
      CREATE USER 'ums'@'localhost' IDENTIFIED BY PASSWORD '67ff3d8b3ef0f17d';
      GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE ON *.* TO 'ums'@'localhost';
      \"",
    require => [ Service['mysql'], Exec['create-ums-db'] ],
  }

  # Create moodle user and grant access
  exec {'create-grant-moodle-user':
    unless  => '/usr/bin/mysql -umoodle -pm00dl3',
    command => "/usr/bin/mysql -uroot -e \"
      use mysql;
      CREATE USER 'moodle'@'localhost' IDENTIFIED BY PASSWORD '4bd0c65e72f189e8';
      CREATE USER 'moodle'@'172.26.1.71' IDENTIFIED BY PASSWORD '4bd0c65e72f189e8';
      GRANT SELECT ON ums.* TO 'moodle'@'172.26.1.71';
      CREATE USER 'moodle'@'172.26.1.61' IDENTIFIED BY PASSWORD '4bd0c65e72f189e8';
      GRANT SELECT ON ums.* TO 'moodle'@'172.26.1.61';
      \"",
    require => [ Service['mysql'], Exec['create-ums-db'] ],
  }

  # Create a virtual host file for our website
  # file {'mysql-conf':
  #   ensure  => present,
  #   path    => '/etc/mysql/my.cnf',
  #   owner   => 'root',
  #   group   => 'root',
  #   content => template('mysql/my.cnf.erb'),
  #   # Make sure apache is installed before creating the file
  #   require => Package['mysql-server'],
  #   notify  => Service['mysql-server'],
  # }
}