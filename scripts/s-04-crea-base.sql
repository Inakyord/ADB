--@Autor:           Iñaky Ordiales Caballero
--@Fecha creación:  6 de enero del 2023
--@Descripción:     Script para la creación de la BD con la preparación previa.

-- usuario ordinario del so, sqlplus /nolog

-- Creando el SPFILE a partir del PFILE para la BD

prompt Conectando con sys
connect sys/hola1234* as sysdba

prompt Checando la existencia del PFILE.
!ls ${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora

prompt Creando archivo binario de parámetros.
create spfile='$ORACLE_HOME/dbs/spfile${ORACLE_SID}.ora' from
  pfile='$ORACLE_HOME/dbs/init${ORACLE_SID}.ora';

prompt Checando la existencia del SPFILE.
!ls ${ORACLE_HOME}/dbs/spfile${ORACLE_SID}.ora


prompt Iniciando instancia en modo nomount...
startup nomount


create database orcaproy
  user sys identified by systemorca
  user system identified by systemorca
  logfile group 1 size 50m
blocksize 512,
  group 2 size 50m
blocksize 512,
  group 3 size 50m
blocksize 512
  maxloghistory 1
  maxlogfiles 16
  maxlogmembers 4
  maxdatafiles 1024
  character set AL32UTF8
  national character set AL16UTF16
  extent management local
  datafile '/unam-bda/d17/app/oracle/oradata/ORCAPROY/system01.dbf'
    size 700m reuse autoextend on next 10240k maxsize unlimited
  sysaux datafile '/unam-bda/d17/app/oracle/oradata/ORCAPROY/sysaux01.dbf'
    size 550m reuse autoextend on next 10240k maxsize unlimited
  default tablespace users
    datafile '/unam-bda/d17/app/oracle/oradata/ORCAPROY/users01.dbf'
    size 500m reuse autoextend on maxsize unlimited
  default temporary tablespace tempts1
    tempfile '/unam-bda/d17/app/oracle/oradata/ORCAPROY/temp01.dbf'
    size 20m reuse autoextend on next 640k maxsize unlimited
  undo tablespace undotbs1
    datafile '/unam-bda/d16/app/oracle/oradata/ORCAPROY/undotbs01.dbf'
    size 200m reuse autoextend on next 5120k maxsize unlimited;

accept choice prompt 'Update data (Y/N)?';
prompt Base de datos ORCAPROY creada!!!

prompt .
prompt Cambiando las contraseñas de sys y system
alter user sys identified by systemorca;
alter user system identified by systemorca;
alter user sysbackup identified by systemorca;
alter user syskm identified by systemorca;

whenever sqlerror continue;


-- posterior a la creación de la BD.

prompt Conectando con sys
connect sys/systemorca as sysdba
@?/rdbms/admin/catalog.sql
@?/rdbms/admin/catproc.sql
@?/rdbms/admin/utlrp.sql

prompt Conectando con system
connect system/systemorca
@?/sqlplus/admin/pupbld.sql

prompt Listo!!

disconnect


