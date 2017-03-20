class gogs {

    exec { 'deploy_gogs':
        command   => '/etc/puppet/modules/gogs/files/gogs_deploy.sh',
        user      => root,
        group     => root,
        path      => '/sbin:/bin:/usr/sbin:/usr/bin',
        cwd       => '/mnt/git/',
        tries     => 2,
        try_sleep => 10,
        notify    => Service['gogs'],
    }

    file { ['/mnt/log/gogs', '/var/log/gogs', '/mnt/git/gogs/custom', '/mnt/git/gogs/custom/conf']:
        ensure    => directory,
        owner     => git,
        group     => git,
        mode      => 750,
        require   => Exec['deploy_gogs'],
        notify    => Service['gogs'],
    }

    exec { 'copy_logs':
        command   => 'rsync -havP /var/log/gogs/ /mnt/log/gogs/',
        user      => root,
        group     => root,
        path      => '/sbin:/bin:/usr/sbin:/usr/bin',
        tries     => 2,
        try_sleep => 10,
        require   => File['/var/log/gogs'],
    }

    file { '/etc/init.d/gogs':
        owner     => root,
        group     => root,
        mode      => 755,
        source    => "puppet:///modules/gogs/gogs",
        notify    => Service['gogs'],
    }

    file { '/etc/logrotate.d/gogs':
        owner     => root,
        group     => root,
        mode      => 640,
        source    => "puppet:///modules/gogs/gogs.logrotate",
    }

    service { 'gogs':
        ensure     => running,
        enable     => false, # becuase NFS needs mounted first on boot
        hasrestart => true,
        hasstatus  => true,
        require    => File['/etc/init.d/gogs'],
    }

}
