sudo -s
# Install needed packets
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc
# Download Nginx packet
wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.24.0-1.el8.ngx.src.rpm
# Download OpenSSL
wget https://github.com/openssl/openssl/archive/refs/heads/OpenSSL_1_1_1-stable.zip
# Download nginx.specs
wget https://github.com/shtrihcode/otus/blob/main/rpm/nginx.spec
# Extract archive
unzip OpenSSL_1_1_1-stable.zip
# Install Package
rpm -i nginx-1.*
# Install Depencies
yum-builddep -y /root/rpmbuild/SPECS/nginx.spec
# Edit nginx.specs
cp -n nginx.spec /root/rpmbuild/SPECS/nginx.spec
# Build RPM
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
# Install RPM nginx
yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.24.0-1.el8.ngx.x86_64.rpm
# Start nginx
systemctl start nginx