--@Autor:           Iñaky Ordiales Caballero
--@Fecha creación:  15/01/2022
--@Descripción:     Se hace media recovery

cd /unam-bda/d14/app/oracle/oradata/ORCAPROY
cp tablas_mod1_01.dbf /unam-bda

rm tablas_mod1_01.db

startup
#ORA-01157: cannot identify/lock data file 9 - see DBWR trace file
#ORA-01110: data file 9:
#'/unam-bda/d14/app/oracle/oradata/ORCAPROY/tablas_mod1_01.dbf'


alter database datafile '/unam-bda/d14/app/oracle/oradata/ORCAPROY/tablas_mod1_01.dbf' offline;

RMAN > connect target "admin_back@orcaproy_dedicated as sysbackup"
RMAN > restore database;
RMAN > recover database;

alter database datafile '/unam-bda/d14/app/oracle/oradata/ORCAPROY/tablas_mod1_01.dbf' online;

cd /unam-bda/d14/app/oracle/oradata/ORCAPROY
cp tablas_mod1_01.dbf /unam-bda/tablas_mod1_01-2.dbf

rm tablas_mod1_01.db

RMAN > connect target "admin_back@orcaproy_dedicated as sysbackup"
RMAN > list failure;
RMAN > advise failure;
RMAN > repair failure;
# Repair script: /u01/app/oracle/diag/rdbms/orcaproy/orcaproy/hm/reco_1312176873.hm
   ## restore and recover datafile
   #restore ( datafile 9 );
   #recover datafile 9;
   #sql 'alter database datafile 9 online';
