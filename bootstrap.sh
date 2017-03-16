#!/bin/bash -xe

# Install necessary system packages
yum -y install rsync screen tmux vim-enhanced telnet wget mysql puppet git nfs-utils nginx

# Mount EBS volume
echo 'UUID=feb25d8e-68b2-424c-a2cb-37619cd6741a /mnt ext4 defaults,noatime,nofail 0 2' >>/etc/fstab
mount -a

# Setup small swap space
dd if=/dev/zero of=/swapfile bs=1M count=512
chmod 600 /swapfile
mkswap /swapfile
echo '/swapfile   none        swap    sw              0   0' >> /etc/fstab
swapon -a

# Verify EBS volume mounted
[ -d /mnt/ssh ] || exit 1

# Get latest puppet
chkconfig puppet off
rm -rf /etc/puppet
git clone https://github.com/unfoldingWord-dev/gogs_auto_scaling.git /etc/puppet

# Link SSH
rsync -havP --delete /mnt/ssh/ /etc/ssh/
service sshd restart
/bin/cp -f /mnt/private/authorized_keys /root/.ssh/
/bin/cp -f /mnt/private/authorized_keys /home/ec2-user/.ssh/
chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
/bin/cp -f /mnt/private/my.cnf /etc/

# Run puppet
puppet apply /etc/puppet/manifests/site.pp --summarize
puppet apply /etc/puppet/manifests/site.pp -e 'include gogs' --summarize

# Set Gogs to start on boot
echo '/etc/init.d/gogs restart' >> /etc/rc.local

# Reboot for good measure
reboot
