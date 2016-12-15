class opsview {

    file { '/etc/yum.repos.d/opsivew.repo':
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/opsview/opsview.repo",
    }

    file { '/usr/local/nagios/libexec/nrpe_local/check_proc_result.sh':
        owner   => nagios,
        group   => nagios,
        mode    => 755,
        source  => "puppet:///modules/opsview/check_proc_result.sh",
    }

    file { '/usr/local/nagios/etc/nrpe_local/door43.cfg':
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/opsview/door43.cfg",
        notify  => Service['opsview-agent'],
    }

    service { "opsview-agent":
        ensure     => running,
        enable     => true,
        hasrestart => false,
        hasstatus  => true,
    }

}
