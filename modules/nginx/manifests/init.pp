class nginx {

    file { "/etc/nginx/conf.d/git.door43.org.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/nginx/git.door43.org.conf",
        notify  => Service['nginx'],
    }

    service { 'nginx':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => [ Package['nginx'], ],
    }

}
