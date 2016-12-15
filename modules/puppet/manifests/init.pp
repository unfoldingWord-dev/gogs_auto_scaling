class puppet {

    file { '/etc/cron.d/runpuppet':
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/cron/runpuppet",
    }

    tidy { '/var/lib/puppet/reports/':
        age     => '7d',
        backup  => false,
        rmdirs  => false,
        recurse => true,
        type    => mtime,
    }

}
