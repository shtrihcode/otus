# Создать свой RPM пакет nginx c OpenSSL
create rpm

# Создать свой репозиторий и разместить там ранее собранный RPM
create repo

# Скрипты для vagrant
rpm.sh;
repo.sh

# SPECS для NGINX с добавленным OpenSSL
nginx.spec

# default.conf для nginx с включенным листингом
default.conf

# Vagrant файл с автоматически собираемым пакетом RPM и созданием repo
Vagrantfile
