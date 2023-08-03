sudo -s
# Create directory for repo
mkdir /usr/share/nginx/html/repo
# Copy RPM package to repo
cp /root/rpmbuild/RPMS/x86_64/nginx-1.24.0-1.el8.ngx.x86_64.rpm /usr/share/nginx/html/repo/
# Download to repo RPM Percona-Server
wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-2.el8.x86_64.rpm
# Create Repository
createrepo /usr/share/nginx/html/repo/
# Edit nginx default.conf
[root@centos ~]# vi /etc/nginx/conf.d/default.conf
# Add autoindex on
location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        autoindex on;
    }
# Check config
[root@centos ~]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
# Reload nginx settings
[root@centos ~]# nginx -s reload
# Check repo 
[root@centos ~]# curl -a http://localhost/repo/
<html>
<head><title>Index of /repo/</title></head>
<body>
<h1>Index of /repo/</h1><hr><pre><a href="../">../</a>
<a href="repodata/">repodata/</a>                                          03-Aug-2023 09:23                   -
<a href="nginx-1.24.0-1.el8.ngx.x86_64.rpm">nginx-1.24.0-1.el8.ngx.x86_64.rpm</a>                  03-Aug-2023 09:19             2265136
<a href="percona-orchestrator-3.2.6-2.el8.x86_64.rpm">percona-orchestrator-3.2.6-2.el8.x86_64.rpm</a>        16-Feb-2022 15:57             5222976
</pre><hr></body>
</html>

# Add new repo
[root@centos ~]# cat >> /etc/yum.repos.d/otus.repo << EOF
> 
> [otus]
> 
> name=otus-linux
> 
> baseurl=http://localhost/repo
> 
> gpgcheck=0
> 
> enabled=1
> 
> EOF

# Check repo add
[root@centos ~]# yum repolist enabled | grep otus
Failed to set locale, defaulting to C.UTF-8
otus                otus-linux

# List packages from repo
[root@centos ~]# yum list | grep otus
Failed to set locale, defaulting to C.UTF-8
percona-orchestrator.x86_64                                       2:3.2.6-2.el8                                          otus
# Install Percona-Server from repo
[root@centos ~]# yum install percona-orchestrator.x86_64 -y
