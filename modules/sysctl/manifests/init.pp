class sysctl {

    file { '/etc/sysctl.conf':
        owner   => root,
        group   => root,
        mode    => 444,
        source  => "puppet:///modules/sysctl/sysctl.conf",
        notify  => Exec['sysctl'],
    }

    exec { 'sysctl':
        command     => '/sbin/sysctl -p',
        refreshonly => true,
        user        => root,
        group       => root,
    }

}
