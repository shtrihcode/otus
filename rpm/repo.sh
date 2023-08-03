sudo -s
# Create directory for repo
mkdir /usr/share/nginx/html/repo
# Copy RPM package to repo
cp /root/rpmbuild/RPMS/x86_64/nginx-1.24.0-1.el8.ngx.x86_64.rpm /usr/share/nginx/html/repo/
# Download to repo RPM Percona-Server
wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-2.el8.x86_64.rpm
# Create Repository
createrepo /usr/share/nginx/html/repo/
# Download nginx default.conf
wget https://github.com/shtrihcode/otus/blob/main/rpm/default.conf
# Copy and replace nginx default.conf
cp -n default.conf /etc/nginx/conf.d/default.conf
# Reload nginx settings
nginx -s reload
# Add new repo
[root@centos ~]# cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
# Install Percona-Server from repo
yum install -y percona-orchestrator.x86_64

