class users {

    user { "git":
        comment  => "help@doo43.org",
        home     => "/mnt/git",
        shell    => "/bin/bash",
        uid      => 2024,
        gid      => 2024,
        password => '',
        require  => [ Group['git'] ]
    }

    group { "git":
        gid     => 2024
    }

    file { '/home/git':
        ensure  => link,
        target  => '/mnt/git',
        require  => [ User['git'] ]
    }

}
