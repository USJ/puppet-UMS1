node 'web-common' {
    include users::web
    class { 'sudo': }
    class { 'ntp': }
    sudo::conf { '%admin': content => '%admin ALL=(ALL) ALL'}
    sudo::conf { '%usjnetadm': content => '%usjnetadm ALL=(ALL) ALL'}
    sudo::conf { '%usjwebadm': content => '%usjwebadm ALL=(ALL) ALL'}
}

# node for MyUSJ
node 'my-2.usj.edu.mo' {
    $utils = [ 'curl', 'git', 'acl', 'vim' ]
    # Make sure some useful utiliaries are present
    package {$utils:
        ensure => present,
    }

    Exec {
        path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
    }

    include apache
    include php
    include mysql
}

node 'vagrant-ubuntu-precise64' inherits 'my-2.usj.edu.mo' {
    include vagrant
}
