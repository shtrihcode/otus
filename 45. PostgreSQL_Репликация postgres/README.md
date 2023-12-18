# Домашнее задание 45.  Postgres: Backup + Репликация.

## Replication

### command on node1
<pre>
bash-4.4$ hostname
node1
bash-4.4$ psql
could not change directory to "/root": Permission denied
psql (14.10)
Type "help" for help.

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 otus      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)

postgres=# create database otus_2023;
CREATE DATABASE
postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 otus      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 otus_2023 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(5 rows)

postgres=#  select * from pg_stat_replication;
  pid  | usesysid |   usename   |  application_name  |  client_addr  | client_hostname | client_port |         backend_start         | backend_xmin |   state   | sent_lsn  |
 write_lsn | flush_lsn | replay_lsn |    write_lag    |    flush_lag    |   replay_lag    | sync_priority | sync_state |          reply_time           
-------+----------+-------------+--------------------+---------------+-----------------+-------------+-------------------------------+--------------+-----------+-----------+
-----------+-----------+------------+-----------------+-----------------+-----------------+---------------+------------+-------------------------------
 12071 |    16384 | replication | walreceiver        | 192.168.57.12 |                 |       57666 | 2023-12-18 10:02:51.324358-03 |          741 | streaming | 0/301AE48 |
 0/301AE48 | 0/301AE48 | 0/301AE48  |                 |                 |                 |             0 | async      | 2023-12-18 10:15:55.612349-03
 12075 |    16385 | barman      | barman_receive_wal | 192.168.57.13 |                 |       46678 | 2023-12-18 10:03:02.035925-03 |              | streaming | 0/301AE48 |
 0/301AE48 | 0/3000000 |            | 00:00:05.615581 | 00:12:52.842015 | 00:12:52.842015 |             0 | async      | 2023-12-18 10:15:54.892709-03
(2 rows)
</pre>

### command on node2
<pre>
bash-4.4$ hostname
node2
bash-4.4$ psql
could not change directory to "/root": Permission denied
psql (14.10)
Type "help" for help.

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 otus      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 otus      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 otus_2023 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(5 rows)

postgres=# select * from pg_stat_wal_receiver;
  pid  |  status   | receive_start_lsn | receive_start_tli | written_lsn | flushed_lsn | received_tli |      last_msg_send_time       |     last_msg_receipt_time     | lates
t_end_lsn |        latest_end_time        | slot_name |  sender_host  | sender_port |                                                                                        
                                                 conninfo                                                                                                                    
                     
-------+-----------+-------------------+-------------------+-------------+-------------+--------------+-------------------------------+-------------------------------+------
----------+-------------------------------+-----------+---------------+-------------+----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------
 11214 | streaming | 0/3000000         |                 1 | 0/301AE48   | 0/301AE48   |            1 | 2023-12-18 10:15:59.349999-03 | 2023-12-18 10:15:59.328007-03 | 0/301
AE48      | 2023-12-18 10:15:29.271079-03 |           | 192.168.57.11 |        5432 | user=replication password=******** channel_binding=prefer dbname=replication host=192.1
68.57.11 port=5432 fallback_application_name=walreceiver sslmode=prefer sslcompression=0 sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres targ
et_session_attrs=any
(1 row)
</pre>


## Backup
<pre>
bash-4.4$ hostname
barman
bash-4.4$ barman switch-wal node1
The WAL file 000000010000000000000003 has been closed on server 'node1'
bash-4.4$ barman cron
Starting WAL archiving for server node1
bash-4.4$ barman check node1
Server node1:
	PostgreSQL: OK
	superuser or standard user with backup privileges: OK
	PostgreSQL streaming: OK
	wal_level: OK
	replication slot: OK
	directories: OK
	retention policy settings: OK
	backup maximum age: FAILED (interval provided: 4 days, latest backup age: No available backups)
	backup minimum size: OK (0 B)
	wal maximum age: OK (no last_wal_maximum_age provided)
	wal size: OK (0 B)
	compression settings: OK
	failed backups: OK (there are 0 failed backups)
	minimum redundancy requirements: FAILED (have 0 backups, expected at least 1)
	pg_basebackup: OK
	pg_basebackup compatible: OK
	pg_basebackup supports tablespaces mapping: OK
	systemid coherence: OK (no system Id stored on disk)
	pg_receivexlog: OK
	pg_receivexlog compatible: OK
	receive-wal running: OK
	archiver errors: OK
bash-4.4$ barman backup node1
Starting backup using postgres method for server node1 in /var/lib/barman/node1/base/20231218T131930
Backup start at LSN: 0/4000060 (000000010000000000000004, 00000060)
Starting backup copy via pg_basebackup for 20231218T131930
Copy done (time: 1 second)
Finalising the backup.
This is the first backup for server node1
WAL segments preceding the current backup have been found:
	000000010000000000000003 from server node1 has been removed
Backup size: 41.8 MiB
Backup end at LSN: 0/6000060 (000000010000000000000006, 00000060)
Backup completed (start time: 2023-12-18 13:19:30.849521, elapsed time: 2 seconds)
Processing xlog segments from streaming for node1
	000000010000000000000004
	000000010000000000000005
	000000010000000000000006
</pre>

## Restore

### command on node1
<pre>
bash-4.4$ hostname
node1
bash-4.4$ psql
could not change directory to "/root": Permission denied
psql (14.10)
Type "help" for help.

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 otus      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 otus_2023 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(5 rows)

postgres=# drop database otus;
DROP DATABASE
postgres=# drop database otus_2023;
DROP DATABASE
postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(3 rows)
</pre>

### command on barman
<pre>
 bash-4.4$ hostname
node1
bash-4.4$ psql
could not change directory to "/root": Permission denied
psql (14.10)
Type "help" for help.

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 otus      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 otus_2023 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(5 rows)

postgres=# drop database otus;
DROP DATABASE
postgres=# drop database otus_2023;
DROP DATABASE
postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(3 rows)
</pre>

### command on node1
<pre>
[root@node1 ~]# systemctl restart postgresql-14
[root@node1 ~]# su postgres
bash-4.4$ psql
could not change directory to "/root": Permission denied
psql (14.10)
Type "help" for help.

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 otus      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 otus_2023 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(5 rows)
</pre>
