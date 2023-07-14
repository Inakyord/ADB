#!/bin/bash

# @Autor        Iñaky Ordiales Caballero
# @Fecha        5 de enero del 2023.
# @Descripcion  Creación de la jerarquía de directorios para simular discos en puntos de montaje
#               y de los loop devices necesarios.

# invocado por el usuario root

# LOOP DEVICES para Redo Logs y Control Files
echo "Creando dispositivos con loop devices..."
echo ""
echo "Creando directorio /unam-bda/disk-images"
mkdir -p /unam-bda/disk-images
cd /unam-bda/disk-images

# creando archivos binarios para loops
echo "Creando disk11.img"
dd if=/dev/zero of=disk11.img bs=100M count=10
echo "Creando disk12.img"
dd if=/dev/zero of=disk12.img bs=100M count=10
echo "Creando disk13.img"
dd if=/dev/zero of=disk13.img bs=100M count=10

#comprobando la creación de los archivos
echo "Mostrando la creación de los archivos..."
du -sh disk1*.img

#crando y asociando loop devices
echo "Asociando los archivos img a loop devices..."
losetup -fP disk11.img
losetup -fP disk12.img
losetup -fP disk13.img
# -f ubica primer loop device disponible
# -P obliga al Kernel a releer tabla de particiones con los nuevos loops

#confirmando creación de los 3 loops devices
echo "Comprobando la asociación de los loop devices..."
losetup -a

#dando formato
echo "Dando formato ext4 a los 3 archivos img..."
mkfs.ext4 disk11.img
mkfs.ext4 disk12.img
mkfs.ext4 disk13.img

#creando directorios de montado
echo "Creando directorios para puntos de montaje..."
mkdir /unam-bda/d11
mkdir /unam-bda/d12
mkdir /unam-bda/d13

echo "Listo!"
echo ""
echo "Editar archivo /etc/fstab de forma manual ..."

echo \
"
# Loop devices agregados para el proyecto final de unam-bda
# Asegurarse que los archivos img existan.img
/unam-bda/disk-images/disk11.img           /unam-bda/d11           auto    loop            0 0
/unam-bda/disk-images/disk12.img           /unam-bda/d12           auto    loop            0 0
/unam-bda/disk-images/disk13.img           /unam-bda/d13           auto    loop            0 0

" >> /etc/fstab

# montar los loop devices
mount -a

# checar que estén montados los devices
df -h | grep "/*unam-bda/d1*"



# Creando directorios para simular los demás discos

echo "Creando directorios para puntos de montaje..."
mkdir -p /unam-bda/d14/app/oracle/oradata
mkdir -p /unam-bda/d15/app/oracle/oradata
mkdir -p /unam-bda/d16/app/oracle/oradata
mkdir -p /unam-bda/d17/app/oracle/oradata
mkdir -p /unam-bda/d18/fastRecovery
mkdir -p /unam-bda/d19/archiveRedoA
mkdir -p /unam-bda/d20/archiveRedoB
mkdir -p /unam-bda/d21/backups


# DIRECTORIOS PARA DATAFILES

export ORACLE_SID=orcaproy

echo ""
echo "Creando directorios para data files..."
echo ""

cd /unam-bda/d14/app/oracle/oradata
mkdir ${ORACLE_SID^^}
chown oracle:oinstall ${ORACLE_SID^^}
chmod 750 ${ORACLE_SID^^}

cd /unam-bda/d15/app/oracle/oradata
mkdir ${ORACLE_SID^^}
chown oracle:oinstall ${ORACLE_SID^^}
chmod 750 ${ORACLE_SID^^}

cd /unam-bda/d16/app/oracle/oradata
mkdir ${ORACLE_SID^^}
chown oracle:oinstall ${ORACLE_SID^^}
chmod 750 ${ORACLE_SID^^}

cd /unam-bda/d17/app/oracle/oradata
mkdir ${ORACLE_SID^^}
chown oracle:oinstall ${ORACLE_SID^^}
chmod 750 ${ORACLE_SID^^}


echo ""
echo "Creando directorios para la FRA..."
echo ""

cd /unam-bda/d18/fastRecovery
mkdir ${ORACLE_SID^^}
chown oracle:oinstall ${ORACLE_SID^^}
chmod 750 ${ORACLE_SID^^}


echo ""
echo "Creando directorios para Archive Redo Logs..."
echo ""

cd /unam-bda/d19/archiveRedoA
mkdir ${ORACLE_SID^^}
chown oracle:oinstall ${ORACLE_SID^^}
chmod 750 ${ORACLE_SID^^}

cd /unam-bda/d20/archiveRedoB
mkdir ${ORACLE_SID^^}
chown oracle:oinstall ${ORACLE_SID^^}
chmod 750 ${ORACLE_SID^^}


echo ""
echo "Creando directorios para backups..."
echo ""

cd /unam-bda/d21/backups
mkdir ${ORACLE_SID^^}
chown oracle:oinstall ${ORACLE_SID^^}
chmod 750 ${ORACLE_SID^^}


echo ""
echo ""
echo "Creando directorios para Redo Log y control files..."
echo ""

cd /unam-bda/d11
mkdir -p app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall app
chmod -R 750 app

cd /unam-bda/d12
mkdir -p app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall app
chmod -R 750 app

cd /unam-bda/d13
mkdir -p app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall app
chmod -R 750 app


echo ""
echo "Mostrando directorios para control files y Redo Logs"
ls -l /unam-bda/d1*/app/oracle/oradata
echo ""


echo ""
echo ""
echo "Agregando nuevas conexiones a tnsnames.ora"
echo \
"
# Conexiones para la base del proyecto final, junto con listener

ORCAPROY =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pc-ioc.fi.unam)(PORT = 1521))
    (CONNECT_DATA =
      (SERVICE_NAME = orcaproy.fi.unam)
    )
  )

ORCAPROY_DEDICATED =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pc-ioc.fi.unam)(PORT = 1521))
    (CONNECT_DATA =
      (SERVICE_NAME = orcaproy.fi.unam)
      (SERVER=DEDICATED)
    )
  )

ORCAPROY_SHARED =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pc-ioc.fi.unam)(PORT = 1521))
    (CONNECT_DATA =
      (SERVICE_NAME = orcaproy.fi.unam)
      (SERVER=SHARED)
    )
  )

ORCAPROY_POOLED =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = pc-ioc.fi.unam)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = orcaproy.fi.unam)
      (SERVER=POOLED)
    )
  )

LISTENER_ORCAPROY =
  (ADDRESS = (PROTOCOL = TCP)(HOST = pc-ioc.fi.unam)(PORT = 1521))

" >> /u01/app/oracle/product/19.3.0/dbhome_1/network/admin/tnsnames.ora

echo ""
echo "Listo!"
echo ""