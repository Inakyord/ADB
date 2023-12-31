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
    NOMBRE            VARCHAR2(40)     NOT NULL,
    AP_PATERNO        VARCHAR2(40)     NOT NULL,
    AP_MATERNO        VARCHAR2(40)     NOT NULL,
    USERNAME          VARCHAR2(40)     NOT NULL,
    PASSWORD          VARCHAR2(20)     NOT NULL,
    EMAIL             VARCHAR2(50)     NOT NULL,
    FECHA_REGISTRO    DATE             NOT NULL,
    FOTO              BLOB             NOT NULL,
    RFC               CHAR(13)         NOT NULL,
    ES_COMPRADOR      CHAR(1)          NOT NULL,
    ES_VENDEDOR       CHAR(1)          NOT NULL,
    CONSTRAINT PK1 PRIMARY KEY (USUARIO_ID)
)
;



-- 
-- TABLE: OCUPACION 
--

CREATE TABLE OCUPACION(
    OCUPACION_ID        NUMBER(3, 0)    NOT NULL,
    NOMBRE_OCUPACION    VARCHAR2(40)    NOT NULL,
    DESCRIPCION         VARCHAR2(200)   NOT NULL,
    CONSTRAINT PK18 PRIMARY KEY (OCUPACION_ID)
)
;



-- 
-- TABLE: COMPRADOR 
--

CREATE TABLE COMPRADOR(
    USUARIO_ID      NUMBER(10, 0)    NOT NULL,
    DESCRIPCION     VARCHAR2(300)    NOT NULL,
    CELULAR         NUMBER(15, 0)    NOT NULL,
    OCUPACION_ID    NUMBER(3, 0)     NOT NULL,
    CONSTRAINT PK3 PRIMARY KEY (USUARIO_ID), 
    CONSTRAINT RefUSUARIO3 FOREIGN KEY (USUARIO_ID)
    REFERENCES USUARIO(USUARIO_ID),
    CONSTRAINT RefOCUPACION8 FOREIGN KEY (OCUPACION_ID)
    REFERENCES OCUPACION(OCUPACION_ID)
)
;



-- 
-- TABLE: STATUS_PRODUCTO 
--

CREATE TABLE STATUS_PRODUCTO(
    STATUS_PRODUCTO_ID    NUMBER(1, 0)     NOT NULL,
    NOMBRE                VARCHAR2(40)     NOT NULL,
    DESCRIPCION           VARCHAR2(150)    NOT NULL,
    CONSTRAINT PK8 PRIMARY KEY (STATUS_PRODUCTO_ID)
)
;



-- 
-- TABLE: VENDEDOR 
--

CREATE TABLE VENDEDOR(
    USUARIO_ID       NUMBER(10, 0)    NOT NULL,
    DIRECCION        VARCHAR2(150)    NOT NULL,
    CALIFICACION     NUMBER(3, 1)     NOT NULL,
    TIPO_VENDEDOR    NUMBER(1, 0)     NOT NULL,
    CONSTRAINT PK2 PRIMARY KEY (USUARIO_ID), 
    CONSTRAINT RefUSUARIO5 FOREIGN KEY (USUARIO_ID)
    REFERENCES USUARIO(USUARIO_ID)
)
;



-- 
-- TABLE: TIPO_PRODUCTO 
--

CREATE TABLE TIPO_PRODUCTO(
    TIPO_PRODUCTO_ID    NUMBER(1, 0)     NOT NULL,
    NOMBRE              VARCHAR2(40)     NOT NULL,
    DESCRIPCION         VARCHAR2(200)    NOT NULL,
    CONSTRAINT PK7 PRIMARY KEY (TIPO_PRODUCTO_ID)
)
;



-- 
-- TABLE: PRODUCTO 
--

CREATE TABLE PRODUCTO(
    PRODUCTO_ID             NUMBER(15, 0)    NOT NULL,
    NOMBRE                  VARCHAR2(40)     NOT NULL,
    DESCRIPCION             VARCHAR2(500)    NOT NULL,
    DESCRIPCION_DEFECTOS    VARCHAR2(500)    NOT NULL,
    INICIO_VIDA             DATE             NOT NULL,
    PRECIO_INICIAL          NUMBER(12, 2)    NOT NULL,
    FECHA_STATUS            DATE             NOT NULL,
    VENDEDOR_ID             NUMBER(10, 0)    NOT NULL,
    TIPO_PRODUCTO_ID        NUMBER(1, 0)     NOT NULL,
    STATUS_PRODUCTO_ID      NUMBER(1, 0)     NOT NULL,
    CONSTRAINT PK4 PRIMARY KEY (PRODUCTO_ID), 
    CONSTRAINT RefVENDEDOR11 FOREIGN KEY (VENDEDOR_ID)
    REFERENCES VENDEDOR(USUARIO_ID),
    CONSTRAINT RefTIPO_PRODUCTO12 FOREIGN KEY (TIPO_PRODUCTO_ID)
    REFERENCES TIPO_PRODUCTO(TIPO_PRODUCTO_ID),
    CONSTRAINT RefSTATUS_PRODUCTO15 FOREIGN KEY (STATUS_PRODUCTO_ID)
    REFERENCES STATUS_PRODUCTO(STATUS_PRODUCTO_ID)
)
;



