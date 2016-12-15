#!/bin/bash -xe

# Install necessary system packages
yum -y install rsync screen tmux vim-enhanced telnet wget mysql puppet git nfs-utils nginx

# Mount EFS share to /mnt
echo 'mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).fs-acfe3f05.efs.us-west-2.amazonaws.com:/ /mnt/' >> /etc/rc.local
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).fs-acfe3f05.efs.us-west-2.amazonaws.com:/ /mnt/

# Link puppet
chkconfig puppet off
rm -rf /etc/puppet
ln -s /mnt/puppet /etc/
( cd /etc/puppet && git pull )

# Link SSH
rsync -havP --delete /mnt/ssh/ /etc/ssh/
service sshd restart
/bin/cp -f /mnt/private/authorized_keys /root/.ssh/
/bin/cp -f /mnt/private/authorized_keys /home/ec2-user/.ssh/
chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys

# Run puppet
puppet apply /etc/puppet/manifests/site.pp --summarize
puppet apply /etc/puppet/manifests/site.pp -e 'include gogs' --summarize

# Reboot for good measure
reboot
