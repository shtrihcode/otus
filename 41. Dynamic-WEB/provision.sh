yum install epel-release -y
yum install docker vim -y
yum install docker-ce docker-ce-cli containerd.io docker-compose -y

systemctl start docker

cp -R /vagrant/dockerlab/ /home/vagrant/

cd /vagrant/dockerlab/
docker-compose up --build -d
#sudo chown -R 1000:1000 /var/
#docker exec -it jenkins_jenkins_1 /bin/bash
#sudo chown -R 1000:1000 /usr
