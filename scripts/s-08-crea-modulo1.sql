--@Autor:           Iñaky Ordiales Caballero
--@Fecha creación:  17/01/2022
--@Descripción:     Creación de tablas del modelo módulo 1 (Proyecto Final BDA)

prompt
prompt
prompt Empezando a crear tablas del módulo 1.
prompt

connect admin_mod1/adminorca

--
-- ER/Studio 8.0 SQL Code Generation
-- Company :      UNAM
-- Project :      Modulo1.DM1
-- Author :       InakyO
--
-- Date Created : Wednesday, January 18, 2023 23:05:43
-- Target DBMS : Oracle 11g
--

-- 
-- TABLE: USUARIO 
--

CREATE TABLE USUARIO(
    USUARIO_ID        NUMBER(10, 0)    NOT NULL,
    NOMBRE            VARCHAR2(50)     NOT NULL,
    AP_PATERNO        VARCHAR2(50)     NOT NULL,
    AP_MATERNO        VARCHAR2(50)     NOT NULL,
    USERNAME          VARCHAR2(50)     NOT NULL,
    PASSWORD          VARCHAR2(50)     NOT NULL,
    EMAIL             VARCHAR2(50)     NOT NULL,
    FECHA_REGISTRO    DATE             default sysdate NOT NULL,
    FOTO              BLOB             default empty_blob() NOT NULL,
    RFC               CHAR(13)         NOT NULL,
    ES_COMPRADOR      CHAR(1)          NOT NULL,
    ES_VENDEDOR       CHAR(1)          NOT NULL,
    CONSTRAINT usuario_pk PRIMARY KEY (USUARIO_ID) USING INDEX TABLESPACE indices_mod1,
    CONSTRAINT usuario_username_uk unique (username) USING INDEX TABLESPACE indices_mod1,
    CONSTRAINT usuario_rfc_uk unique (rfc) USING INDEX TABLESPACE indices_mod1,
    CONSTRAINT usuario_email_uk unique (email) USING INDEX TABLESPACE indices_mod1,
    CONSTRAINT usuario_tipo_usuario_chk check (
      (es_comprador = 1) or (es_vendedor = 1))
)
  LOB (FOTO) store as basicfile usuario_foto_blob(
    tablespace blob_mod1
    INDEX (tablespace indices_mod1))
;


-- 
-- TABLE: OCUPACION 
--

CREATE TABLE OCUPACION(
    OCUPACION_ID        NUMBER(3, 0)    NOT NULL,
    NOMBRE_OCUPACION    VARCHAR2(50)    NOT NULL,
    DESCRIPCION         VARCHAR2(300)   NOT NULL,
    CONSTRAINT ocupacion_pk PRIMARY KEY (OCUPACION_ID) USING INDEX TABLESPACE indices_mod1
)
;



-- 
-- TABLE: COMPRADOR 
--

CREATE TABLE COMPRADOR(
    USUARIO_ID      NUMBER(10, 0)    NOT NULL,
    DESCRIPCION     VARCHAR2(400)    NOT NULL,
    CELULAR         NUMBER(15, 0)    NOT NULL,
    OCUPACION_ID    NUMBER(3, 0)     NOT NULL,
    CONSTRAINT comprador_pk PRIMARY KEY (USUARIO_ID) USING INDEX TABLESPACE indices_mod1, 
    CONSTRAINT comprador_usuario_id_fk FOREIGN KEY (USUARIO_ID)
      REFERENCES USUARIO(USUARIO_ID),
    CONSTRAINT comprador_ocupacion_id_fk FOREIGN KEY (OCUPACION_ID)
      REFERENCES OCUPACION(OCUPACION_ID)
)
;



-- 
-- TABLE: STATUS_PRODUCTO 
--

CREATE TABLE STATUS_PRODUCTO(
    STATUS_PRODUCTO_ID    NUMBER(2, 0)     NOT NULL,
    NOMBRE                VARCHAR2(50)     NOT NULL,
    DESCRIPCION           VARCHAR2(250)    NOT NULL,
    CONSTRAINT status_producto_pk PRIMARY KEY (STATUS_PRODUCTO_ID) USING INDEX TABLESPACE indices_mod1
)
;



-- 
-- TABLE: VENDEDOR 
--

