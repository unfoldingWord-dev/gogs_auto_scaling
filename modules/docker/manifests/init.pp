class docker {

    service { 'docker':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => [ Package['docker'], ],
    }

}
