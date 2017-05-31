# Base class for all servers
node default {
    include sysctl
    include users
    include nginx
    include puppet
    include opsview
    include pkgs
    include gogs
    include dbbackup
}
