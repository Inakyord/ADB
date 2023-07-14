--@Autor:           Iñaky Ordiales Caballero
--@Fecha creación:  17/01/2022
--@Descripción:     Creación de tablas del modelo módulo 2 (Proyecto Final BDA)


prompt
prompt
prompt Empezando a crear tablas del módulo 2.
prompt

connect admin_mod2/adminorca

--
-- ER/Studio 8.0 SQL Code Generation
-- Company :      UNAM
-- Project :      Modulo2.DM1
-- Author :       InakyO
--
-- Date Created : Wednesday, January 18, 2023 23:07:37
-- Target DBMS : Oracle 11g
--

-- 
-- TABLE: ORDEN_COMPRA 
--

CREATE TABLE ORDEN_COMPRA(
    ORDEN_COMPRA_ID      NUMBER(16, 0)    NOT NULL,
    FECHA_HORA           DATE             default sysdate NOT NULL,
    DIRECCION_ENTREGA    VARCHAR2(300)    NOT NULL,
    TIPO_DE_PAGO         NUMBER(1, 0)     NOT NULL,
    TARJETA_ID           NUMBER(15, 0)    NOT NULL,
    CONSTRAINT orden_compra_pk PRIMARY KEY (ORDEN_COMPRA_ID) USING INDEX TABLESPACE indices_mod2,
    CONSTRAINT orden_compra_tarjeta_id_fk FOREIGN KEY (TARJETA_ID)
      REFERENCES admin_mod1.tarjeta(tarjeta_id),
    CONSTRAINT orden_compra_tipo_pago_chk check (
      (tipo_de_pago = 1) or (tipo_de_pago = 3) or (tipo_de_pago = 6))
)
;



-- 
-- TABLE: PAQUETERIA 
--

CREATE TABLE PAQUETERIA(
    PAQUETERIA_ID    NUMBER(2, 0)    NOT NULL,
    NOMBRE           VARCHAR2(50)    NOT NULL,
    CONSTRAINT paqueteria_pk PRIMARY KEY (PAQUETERIA_ID) USING INDEX TABLESPACE indices_mod2,
    CONSTRAINT paqueteria_nombre_uk unique (nombre) USING INDEX TABLESPACE indices_mod2
)
;



-- 
-- TABLE: FACTURA 
--

CREATE TABLE FACTURA(
    FACTURA_ID         NUMBER(10, 0)    NOT NULL,
    FOLIO              CHAR(6)          NOT NULL,
    COMISION           NUMBER(10, 2)    NOT NULL,
    ORDEN_COMPRA_ID    NUMBER(16, 0)    NOT NULL,
    PAQUETERIA_ID      NUMBER(2, 0)     NOT NULL,
    CONSTRAINT factura_pk PRIMARY KEY (FACTURA_ID) USING INDEX TABLESPACE indices_mod2, 
    CONSTRAINT factura_orden_compra_id_fk FOREIGN KEY (ORDEN_COMPRA_ID)
      REFERENCES ORDEN_COMPRA(ORDEN_COMPRA_ID),
    CONSTRAINT factura_paqueteria_id_fk FOREIGN KEY (PAQUETERIA_ID)
      REFERENCES PAQUETERIA(PAQUETERIA_ID),
    CONSTRAINT factura_folio_uk unique (folio) USING INDEX TABLESPACE indices_mod2
)
;



-- 
-- TABLE: SUBASTA 
--

CREATE TABLE SUBASTA(
    SUBASTA_ID         NUMBER(10, 0)    NOT NULL,
    FECHA_HORA         DATE             default sysdate NOT NULL,
    TOTAL_PRODUCTOS    NUMBER(4, 0)     NOT NULL,
    FECHA_CIERRE       DATE             default (sysdate+interval '3' hour) NOT NULL,
    CONSTRAINT subasta_pk PRIMARY KEY (SUBASTA_ID) USING INDEX TABLESPACE indices_mod2
)
;

CREATE INDEX subasta_fecha_cierre ON subasta(fecha_cierre) TABLESPACE indices_mod2;