CREATE TABLE VENDEDOR(
    USUARIO_ID       NUMBER(10, 0)    NOT NULL,
    DIRECCION        VARCHAR2(250)    NOT NULL,
    CALIFICACION     NUMBER(3, 1)     default 0 NOT NULL,
    TIPO_VENDEDOR    NUMBER(1, 0)     NOT NULL,
    CONSTRAINT vendedor_pk PRIMARY KEY (USUARIO_ID) USING INDEX TABLESPACE indices_mod1, 
    CONSTRAINT vendedor_usuario_id_fk FOREIGN KEY (USUARIO_ID)
      REFERENCES USUARIO(USUARIO_ID),
    CONSTRAINT vendedor_rango_calificacion_chk check (
      (calificacion between 0 and 10)),
    CONSTRAINT vendedor_tipo_vendedor_chk check (
      (tipo_vendedor = 1) or (tipo_vendedor = 2))
)
;



-- 
-- TABLE: TIPO_PRODUCTO 
--

CREATE TABLE TIPO_PRODUCTO(
    TIPO_PRODUCTO_ID    NUMBER(2, 0)     NOT NULL,
    NOMBRE              VARCHAR2(50)     NOT NULL,
    DESCRIPCION         VARCHAR2(300)    NOT NULL,
    CONSTRAINT tipo_producto_pk PRIMARY KEY (TIPO_PRODUCTO_ID) USING INDEX TABLESPACE indices_mod1
)
;



-- 
-- TABLE: PRODUCTO 
--

CREATE TABLE PRODUCTO(
    PRODUCTO_ID             NUMBER(15, 0)    NOT NULL,
    NOMBRE                  VARCHAR2(50)     NOT NULL,
    DESCRIPCION             VARCHAR2(500)    NOT NULL,
    DESCRIPCION_DEFECTOS    VARCHAR2(500)    NOT NULL,
    INICIO_VIDA             DATE             NOT NULL,
    PRECIO_INICIAL          NUMBER(12, 2)    NOT NULL,
    FECHA_STATUS            DATE             default sysdate NOT NULL,
    VENDEDOR_ID             NUMBER(10, 0)    NOT NULL,
    TIPO_PRODUCTO_ID        NUMBER(2, 0)     NOT NULL,
    STATUS_PRODUCTO_ID      NUMBER(2, 0)     default 1 NOT NULL,
    CONSTRAINT producto_pk PRIMARY KEY (PRODUCTO_ID) USING INDEX TABLESPACE indices_mod1, 
    CONSTRAINT producto_vendedor_id_fk FOREIGN KEY (VENDEDOR_ID)
      REFERENCES VENDEDOR(USUARIO_ID),
    CONSTRAINT producto_tipo_producto_id_fk FOREIGN KEY (TIPO_PRODUCTO_ID)
      REFERENCES TIPO_PRODUCTO(TIPO_PRODUCTO_ID),
    CONSTRAINT producto_status_producto_id_fk FOREIGN KEY (STATUS_PRODUCTO_ID)
      REFERENCES STATUS_PRODUCTO(STATUS_PRODUCTO_ID)
) 
PARTITION BY RANGE(precio_inicial)
(
  PARTITION producto_bajo  VALUES LESS THAN (10000),
  PARTITION producto_medio VALUES LESS THAN (1000000),
  PARTITION producto_alto  VALUES LESS THAN (9999999999.99)
)
;

CREATE INDEX producto_nombre_is ON producto(upper(nombre)) TABLESPACE indices_mod1;


-- 
-- TABLE: HISTORICO_STATUS_PRODUCTO 
--

CREATE TABLE HISTORICO_STATUS_PRODUCTO(
    HISTORICO_STATUS_PRODUCTO_ID    NUMBER(15, 0)    NOT NULL,
    FECHA                           DATE             default sysdate NOT NULL,
    STATUS_PRODUCTO_ID              NUMBER(2, 0)     NOT NULL,
    PRODUCTO_ID                     NUMBER(15, 0)    NOT NULL,
    CONSTRAINT historico_status_producto_pk PRIMARY KEY (HISTORICO_STATUS_PRODUCTO_ID) USING INDEX TABLESPACE indices_mod1, 
    CONSTRAINT historico_status_producto_status_producto_id_fk FOREIGN KEY (STATUS_PRODUCTO_ID)
      REFERENCES STATUS_PRODUCTO(STATUS_PRODUCTO_ID),
    CONSTRAINT historico_status_producto_producto_id_fk FOREIGN KEY (PRODUCTO_ID)
      REFERENCES PRODUCTO(PRODUCTO_ID)
)
;



-- 
-- TABLE: OFERTA 
--

