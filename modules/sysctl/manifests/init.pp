class sysctl {

    file { '/etc/sysctl.d/60-dcs.conf':
        owner   => root,
        group   => root,
        mode    => 444,
        source  => "puppet:///modules/sysctl/60-dcs.conf",
        notify  => Exec['sysctl'],
    }

    exec { 'sysctl':
        command     => '/sbin/sysctl -p /etc/sysctl.d/60-dcs.conf',
        refreshonly => true,
        user        => root,
        group       => root,
    }

}
