--@Autor:			Iñaky Ordiales Caballero
--@Fecha creación:	2/01/2022
--@Descripción:		Creación de tablas del modelo de Emarket (Proyecto Final BDA)

prompt
prompt
prompt Empezando a crear tablas del modelo.
prompt


create table USUARIO (
  usuario_id      number(10,0) not null contraint usuario_pk primary key,
  nombre          varchar2(40) not null,
  ap_paterno      varchar2(40) not null,
  ap_materno      varchar2(40) not null,
  username        varchar2(40) not null,
  password        varchar2(20) not null,
  email           varchar2(50) not null,
  fecha_registro  date default sysdate not null,
  foto            blob default empty_blob() not null,
  rfc             char(13)     not null,
  es_comprador    char(1)      not null,
  es_vendedor     char(1)      not null,
  constraint usuario_username_uk unique (username),
  constraint usuario_rfc_uk unique (rfc),
  constraint usuario_tipo_usuario_chk check (
    (es_comprador = 1) or (es_vendedor = 1))
);


create table VENDEDOR (
  usuario_id    number(10,0)  not null constraint vendedor_pk primary key,
  direccion     varchar2(150) not null,
  calificacion  number(3,1) default 0 not null,
  tipo_vendedor number(1,0)   not null,
  constraint vendedor_usuario_id_fk foreign key (usuario_id)
    references usuario(usuario_id),
  constraint vendedor_rango_calificacion_chk check (
    calificacion between 0 and 10),
  constraint vendedor_tipo_vendedor_chk check (
    (tipo_vendedor = 1) or (tipo_vendedor = 2))
);


create table OCUPACION (
  ocupacion_id      number(3,0)  not null constraint ocupacion_pk primary key,
  nombre_ocupacion  varchar2(40) not null,
  descripcion       varchar2(200) not null
);


create table COMPRADOR (
  usuario_id    number(10,0)  not null constraint comprador_pk primary key,
  descripcion   varchar2(300) not null,
  celular       number(15,0)  not null,
  ocupacion_id  number(3,0)   not null,
  constraint comprador_usuario_id_fk foreign key (usuario_id)
    references usuario(usuario_id),
  constraint comprador_ocupacion_id_fk foreign key (ocupacion_id)
    references ocupacion(ocupacion_id)
);


create table TARJETA (
  tarjeta_id    number(15,0) not null constraint tarjeta_pk primary key,
  numero        number(20,0) not null,
  banco         varchar2(40) not null,
  mes_exp       number(2,0)  not null,
  anio_exp      number(4,0)  not null,
  num_seguridad number(3,0)  not null,
  usuario_id    number(10,0) not null,
  constraint tarjeta_numero_uk unique (numero),
  constraint tarjeta_usuario_id_fk foreign key (usuario_id)
    references usuario(usuario_id),
  constraint tarjeta_mes_exp_chk check (
    mes_exp between 1 and 12),
  constraint tarjeta_anio_exp_chk check (
    anio_exp > 2022),
  constraint tarjeta_vigencia check (
    anio_exp > 2023 or mes_exp > 1)
);


create table ORDEN_COMPRA (
  orden_compra_id   number(16,0)  not null constraint orden_compra_pk primary key,
  fecha_hora        date default sysdate not null,
  direccion_entrega varchar2(200) not null,
  tipo_de_pago      number(1,0)   not null,
  tarjeta_id        number(15,0)  not null,
  constraint orden_compra_tarjeta_id_fk foreign key (tarjeta_id)
    references tarjeta(tarjeta_id),
  constraint orden_compra_tipo_pago_chk check (
    (tipo_de_pago = 1) or (tipo_de_pago = 3) or (tipo_de_pago = 6))
);


create table PAQUETERIA (
  paqueteria_id number(2,0) not null constraint paqueteria_pk primary key,
  nombre        varchar2(40) not null
);


create table FACTURA (
  factura_id      number(10,0) not null constraint factura_pk primary key,
  folio           char(6)      not null,
  comision        number(10,2) not null,
  orden_compra_id number(16,0) not null,
  paqueteria_id   number(2,0)  not null,
  constraint factura_folio_uk unique (folio),
  constraint factura_orden_compra_id_fk foreign key (orden_compra_id)
    references orden_compra(orden_compra_id),
  constraint factura_paqueteria_id_fk foreign key (paqueteria_id)
    references paqueteria(paqueteria_id)
);


create table TIPO_PRODUCTO (
  tipo_producto_id number(1,0)   not null constraint tipo_producto_pk primary key,
  nombre           varchar2(40)  not null,
  descripcion      varchar2(200) not null
);


create table STATUS_PRODUCTO (
  status_producto_id number(1,0)   not null constraint status_producto_pk primary key,
  nombre             varchar2(40)  not null,
  descripcion        varchar2(150) not null
);


