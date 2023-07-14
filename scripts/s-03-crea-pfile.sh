#!/bin/bash

#@Autor         Ordiales Caballero, Iñaky
#@Fecha         6 de enero del 2023.
#@Descripcion   Creación del archivo de parametros de la BD.

# invocado por el usuario oracle.

# Creacion del ARCHIVO DE PARÁMETROS PFILE.

export ORACLE_SID=orcaproy

pfile=$ORACLE_HOME/dbs/init${ORACLE_SID}.ora

if [ -f "$pfile" ]; then
  read -p "El archivo ${pfile} ya existe, [enter] para sobreescirbir"
fi;

echo \
"
db_name='${ORACLE_SID}'
db_domain='fi.unam'
memory_target=768M
control_files=(/unam-bda/d11/app/oracle/oradata/${ORACLE_SID^^}/control01.ctl,
               /unam-bda/d12/app/oracle/oradata/${ORACLE_SID^^}/control02.ctl,
               /unam-bda/d13/app/oracle/oradata/${ORACLE_SID^^}/control03.ctl)
db_block_size=4096
db_recovery_file_dest_size=2G
db_flashback_retention_target=1440
db_recovery_file_dest='/unam-bda/d18/fastRecovery/${ORACLE_SID^^}'
log_archive_max_processes=3
log_archive_format = arch_iocbda2_%t_%s_%r.arc
log_archive_dest_1='LOCATION=/unam-bda/d19/archiveRedoA MANDATORY'
log_archive_dest_2='LOCATION=/unam-bda/d20/archiveRedoB'
log_archive_dest_3='LOCATION=USE_DB_RECOVERY_FILE_DEST'
log_archive_min_succeed_dest=2
dispatchers='(dispatchers=2)(protocol=tcp)'
shared_servers=4
" >$pfile

echo "Listo!"
echo "Comprobando la existencia y contenido del PFILE"
echo ""
cat ${pfile}