--@Autor:           Iñaky Ordiales Caballero
--@Fecha creación:  6 de enero del 2023.
--@Descripción:     Crea los tablespaces para la base de datos

prompt Conectando con sys
connect sys/systemorca as sysdba


prompt Creando tablespace tablas_mod1...

create tablespace tablas_mod1
  datafile '/unam-bda/d14/app/oracle/oradata/ORCAPROY/tablas_mod1_01.dbf'
    size 20m
    autoextend on,
    '/unam-bda/d14/app/oracle/oradata/ORCAPROY/tablas_mod1_02.dbf'
    size 20m
    autoextend on,
    '/unam-bda/d14/app/oracle/oradata/ORCAPROY/tablas_mod1_03.dbf'
    size 20m
    autoextend on 
  extent management local autoallocate
  segment space management auto;



prompt Creando tablespace blob_mod1...

create bigfile tablespace blob_mod1
  datafile '/unam-bda/d14/app/oracle/oradata/ORCAPROY/blob_mod1.dbf' size 1g autoextend on;
  


prompt Creando tablespace tablas_mod2...

create tablespace tablas_mod2
  datafile '/unam-bda/d15/app/oracle/oradata/ORCAPROY/tablas_mod2_01.dbf'
    size 20m
    autoextend on,
    '/unam-bda/d15/app/oracle/oradata/ORCAPROY/tablas_mod2_02.dbf'
    size 20m
    autoextend on 
  extent management local autoallocate
  segment space management auto;



prompt Creando tablespace indices_mod1...

create tablespace indices_mod1
  datafile '/unam-bda/d14/app/oracle/oradata/ORCAPROY/indices_mod1.dbf'
    size 20m
    autoextend on
  extent management local autoallocate
  segment space management auto;



prompt Creando tablespace indices_mod2...

create tablespace indices_mod2
  datafile '/unam-bda/d15/app/oracle/oradata/ORCAPROY/indices_mod2.dbf'
    size 20m
    autoextend on
  extent management local autoallocate
  segment space management auto;



prompt Creando tablespace temp_mod1...

create temporary tablespace temp_mod1
  tempfile '/unam-bda/d14/app/oracle/oradata/ORCAPROY/temp_mod1.dbf'
    size 20m reuse;



prompt Creando tablespace temp_mod2...

create temporary tablespace temp_mod2
  tempfile '/unam-bda/d15/app/oracle/oradata/ORCAPROY/temp_mod2.dbf'
    size 20m reuse;



prompt Creando tablespace cifrado_tarjeta...

create tablespace cifrado_tarjeta
  datafile '/unam-bda/d14/app/oracle/oradata/ORCAPROY/cifrado_tarjeta.dbf'
    size 20m
    autoextend on
  extent management local autoallocate
  segment space management auto;


