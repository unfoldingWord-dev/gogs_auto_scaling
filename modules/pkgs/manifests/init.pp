class pkgs {

    package { git: ensure  => present }
    package { puppet: ensure  => present }
    package { rsync: ensure  => present }
    package { screen: ensure  => present }
    package { telnet: ensure  => present }
    package { wget: ensure  => present }
    package { mysql: ensure  => present }
    package { nfs-utils: ensure  => present }
    package { nginx: ensure  => present }
    #package { s3cmd: ensure  => present }
    #package { iftop: ensure  => present }
    package { tmux: ensure => present }
    package { 'vim-enhanced': ensure  => present }
    #package { 'ruby-shadow': ensure => present }

    file { '/etc/tmux.conf':
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/pkgs/tmux.conf",
        require => Package['tmux'],
    }

}
