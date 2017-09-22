#!/usr/bin/env bash
#
# Simple script to deploy latest released version of Gogs from
# https://github.com/unfoldingWord-dev/gogs/releases
#
# Run this with the following command:
# puppet apply /etc/puppet/manifests/site.pp -e 'include gogs' --summarize

# Check what the latest release is, bail if we already have it
REL_URL=`curl -s https://api.github.com/repos/unfoldingWord-dev/gogs/releases/latest | grep browser_download_url | head -n 1 | cut -d '"' -f 4`
[ -f /home/git/gogs/${REL_URL##*/} ] && exit 0

# Sleep random amount of time to prevent clobbering from another node
# This is only necessary in a cluster but it doesn't hurt a single node either
sleep ${RANDOM:0:2}
[ -f /home/git/gogs/${REL_URL##*/} ] && exit 0

# Get latest
cd /home/git
wget $REL_URL

# Remove previous build
/bin/rm -rf gogs

# Extract and use our config file
tar xzf linux_amd64_*.tar.gz
/bin/cp -f /config/private/app.ini /home/git/gogs/custom/conf/app.ini
/bin/chgrp git /home/git/gogs/custom/conf/app.ini
mv linux_amd64_*.tar.gz gogs/

# Restart service
service gogs restart
