#!/bin/bash

#@Autor         Iñaky Ordiales Caballero
#@Fecha         5 de enero del 2023.
#@Descripcion   Generación del archivo de contraseñas para la BD.

# invocado por el usuario oracle.

# Generación de ARCHIVO DE PASSWORDS
echo "Creando nuevo archivo de contraseñas"
export ORACLE_SID=orcaproy
echo ""
echo "ORACLE_SID=${ORACLE_SID}"

orapwd FILE='$ORACLE_HOME/dbs/orapworcaproy' \
  FORCE=y \
  FORMAT=12.2 \
  SYS=password \
  SYSBACKUP=password \
  SYSKM=password

# contraseñas: hola1234*

echo "Comprobando creación del archivo..."
ls -l ${ORACLE_HOME}/dbs/orapw${ORACLE_SID}

echo "Listo!"
