# Домашнее задание 22. Пользователи и группы. Авторизация и аутентификация_РАМ  

## bash - описание команд и их вывод
[root@pam ~]# cat /etc/group | grep admin
admin:x:1003:otusadm,root,vagrant
[root@pam ~]# 
vagrant@pam ~]$ sudo -i
[root@pam ~]# sudo useradd otusadm && sudo useradd otus
[root@pam ~]# echo "Otus2022!" | sudo passwd --stdin otusadm && echo "Otus2022!" | sudo passwd --stdin otus
Changing password for user otusadm.
passwd: all authentication tokens updated successfully.
Changing password for user otus.
passwd: all authentication tokens updated successfully.
[root@pam ~]# sudo groupadd -f admin
[root@pam ~]# usermod otusadm -a -G admin && usermod root -a -G admin && usermod vagrant -a -G admin


root@iliaotusgui:/home/almadm/vm/pam# ssh otus@192.168.57.10
The authenticity of host '192.168.57.10 (192.168.57.10)' can't be established.
ECDSA key fingerprint is SHA256:qEZtQKPRMxOeQk6KltfzHphYOFwYcUx2FYOpF5aFerU.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.57.10' (ECDSA) to the list of known hosts.
otus@192.168.57.10's password: 

This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
[otus@pam ~]$ whoami
otus
[otus@pam ~]$ exit
logout
Connection to 192.168.57.10 closed.
root@iliaotusgui:/home/almadm/vm/pam# 

[root@pam ~]# cat /etc/group | grep admin
admin:x:1003:otusadm,root,vagrant
[root@pam ~]# 

[root@pam ~]# cat /usr/local/bin/login.sh
#!/bin/bash
if [ $(date +%a) = "Sat" ] || [ $(date +%a) = "Sun" ]; then
	if getent group admin | grep -qw "$PAM_USER"; then
	exit 0
      else
	exit 1
    fi
	else
    exit 0
    fi
[root@pam ~]# 

[root@pam ~]# chmod +x /usr/local/bin/login.sh
[root@pam ~]# nano /etc/pam.d/sshd
[root@pam ~]# cp /etc/pam.d/sshd /etc/pam.d/sshd.bak
[root@pam ~]# nano /etc/pam.d/sshd
[root@pam ~]# cat /etc/pam.d/sshd
#%PAM-1.0
auth       substack     password-auth
auth       include      postlogin
account    required     pam_sepermit.so
account    required     pam_nologin.so
account    include      password-auth
password   include      password-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    required     pam_loginuid.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open env_params
session    required     pam_namespace.so
session    optional     pam_keyinit.so force revoke
session    optional     pam_motd.so
session    include      password-auth
session    include      postlogin
# Post Login Scripts

session required pam_exec.so /usr/local/bin/login.sh
 
[root@pam ~]# 


root@iliaotusgui:/home/almadm/otus/22.PAM# ssh otus@192.168.57.10
otus@192.168.57.10's password: 

This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
/usr/local/bin/login.sh failed: exit code 1
Last login: Thu Sep 28 12:08:56 2023 from 192.168.57.1
Connection to 192.168.57.10 closed.

root@iliaotusgui:/home/almadm/otus/22.PAM# ssh otusadm@192.168.57.10
otusadm@192.168.57.10's password: 

This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last failed login: Thu Sep 28 12:00:26 UTC 2023 from 192.168.57.1 on ssh:notty
There were 4 failed login attempts since the last successful login.
[otusadm@pam ~]$ 


## login.sh - файл-скрипт
## Vagrantfile, который будет разворачивать виртуальную машину
