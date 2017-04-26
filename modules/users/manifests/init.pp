class users {

    user { "git":
        comment  => "",
        home     => "/home/git",
        shell    => "/bin/bash",
        uid      => 2024,
        gid      => 2024,
        password => '',
        require  => [ Group['git'] ]
    }

    group { "git":
        gid     => 2024
    }

}
