--@Autor:           Iñaky Ordiales Caballero
--@Fecha creación:  1 de noviembre de 2022
--@Descripción:     Configuraciones extras con la BD ya creada.

# como usuario oracle

prompt Conectando con sys
connect sys/systemorca as sysdba

alter database
  add logfile member '/unam-bda/d11/app/oracle/oradata/ORCAPROY/redo01a.log' to group 1;
alter database
  add logfile member '/unam-bda/d12/app/oracle/oradata/ORCAPROY/redo01b.log' to group 1;
alter database
  add logfile member '/unam-bda/d13/app/oracle/oradata/ORCAPROY/redo01c.log' to group 1;

alter database
  add logfile member '/unam-bda/d11/app/oracle/oradata/ORCAPROY/redo02a.log' to group 2;
alter database
  add logfile member '/unam-bda/d12/app/oracle/oradata/ORCAPROY/redo02b.log' to group 2;
alter database
  add logfile member '/unam-bda/d13/app/oracle/oradata/ORCAPROY/redo02c.log' to group 2;

alter database
  add logfile member '/unam-bda/d11/app/oracle/oradata/ORCAPROY/redo03a.log' to group 3;
alter database
  add logfile member '/unam-bda/d12/app/oracle/oradata/ORCAPROY/redo03b.log' to group 3;
alter database
  add logfile member '/unam-bda/d13/app/oracle/oradata/ORCAPROY/redo03c.log' to group 3;

alter database archivelog;

exec dbms_connection_pool.start_pool();

exec dbms_connection_pool.alter_param ('','MINSIZE','33');
exec dbms_connection_pool.alter_param ('','MAXSIZE','50');

exec dbms_connection_pool.alter_param ('','INACTIVITY_TIMEOUT','1800');
exec dbms_connection_pool.alter_param ('','MAX_THINK_TIME','1800');

alter database enable block change tracking using file 
 '/unam-bda/d21/backups/ORCAPROY/change_tracking.dbf';
