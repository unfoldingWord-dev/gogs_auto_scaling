# Base class for all servers
node default {
    include sysctl

    #include users git 2024
    #include nginx simple 80 ->443
    #include runpuppet
    #include postfix
    #include opsview
    #include usrlocalsbin
    #include miscpkgs
    #include repos::nagios_plugins
    #include s3backup
    #include torrent
    #include tor
    #include btsync # if included needs user and root directory. see sp.door43.org
    #include gogs
}

# Necessasry override for newer puppet versions
Package {  allow_virtual => true, }
