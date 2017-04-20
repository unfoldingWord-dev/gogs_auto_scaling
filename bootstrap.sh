#!/usr/bin/env bash -xe
#
# This script sets up a new CentOS/Redhat or Ubuntu/Debian server to run as a
# Door43 Content Service node.
#
# This script fails on any error.
#
# This should be run as root or with sudo privileges.
#
# <jesse@unfoldingword.org>

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

# Run puppet
puppet apply /etc/puppet/manifests/site.pp --summarize

# Reboot for good measure
reboot
