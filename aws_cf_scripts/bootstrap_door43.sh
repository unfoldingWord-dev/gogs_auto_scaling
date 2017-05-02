#!/usr/bin/env bash
#
# This fully automates the deploy of a Door43 Content Service node to
# our Door43 AWS environment
#
# This script fails on any error.
#
# This should be run as root or with sudo privileges.
#
# <jesse@unfoldingword.org>

set -xe

# Make sure wget is available
yum -y install wget

# Setup small swap space
dd if=/dev/zero of=/swapfile bs=1M count=512
chmod 600 /swapfile
mkswap /swapfile
echo '/swapfile   none        swap    sw              0   0' >> /etc/fstab
swapon -a

# Mount configuration volume
mkdir -p /config
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).fs-acfe3f05.efs.us-west-2.amazonaws.com:/ /config/
echo 'mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).fs-acfe3f05.efs.us-west-2.amazonaws.com:/ /config/' >> /etc/rc.local

# Link SSH
rsync -havP --delete /config/ssh/ /etc/ssh/
service sshd restart
/bin/cp -f /config/private/authorized_keys /root/.ssh/
/bin/cp -f /config/private/authorized_keys /home/ec2-user/.ssh/
chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
/bin/cp -f /config/private/my.cnf /etc/

# Setup SSL
mkdir -p /etc/pki/tls/certs/deployed
/bin/cp -f /config/private/*.crt /etc/pki/tls/certs/deployed/
/bin/cp -f /config/private/*.key /etc/pki/tls/certs/deployed/
openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096

# Add mount for EBS volume
echo 'UUID=feb25d8e-68b2-424c-a2cb-37619cd6741a /mnt ext4 defaults,noatime,nofail 0 2' >>/etc/fstab
mount /mnt

# Get main bootstrap script and run it with our hostname
wget https://raw.githubusercontent.com/unfoldingWord-dev/gogs_auto_scaling/master/bootstrap.sh
bash bootstrap.sh -h git.door43.org
