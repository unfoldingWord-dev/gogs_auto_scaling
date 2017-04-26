# Door43 Content Service Bootstrap

This is a [puppet](https://puppet.com) repository that includes a `bootstrap.sh` script to setup an instance of the [Door43 Content Service (DCS)](https://github.com/unfoldingWord-dev/gogs).  The bootstrap script is intended to be run on fresh installs, it will modify and reboot your system ;)

RPM or DEB compatible operating systems are supported.  Specifically, this should work on CentOS/Redhat 7, AWS Linux AMI, Ubuntu 14.04+.

The only variable needed to get started is $server_name, which should be your desired server name (e.g. `git.door43.org`).  All customizations are based off that variable.  Specifically, the $server_name variable will be used for the following:
 * the Nginx server name for your site
 * the basename for your SSL files, e.g. $server_name.crt and $server_name.key

To get started on a new server, follow these steps.

    wget https://raw.githubusercontent.com/unfoldingWord-dev/gogs_auto_scaling/master/bootstrap.sh
    bash bootstrap.sh -h your.host.name