-- 
-- TABLE: HISTORICO_STATUS_PRODUCTO 
--

CREATE TABLE HISTORICO_STATUS_PRODUCTO(
    HISTORICO_STATUS_PRODUCTO_ID    NUMBER(15, 0)    NOT NULL,
    FECHA                           DATE             NOT NULL,
    STATUS_PRODUCTO_ID              NUMBER(1, 0)     NOT NULL,
    PRODUCTO_ID                     NUMBER(15, 0)    NOT NULL,
    CONSTRAINT PK17 PRIMARY KEY (HISTORICO_STATUS_PRODUCTO_ID), 
    CONSTRAINT RefSTATUS_PRODUCTO16 FOREIGN KEY (STATUS_PRODUCTO_ID)
    REFERENCES STATUS_PRODUCTO(STATUS_PRODUCTO_ID),
    CONSTRAINT RefPRODUCTO17 FOREIGN KEY (PRODUCTO_ID)
    REFERENCES PRODUCTO(PRODUCTO_ID)
)
;



-- 
-- TABLE: OFERTA 
--

CREATE TABLE OFERTA(
    OFERTA_ID       NUMBER(15, 0)    NOT NULL,
    FECHA_HORA      DATE             NOT NULL,
    IMPORTE         NUMBER(12, 2)    NOT NULL,
    COMPRADOR_ID    NUMBER(10, 0)    NOT NULL,
    PRODUCTO_ID     NUMBER(15, 0)    NOT NULL,
    CONSTRAINT PK9 PRIMARY KEY (OFERTA_ID), 
    CONSTRAINT RefCOMPRADOR9 FOREIGN KEY (COMPRADOR_ID)
    REFERENCES COMPRADOR(USUARIO_ID),
    CONSTRAINT RefPRODUCTO23 FOREIGN KEY (PRODUCTO_ID)
    REFERENCES PRODUCTO(PRODUCTO_ID)
)
;



-- 
-- TABLE: PRODUCTO_FOTO 
--

CREATE TABLE PRODUCTO_FOTO(
    FOTO_ID         NUMBER(16, 0)    NOT NULL,
    ARCHIVO_FOTO    BLOB             NOT NULL,
    PRODUCTO_ID     NUMBER(15, 0)    NOT NULL,
    CONSTRAINT PK20 PRIMARY KEY (FOTO_ID), 
    CONSTRAINT RefPRODUCTO13 FOREIGN KEY (PRODUCTO_ID)
    REFERENCES PRODUCTO(PRODUCTO_ID)
)
;



-- 
-- TABLE: PRODUCTO_VIDEO 
--

CREATE TABLE PRODUCTO_VIDEO(
    VIDEO_ID         NUMBER(15, 0)    NOT NULL,
    ARCHIVO_VIDEO    BLOB             NOT NULL,
    PRODUCTO_ID      NUMBER(15, 0)    NOT NULL,
    CONSTRAINT PK19 PRIMARY KEY (VIDEO_ID), 
    CONSTRAINT RefPRODUCTO14 FOREIGN KEY (PRODUCTO_ID)
    REFERENCES PRODUCTO(PRODUCTO_ID)
)
;



-- 
-- TABLE: TARJETA 
--

CREATE TABLE TARJETA(
    TARJETA_ID       NUMBER(15, 0)    NOT NULL,
    NUMERO           NUMBER(20, 0)    NOT NULL,
    BANCO            VARCHAR2(40)     NOT NULL,
    MES_EXP          NUMBER(2, 0)     NOT NULL,
    ANIO_EXP         NUMBER(4, 0)     NOT NULL,
    NUM_SEGURIDAD    NUMBER(3, 0)     NOT NULL,
    USUARIO_ID       NUMBER(10, 0)    NOT NULL,
    CONSTRAINT PK13 PRIMARY KEY (TARJETA_ID), 
    CONSTRAINT RefUSUARIO19 FOREIGN KEY (USUARIO_ID)
    REFERENCES USUARIO(USUARIO_ID)
)
;



