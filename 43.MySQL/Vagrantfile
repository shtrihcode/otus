# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :master => {
        :box_name => "centos/7",
        :ip_addr => '192.168.56.150',
        :vm_name => "master"
  },
  :slave => {
        :box_name => "centos/7",
        :ip_addr => '192.168.56.151',
        :vm_name => "slave"
  }
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|
        
          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxconfig[:vm_name]

          box.vm.network "private_network", ip: boxconfig[:ip_addr]

          box.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", "1024"]
            end

          box.vm.provision :shell do |s|
             s.inline = <<-SHELL
             mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
             sudo yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm -y
             sudo percona-release setup ps57
             sudo yum install Percona-Server-server-57 -y
             SHELL

             if boxconfig[:vm_name] == "master"
                box.vm.provision :shell do |s|
                s.inline = <<-SHELL
                cp /vagrant/conf/master/conf.d/* /etc/my.cnf.d/
                systemctl start mysql
                pwd=$(cat /var/log/mysqld.log | grep 'root@localhost:' | awk '{print $11}')
                MYSQLPWD="P@ssw0rd"
                echo "ALTER USER USER() IDENTIFIED BY '$MYSQLPWD'" | mysql -uroot -p$pwd --connect-expired-password
                SHELL
                end

                box.trigger.after :up do |trigger|
                    trigger.run_remote = { inline: <<-SHELL
                    MYSQLPWD="P@ssw0rd"
                    echo "CREATE DATABASE bet" | mysql -uroot -p$MYSQLPWD
                    mysql -uroot -p$MYSQLPWD -D bet < /vagrant/bet.dmp
                    echo "CREATE USER 'repl'@'%' IDENTIFIED BY '!OtusLinux2023'" | mysql -uroot -p$MYSQLPWD
                    echo "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY '!OtusLinux2023'" | mysql -uroot -p$MYSQLPWD
                    SHELL
                    }
                end   
               end
             
               if boxconfig[:vm_name] == "slave"
                box.vm.provision :shell do |s|
                    s.inline = <<-SHELL
                    cp /vagrant/conf/slave/conf.d/* /etc/my.cnf.d/
                    systemctl start mysql
                    pwd=$(cat /var/log/mysqld.log | grep 'root@localhost:' | awk '{print $11}')
                    MYSQLPWD="P@ssw0rd"
                    echo "ALTER USER USER() IDENTIFIED BY '$MYSQLPWD'" | mysql -uroot -p$pwd --connect-expired-password
                    SHELL
                end

                box.trigger.after :up do |trigger|
                    trigger.run_remote = { inline: <<-SHELL
                    MYSQLPWD="P@ssw0rd"
                    mysql -uroot -pP@ssw0rd -e"CHANGE MASTER TO MASTER_HOST = '192.168.56.150', MASTER_PORT = 3306, MASTER_USER = 'repl', MASTER_PASSWORD = '!OtusLinux2023', MASTER_AUTO_POSITION = 1;"
                    mysql -uroot -p$MYSQLPWD -e"START SLAVE;"
                    SHELL
                    }
                end   
               end
             
          end

      end
  end
end
