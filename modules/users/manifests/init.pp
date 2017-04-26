class users {

    exec { 'create_git_home':
        command   => 'mkdir /home/git',
        onlyif    => 'test ! -d /home/git/',
        user      => root,
        group     => root,
        path      => '/sbin:/bin:/usr/sbin:/usr/bin',
    }

    user { "git":
        comment  => "",
        home     => "/home/git",
        shell    => "/bin/bash",
        uid      => 2024,
        gid      => 2024,
        password => '',
        require  => [ Group['git'], Exec['create_git_home'] ]
    }

    group { "git":
        gid     => 2024
    }

}
