class puppet {

    file { '/etc/cron.d/runpuppet':
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/puppet/runpuppet",
    }

    file { '/etc/motd':
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/puppet/motd",
    }

    tidy { '/var/lib/puppet/reports/':
        age     => '7d',
        backup  => false,
        rmdirs  => false,
        recurse => true,
        type    => mtime,
    }

}
