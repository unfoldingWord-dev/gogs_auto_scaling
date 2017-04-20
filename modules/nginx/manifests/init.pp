class nginx {

    file { "/etc/nginx/conf.d/door43_content_service.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        content => template("nginx/door43_content_service.conf.erb"),
        notify  => Service['nginx'],
    }

    file { "/etc/nginx/nginx.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/nginx/nginx.conf",
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
