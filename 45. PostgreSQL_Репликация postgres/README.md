# Домашнее задание 45.  Postgres: Backup + Репликация.

## Backup
<pre>
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
Starting backup using postgres method for server node1 in /var/lib/barman/node1/base/20231218T123313
Backup start at LSN: 0/4000060 (000000010000000000000004, 00000060)
Starting backup copy via pg_basebackup for 20231218T123313
Copy done (time: 2 seconds)
Finalising the backup.
This is the first backup for server node1
WAL segments preceding the current backup have been found:
	000000010000000000000003 from server node1 has been removed
Backup size: 33.6 MiB
Backup end at LSN: 0/6000000 (000000010000000000000005, 00000000)
Backup completed (start time: 2023-12-18 12:33:13.205086, elapsed time: 2 seconds)
Processing xlog segments from streaming for node1
	000000010000000000000004
	000000010000000000000005
bash-4.4$ 
</pre>

## Master
![](master.jpg)

## Slave
![](slave.jpg)
