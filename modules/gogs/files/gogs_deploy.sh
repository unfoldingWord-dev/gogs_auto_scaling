#!/bin/bash
#
# Simple script to deploy latest released version of Gogs from
# https://github.com/unfoldingWord-dev/gogs/releases
#
# Run this with the following command:
# puppet apply /etc/puppet/manifests/site.pp -e 'include gogs' --summarize

REL_URL=`curl -s https://api.github.com/repos/unfoldingWord-dev/gogs/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4`

[ -f /mnt/git/gogs/${REL_URL##*/} ] && exit 0

cd /mnt/git

# Get latest
wget $REL_URL

# Remove previous build
/bin/rm -rf gogs

# Extract and use our config file
tar xzf linux_amd64_*.tar.gz
/bin/cp -f /mnt/private/app.ini /mnt/git/gogs/custom/conf/app.ini
mv linux_amd64_*.tar.gz gogs/
