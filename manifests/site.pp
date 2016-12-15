# Base class for all servers
node default {
    include sysctl
    include users
    include nginx
    include puppet
    include opsview
    include pkgs
    #include s3backup
    #include btsync # if included needs user and root directory. see sp.door43.org
    #include gogs
}
