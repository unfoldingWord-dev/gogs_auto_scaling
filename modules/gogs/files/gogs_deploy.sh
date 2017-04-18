#!/bin/bash
#
# Simple script to deploy latest released version of Gogs from
# https://github.com/unfoldingWord-dev/gogs/releases
#
# Run this with the following command:
# puppet apply /etc/puppet/manifests/site.pp -e 'include gogs' --summarize

# Check what the latest release is, bail if we already have it
REL_URL=`curl -s https://api.github.com/repos/unfoldingWord-dev/gogs/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4`
[ -f /mnt/git/gogs/${REL_URL##*/} ] && exit 0

# Sleep random amount of time to prevent clobbering from another node
sleep ${RANDOM:0:2}
[ -f /mnt/git/gogs/${REL_URL##*/} ] && exit 0

# Get latest
cd /mnt/git
wget $REL_URL

# Remove previous build
/bin/rm -rf gogs

# Extract and use our config file
tar xzf linux_amd64_*.tar.gz
/bin/cp -f /config/private/app.ini /mnt/git/gogs/custom/conf/app.ini
/bin/chgrp git /mnt/git/gogs/custom/conf/app.ini
mv linux_amd64_*.tar.gz gogs/
