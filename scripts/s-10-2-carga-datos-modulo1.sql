-- Inserciones de BLOBs

prompt 
prompt Creando directory object /tmp/bda/fotos
prompt Conectando con usuario sys ...

connect sys/systemorca as sysdba

create or replace directory fotos_dir as '/tmp/bda/fotos';

grant read on directory fotos_dir to admin_mod1;

prompt 
prompt Conectando con administrador ...
prompt 

connect admin_mod1/adminorca

prompt 

set serveroutput on

declare
  v_bfile bfile;
  v_foto blob;
  v_length_archivo number;
  v_dest_offset number;
  v_src_offset number;

begin
  
  for i in 1..100 loop

    v_bfile := bfilename('FOTOS_DIR', 'foto.png');
    dbms_lob.open(v_bfile);
    v_length_archivo := dbms_lob.getlength(v_bfile);

    -- obteniendo referencia (puntero) de la columna foto en modo exclusivo
    select foto into v_foto
    from usuario
    where usuario_id=i
    for update;

    v_src_offset := 1;
    v_dest_offset := 1;

    -- cargando la foto en un solo paso
    dbms_lob.loadblobfromfile(
      dest_lob    =>  v_foto,
      src_bfile   =>  v_bfile,
      amount      =>  v_length_archivo,
      src_offset  =>  v_src_offset,
      dest_offset =>  v_dest_offset
    );

    -- no olvidar cerrar el archivo !!!
    dbms_lob.close(v_bfile);

  end loop;

  for i in 1..100 loop

    v_bfile := bfilename('FOTOS_DIR', 'foto.png');
    dbms_lob.open(v_bfile);
    v_length_archivo := dbms_lob.getlength(v_bfile);

    -- obteniendo referencia (puntero) de la columna foto en modo exclusivo
    select archivo_foto into v_foto
    from producto_foto
    where foto_id=i
    for update;

    v_src_offset := 1;
    v_dest_offset := 1;

    -- cargando la foto en un solo paso
    dbms_lob.loadblobfromfile(
      dest_lob    =>  v_foto,
      src_bfile   =>  v_bfile,
      amount      =>  v_length_archivo,
      src_offset  =>  v_src_offset,
      dest_offset =>  v_dest_offset
    );

    -- no olvidar cerrar el archivo !!!
    dbms_lob.close(v_bfile);

  end loop;

  for i in 1..50 loop

    v_bfile := bfilename('FOTOS_DIR', 'foto.png');
    dbms_lob.open(v_bfile);
    v_length_archivo := dbms_lob.getlength(v_bfile);

    -- obteniendo referencia (puntero) de la columna foto en modo exclusivo
    select archivo_video into v_foto
    from producto_video
    where video_id=i
    for update;

    v_src_offset := 1;
    v_dest_offset := 1;

    -- cargando la foto en un solo paso
    dbms_lob.loadblobfromfile(
      dest_lob    =>  v_foto,
      src_bfile   =>  v_bfile,
      amount      =>  v_length_archivo,
      src_offset  =>  v_src_offset,
      dest_offset =>  v_dest_offset
    );

    -- no olvidar cerrar el archivo !!!
    dbms_lob.close(v_bfile);

  end loop;


end;
/


alter table usuario   LOGGING;
alter table vendedor  LOGGING;
alter table ocupacion   LOGGING;
alter table comprador   LOGGING;
alter table tarjeta   LOGGING;
alter table tipo_producto   LOGGING;
alter table status_producto LOGGING;
alter table producto  LOGGING;
alter table historico_status_producto LOGGING;
alter table producto_foto   LOGGING;
alter table producto_video  LOGGING;
alter table oferta    LOGGING;