create table PRODUCTO (
  producto_id          number(15,0)  not null constraint producto_pk primary key,
  nombre               varchar2(40)  not null,
  descripcion          varchar2(500) not null,
  descripcion_defectos varchar2(500) not null,
  inicio_vida          date          not null,
  precio_inicial       number (12,2) not null,
  fecha_status         date default sysdate not null,
  vendedor_id          number(10,0)  not null,
  tipo_producto_id     number(1,0)   not null,
  status_producto_id   number(1,0)   default 1 not null,
  constraint producto_vendedor_id_fk foreign key (vendedor_id)
    references vendedor(usuario_id),
  constraint producto_tipo_producto_id_fk foreign key (tipo_producto_id)
    references tipo_producto(tipo_producto_id),
  constraint status_producto_id_fk foreign key (status_producto_id)
    references status_producto(status_producto_id)  
);


create table HISTORICO_STATUS_PRODUCTO (
  historico_status_producto_id number(15,0) not null constraint historico_status_producto_pk primary key,
  fecha                        date default sysdate not null,
  status_producto_id           number(1,0)  not null,
  producto_id                  number(15,0) not null,
  constraint historico_status_producto_status_producto_id_fk foreign key (status_producto_id)
    references status_producto(status_producto_id),
  constraint historico_status_producto_producto_id_fk foreign key (producto_id)
    references producto(producto_id)
);


create table PRODUCTO_FOTO (
  foto_id      number(16,0) not null constraint producto_foto_pk primary key,
  archivo_foto blob default empty_blob not null,
  producto_id  number(15,0) not null,
  constraint producto_foto_producto_id_fk foreign key (producto_id)
    references producto(producto_id)
);


create table PRODUCTO_VIDEO (
  video_id      number(15,0) not null constraint producto_video_pk primary key,
  archivo_video blob default empty_blob not null,
  producto_id   number(15,0) not null,
  constraint producto_video_producto_id_fk foreign key (producto_id)
    references producto(producto_id)
);


create table OFERTA (
  oferta_id    number(15,0) not null constraint oferta_pk primary key,
  fecha_hora   date default sysdate not null,
  importe      number(12,2) not null,
  comprador_id number(10,0) not null,
  producto_id  number(15,0) not null,
  constraint oferta_comprador_id_fk foreign key (comprador_id)
    references comprador(usuario_id),
  constraint oferta_producto_id_fk foreign key (producto_id)
    references producto(producto_id)
);

create index oferta_comprador_id_ix on oferta(comprador_id);

create table SUBASTA (
  subasta_id      number(10,0) not null constraint subasta_pk primary key,
  fecha_hora      date default sysdate not null,
  total_productos number(4,0)  not null,
  fecha_cierre    date         not null
);


create table PRODUCTO_SUBASTA (
  producto_subasta_id number(15,0) not null constraint producto_subasta_pk primary key,
  calificacion        number(1,0),
  subasta_id          number(10,0) not null,
  producto_id         number(15,0) not null,
  oferta_ganador_id   number(15,0),
  orden_compra_id     number(16,0),
  constraint producto_subasta_subasta_id_fk foreign key (subasta_id)
    references subasta(subasta_id),
  constraint producto_subasta_producto_id_fk foreign key (producto_id)
    references producto(producto_id),
  constraint producto_subasta_oferta_ganador_id_fk foreign key (oferta_ganador_id)
    references oferta(oferta_id),
  constraint producto_subasta_orden_compra_id_fk foreign key (orden_compra_id)
    references orden_compra(orden_compra_id),
  constraint producto_subasta_calificacion_chk check (
    calificacion between 1 and 5)
);


create table MONITOREO (
  producto_subasta_id number(15,0) not null,
  num_registro        number(2,0)  not null,
  fecha               date default sysdate not null,
  latitud             number(10,8) not null,
  longitud            number(11,8) not null,
  constraint monitoreo_pk primary key (producto_subasta_id,num_registro),
  constraint monitoreo_producto_subasta_id_fk foreign key (producto_subasta_id)
    references producto_subasta(producto_subasta_id),
  constraint aeropuerto_latitud_check check (
    latitud between -90 and 90 ),
  constraint aeropuerto_longitud_check check (
    longitud between -180 and 180)
);


create table PRODUCTO_COMENTARIO (
  producto_comentario_id number(15,0)  not null constraint producto_comentario_pk primary key,
  comentario             varchar2(350) not null,
  producto_subasta_id    number(15,0)  not null,
  constraint producto_comentario_producto_subasta_id_fk foreign key (producto_subasta_id)
    references producto_subasta(producto_subasta_id)
);


prompt 
prompt Listo! Modelo creado con éxito
prompt 