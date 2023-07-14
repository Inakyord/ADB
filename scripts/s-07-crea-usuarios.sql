--@Autor:           Iñaky Ordiales Caballero
--@Fecha creación:  7 de enero del 2023.
--@Descripción:     Crea los usuarios que serán utilizados en la BD.

prompt Conectando con sys
connect sys/systemorca as sysdba

prompt Creando usuarios


create user admin_mod1 identified by adminorca
	default tablespace tablas_mod1
	temporary tablespace temp_mod1
	quota unlimited on tablas_mod1
	quota unlimited on blob_mod1
	quota unlimited on indices_mod1;

grant create session, create table, create procedure to admin_mod1;
alter user admin_mod1 quota unlimited on cifrado_tarjeta;

create user admin_mod2 identified by adminorca
	default tablespace tablas_mod2
	temporary tablespace temp_mod2
	quota unlimited on tablas_mod2
	quota unlimited on indices_mod2;

grant create session, create table, create procedure to admin_mod2;


create user admin_back identified by adminorca quota unlimited on users;
grant sysbackup to admin_back;


create user admin_enc identified by adminorca quota unlimited on users;
grant syskm to admin_enc;