CREATE TABLE OFERTA(
    OFERTA_ID       NUMBER(15, 0)    NOT NULL,
    FECHA_HORA      DATE             default sysdate NOT NULL,
    IMPORTE         NUMBER(12, 2)    NOT NULL,
    COMPRADOR_ID    NUMBER(10, 0)    NOT NULL,
    PRODUCTO_ID     NUMBER(15, 0)    NOT NULL,
    CONSTRAINT oferta_pk PRIMARY KEY (OFERTA_ID) USING INDEX TABLESPACE indices_mod1, 
    CONSTRAINT oferta_comprador_id_fk FOREIGN KEY (COMPRADOR_ID)
      REFERENCES COMPRADOR(USUARIO_ID),
    CONSTRAINT oferta_producto_id_fk FOREIGN KEY (PRODUCTO_ID)
      REFERENCES PRODUCTO(PRODUCTO_ID)
)
;

CREATE INDEX oferta_comprador_id_ix ON oferta(comprador_id) TABLESPACE indices_mod1;


-- 
-- TABLE: PRODUCTO_FOTO 
--

CREATE TABLE PRODUCTO_FOTO(
    FOTO_ID         NUMBER(16, 0)    NOT NULL,
    ARCHIVO_FOTO    BLOB             default empty_blob() NOT NULL,
    PRODUCTO_ID     NUMBER(15, 0)    NOT NULL,
    CONSTRAINT producto_foto_pk PRIMARY KEY (FOTO_ID) USING INDEX TABLESPACE indices_mod1, 
    CONSTRAINT producto_foto_producto_id_fk FOREIGN KEY (PRODUCTO_ID)
      REFERENCES PRODUCTO(PRODUCTO_ID)
)
  LOB (ARCHIVO_FOTO) store as basicfile producto_foto_foto_blob(
    tablespace blob_mod1
    INDEX (tablespace indices_mod1))
;



-- 
-- TABLE: PRODUCTO_VIDEO 
--

CREATE TABLE PRODUCTO_VIDEO(
    VIDEO_ID         NUMBER(15, 0)    NOT NULL,
    ARCHIVO_VIDEO    BLOB             default empty_blob() NOT NULL,
    PRODUCTO_ID      NUMBER(15, 0)    NOT NULL,
    CONSTRAINT producto_video_pk PRIMARY KEY (VIDEO_ID) USING INDEX TABLESPACE indices_mod1, 
    CONSTRAINT producto_video_producto_id_fk FOREIGN KEY (PRODUCTO_ID)
      REFERENCES PRODUCTO(PRODUCTO_ID)
)
  LOB (ARCHIVO_VIDEO) store as basicfile producto_video_video_blob(
    tablespace blob_mod1
    INDEX (tablespace indices_mod1))
;



-- 
-- TABLE: TARJETA 
--

CREATE TABLE TARJETA(
    TARJETA_ID       NUMBER(15, 0)    NOT NULL,
    NUMERO           NUMBER(20, 0)    NOT NULL,
    BANCO            VARCHAR2(50)     NOT NULL,
    MES_EXP          NUMBER(2, 0)     NOT NULL,
    ANIO_EXP         NUMBER(4, 0)     NOT NULL,
    NUM_SEGURIDAD    NUMBER(3, 0)     NOT NULL,
    USUARIO_ID       NUMBER(10, 0)    NOT NULL,
    CONSTRAINT tarjeta_pk PRIMARY KEY (TARJETA_ID) USING INDEX TABLESPACE indices_mod1, 
    CONSTRAINT tarjeta_usuario_id_fk FOREIGN KEY (USUARIO_ID)
      REFERENCES USUARIO(USUARIO_ID),
    CONSTRAINT tarjeta_numero_uk unique (numero) USING INDEX TABLESPACE indices_mod1,
    CONSTRAINT tarjeta_mes_exp_chk check (
      mes_exp between 1 and 12),
    CONSTRAINT tarjeta_anio_exp_chk check (
      anio_exp > 2022),
    CONSTRAINT tarjeta_vigencia check (
      anio_exp > 2023 or mes_exp > 1)
) TABLESPACE cifrado_tarjeta
;


GRANT REFERENCES ON tarjeta  TO admin_mod2;
GRANT REFERENCES ON oferta   TO admin_mod2;
GRANT REFERENCES ON producto TO admin_mod2;

GRANT SELECT ON usuario to admin_mod2;
GRANT SELECT ON vendedor to admin_mod2;
GRANT SELECT ON ocupacion to admin_mod2;
GRANT SELECT ON comprador to admin_mod2;
GRANT SELECT ON tarjeta to admin_mod2;
GRANT SELECT ON tipo_producto to admin_mod2;
GRANT SELECT ON status_producto to admin_mod2;
GRANT SELECT ON producto to admin_mod2;
GRANT SELECT ON historico_status_producto to admin_mod2;
GRANT SELECT ON producto_foto to admin_mod2;
GRANT SELECT ON producto_video to admin_mod2;
GRANT SELECT ON oferta to admin_mod2;