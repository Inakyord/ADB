--@Autor:           Iñaky Ordiales Caballero
--@Fecha creación:  1 de noviembre de 2022
--@Descripción:     Configuraciones del modo compartido.

# Dentro de RMAN >
# correr: 

#su -l oracle
#export ORACLE_SID=orcaproy
#rman
# rman target sys@s-12-respaldo-inicial.rman


run {
	connect target "admin_back@orcaproy_dedicated as sysbackup"

	configure device type disk parallelism 2;
	configure default device type to disk;
	configure channel 1 device type disk format "/unam-bda/d21/backups/ORCAPROY/%u" maxpiecesize 1g;
	configure channel 2 device type disk clear;
	configure controlfile autobackup format for device type disk clear;
	configure retention policy to recovery window of 7 days;
	configure archivelog deletion policy to backed up 2 times to disk;
	configure backup optimization on;

	shutdown immediate;
	startup mount;
	backup database plus archivelog;
	backup as copy database;
	backup as backupset database;
	backup spfile;
	backup as backupset incremental level 0 database;
	backup as backupset incremental level 1 database;
	backup as backupset incremental level 1 cumulative database; 



	alter database open;

	run obsolete;
	delete obsolete;
}