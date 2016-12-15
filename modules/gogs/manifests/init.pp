class gogs {

    exec { 'get-gogs':
        command   => "wget `curl -s https://api.github.com/repos/unfoldingWord-dev/gogs/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4` \
        && rm -rf gogs \
        && tar xzf linux_amd64_*.tar.gz \
        && /bin/cp -f /mnt/private/app.ini /mnt/git/gogs/custom/conf/app.ini \
        && mv linux_amd64_*.tar.gz gogs/",
        user      => root,
        group     => root,
        cwd       => '/mnt/git/',
        tries     => 2,
        try_sleep => 10,
        require   => User['git'],
    }

    file { ['/mnt/log/gogs', '/mnt/git/gogs/custom', '/mnt/git/gogs/custom/conf']:
        ensure    => directory,
        owner     => git,
        group     => git,
        mode      => 750,
        require   => Exec['get-gogs'],
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
        require    => File['/etc/init.d/gogs'],
    }

}
