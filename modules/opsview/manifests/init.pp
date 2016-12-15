class opsview {

    file { '/etc/yum.repos.d/opsview.repo':
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/opsview/opsview.repo",
    }

    package { 'opsview-agent':
        ensure => present,
        require => File['/etc/yum.repos.d/opsview.repo'],
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

    exec { 'nagios_plugins':
        command    => '/usr/bin/git clone $remote https://github.com/unfoldingWord-dev/nagios_plugins.git /usr/local/nagios/libexec/nrpe_local',
        creates   => "/usr/local/nagios/libexec/nrpe_local.git",
        user      => nagios,
        group     => nagios,
        tries     => 2,
        timeout   => 600,
        require   => [ Package['git'], Package['opsview-agent'] ],
    }

    service { "opsview-agent":
        ensure     => running,
        enable     => true,
        hasrestart => false,
        hasstatus  => true,
    }

}
