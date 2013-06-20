class vagrant {
    exec { 'apache_lockfile_permissions':
        command => 'chown -R vagrant:www-data /var/lock/apache2',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }
}