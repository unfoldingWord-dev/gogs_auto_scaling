#!/usr/bin/env bash
#
# This script sets up a new CentOS/Redhat or Ubuntu/Debian server to run as a
# Door43 Content Service node.
#
# This script fails on any error.
#
# This should be run as root or with sudo privileges.
#
# <jesse@unfoldingword.org>

set -xe

PROGNAME="${0##*/}"

help() {
    echo
    echo "Setup new Door43 Content Service server."
    echo
    echo "Usage:"
    echo "   $PROGNAME -s <server_name>"
    echo "   $PROGNAME --help"
    echo
    exit 1
}

if [ $# -lt 1 ]; then
    help
fi
while test -n "$1"; do
    case "$1" in
        --server|-s)
            server_name="$2"
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            help
            ;;
    esac
    shift
done

[ -z "$server_name" ] && help

# Identify operating system
OS='rpm_compat' # default to RPM compatible
if [ -d /etc/apt/sources.list.d/ ]; then
  OS='deb_compat'
fi

# Install necessary system packages (and prevent puppet agent from running)
if [ "$OS" == "deb_compat" ]; then
  apt-get update
  apt-get -y install rsync screen tmux vim telnet wget mysql-client puppet git nginx
  service puppet stop
  which systemctl
  systemd="$?"
  if [ $systemd -eq 1 ]; then
    systemctl disable puppet
  else
    update-rc.d puppet disable
  fi
fi
if [ "$OS" == "rpm_compat" ]; then
  yum -y install rsync screen tmux vim-enhanced telnet wget mysql puppet git nginx
  chkconfig puppet off
fi

# Get latest configuration repository
rm -rf /etc/puppet
git clone https://github.com/unfoldingWord-dev/gogs_auto_scaling.git /etc/puppet

# Set variables for puppet via facter
facter_dir=`find /usr/lib/ -type d -name facter | head -1`
sed -e "s/SERVER_NAME/$server_name/" facts/dcs.rb >"$facter_dir/dcs.rb"

# Run puppet
puppet apply /etc/puppet/manifests/site.pp --summarize

# Reboot for good measure
reboot
