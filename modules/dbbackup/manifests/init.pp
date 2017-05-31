class dbbackup {

    file { '/etc/dbbackup.conf':
        owner   => root,
        group   => root,
        mode    => 600,
        ensure  => present,
        source  => "puppet:///modules/dbbackup/dbbackup.conf",
    }

    file { '/etc/cron.daily/dbbackup':
        owner   => root,
        group   => root,
        mode    => 755,
        source  => "puppet:///modules/dbbackup/dbbackup",
        require => File['/etc/dbbackup.conf'],
    }

}