-- 
-- TABLE: PRODUCTO_SUBASTA 
--

CREATE TABLE PRODUCTO_SUBASTA(
    PRODUCTO_SUBASTA_ID    NUMBER(15, 0)    NOT NULL,
    CALIFICACION           NUMBER(1, 0),
    PRODUCTO_ID            NUMBER(15, 0)    NOT NULL,
    OFERTA_GANADOR_ID      NUMBER(15, 0),
    SUBASTA_ID             NUMBER(10, 0)    NOT NULL,
    ORDEN_COMPRA_ID        NUMBER(16, 0),
    CONSTRAINT producto_subasta_pk PRIMARY KEY (PRODUCTO_SUBASTA_ID) USING INDEX TABLESPACE indices_mod2, 
    CONSTRAINT producto_subasta_producto_id_fk FOREIGN KEY (PRODUCTO_ID)
      REFERENCES admin_mod1.producto(producto_id),
    CONSTRAINT producto_subasta_orden_compra_id_fk FOREIGN KEY (ORDEN_COMPRA_ID)
      REFERENCES ORDEN_COMPRA(ORDEN_COMPRA_ID),
    CONSTRAINT producto_subasta_subasta_id_fk FOREIGN KEY (SUBASTA_ID)
      REFERENCES SUBASTA(SUBASTA_ID),
    CONSTRAINT producto_subasta_oferta_ganador_id_fk FOREIGN KEY (OFERTA_GANADOR_ID)
      REFERENCES admin_mod1.oferta(oferta_id),
    CONSTRAINT producto_subasta_calificacion_chk check (
      calificacion between 1 and 5)
)
;



-- 
-- TABLE: MONITOREO 
--

CREATE TABLE MONITOREO(
    PRODUCTO_SUBASTA_ID    NUMBER(15, 0)    NOT NULL,
    NUM_REGISTRO           NUMBER(5, 0)     NOT NULL,
    FECHA                  DATE             default sysdate NOT NULL,
    LATITUD                NUMBER(10, 8)    NOT NULL,
    LONGITUD               NUMBER(11, 8)    NOT NULL,
    CONSTRAINT monitoreo_pk PRIMARY KEY (PRODUCTO_SUBASTA_ID, NUM_REGISTRO) USING INDEX TABLESPACE indices_mod2, 
    CONSTRAINT monitoreo_producto_subasta_id_fk FOREIGN KEY (PRODUCTO_SUBASTA_ID)
      REFERENCES PRODUCTO_SUBASTA(PRODUCTO_SUBASTA_ID),
    CONSTRAINT monitoreo_latitud_check check (
      latitud between -90 and 90 ),
    CONSTRAINT monitoreo_longitud_check check (
    longitud between -180 and 180)
)
;



-- 
-- TABLE: PRODUCTO_COMENTARIO 
--

CREATE TABLE PRODUCTO_COMENTARIO(
    PRODUCTO_COMENTARIO_ID    NUMBER(15, 0)    NOT NULL,
    COMENTARIO                VARCHAR2(650)    NOT NULL,
    FECHA                     DATE             default sysdate NOT NULL,
    PRODUCTO_SUBASTA_ID       NUMBER(15, 0)    NOT NULL,
    CONSTRAINT producto_comentario_pk PRIMARY KEY (PRODUCTO_COMENTARIO_ID) USING INDEX TABLESPACE indices_mod2, 
    CONSTRAINT producto_comentario_producto_subasta_id_fk FOREIGN KEY (PRODUCTO_SUBASTA_ID)
      REFERENCES PRODUCTO_SUBASTA(PRODUCTO_SUBASTA_ID)
)
;


GRANT SELECT ON orden_compra to admin_mod1;
GRANT SELECT ON paqueteria to admin_mod1;
GRANT SELECT ON factura to admin_mod1;
GRANT SELECT ON subasta to admin_mod1;
GRANT SELECT ON producto_subasta to admin_mod1;
GRANT SELECT ON producto_comentario to admin_mod1;
GRANT SELECT ON monitoreo to admin_mod1;