#!/bin/sh

set -e

rpm -q epel-release >/dev/null || yum -y install http://mirrors.aliyun.com/epel/7/x86_64/e/epel-release-7-8.noarch.rpm


cat > /etc/yum.repos.d/svn.repo <<EOF
[svn]
name=SVN Repo
baseurl=http://opensource.wandisco.com/centos/\$releasever/svn-1.9/RPMS/\$basearch/
enabled=1
gpgcheck=0

EOF

cat > /etc/yum.repos.d/git.repo <<EOF
[git]
name=Git Repo
baseurl=http://opensource.wandisco.com/centos/\$releasever/git/\$basearch/
enabled=1
gpgcheck=0

EOF

cat > /etc/yum.repos.d/docker.repo <<EOF
[docker]
name=Docker Repo
baseurl=http://yum.dockerproject.org/repo/main/centos/\$releasever/
enabled=1
gpgcheck=0

EOF


yum -y install docker-engine git subversion gcc gcc-c++ make automake autoconf cmake m4 net-tools
yum -y install wget
yum -y install bash-completion
yum -y install samba
yum -y groupinstall 'Development Tools'
yum -y update


setsebool -P samba_enable_home_dirs on
setsebool -P samba_export_all_rw on
firewall-cmd --add-service=samba --permanent
systemctl restart firewalld

systemctl enable docker
systemctl enable smb
systemctl start docker
systemctl start smb


echo done

