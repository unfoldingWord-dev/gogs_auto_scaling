class gogs {

    exec { 'deploy_gogs':
        command   => '/mnt/puppet/modules/gogs/files/gogs_deploy.sh',
        user      => root,
        group     => root,
        path      => '/sbin:/bin:/usr/sbin:/usr/bin',
        cwd       => '/mnt/git/',
        tries     => 2,
        try_sleep => 10,
    }

    file { ['/mnt/log/gogs', '/mnt/git/gogs/custom', '/mnt/git/gogs/custom/conf']:
        ensure    => directory,
        owner     => git,
        group     => git,
        mode      => 750,
        require   => Exec['deploy_gogs'],
    }

    file { '/etc/init.d/gogs':
        owner     => root,
        group     => root,
        mode      => 755,
        source    => "puppet:///modules/gogs/gogs",
    }

    file { '/etc/logrotate.d/gogs':
        owner     => root,
        group     => root,
        mode      => 640,
        source    => "puppet:///modules/gogs/gogs.logrotate",
    }

    service { 'gogs':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => File['/etc/init.d/gogs.conf'],
    }

}
