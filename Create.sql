CREATE OR REPLACE TYPE LIBRO_OBJ AS OBJECT (
    ISBN VARCHAR2(20),
    Titulo VARCHAR2(40),
    Autor VARCHAR2(255),
    Genero VARCHAR2(100),
    Idioma VARCHAR2(50),
    Sinopsis VARCHAR(255),
    ImagenPortada VARCHAR2(60)

);
/

CREATE TABLE LIBRO_TAB OF LIBRO_OBJ (
 ISBN PRIMARY KEY
)
 NESTED TABLE Lineas STORE AS Lineas_ntab (
 ( PRIMARY KEY (NESTED_TABLE_ID,NL),
 CHECK (Cantidad > 0)) );


CREATE OR REPLACE TYPE t_proveedor AS OBJECT (
    Id NUMBER,
    Email VARCHAR2(255),
    Nombre VARCHAR2(255),
    Telefono VARCHAR2(20)
);
/

CREATE TABLE Proveedor OF t_proveedor PRIMARY KEY (Id);

CREATE OR REPLACE TYPE t_pedido_proveedor AS OBJECT (
    Id NUMBER,
    Fecha DATE,
    Estado VARCHAR2(50),
    IdProveedor REF t_proveedor
);
/

CREATE TABLE PedidoProveedor OF t_pedido_proveedor PRIMARY KEY (Id)
    NESTED TABLE IdProveedor STORE AS IdProveedor_tab;

CREATE OR REPLACE TYPE t_linea_pedido AS OBJECT (
    Id NUMBER,
    Cantidad NUMBER,
    PrecioUnitario NUMBER(10,2),
    IdPedido REF t_pedido_proveedor
);
/

CREATE TABLE LineaPedido OF t_linea_pedido PRIMARY KEY (Id)
    NESTED TABLE IdPedido STORE AS IdPedido_tab;

CREATE OR REPLACE TYPE EJEMPLAR_OBJ AS OBJECT (
    Id NUMBER,
    Estado VARCHAR2(50),
    Formato VARCHAR2(50),
    PrecioCoste NUMBER(10,2),
    Disponible CHAR(1),
    DescuentoPremium NUMBER(5,2),
    ISBN REF LIBRO_OBJ
) NOT FINAL;
/

CREATE TABLE Ejemplar OF EJEMPLAR_OBJ PRIMARY KEY (Id)
    NESTED TABLE ISBN STORE AS ISBN_tab;

CREATE OR REPLACE TYPE EJEMPLAR_OBJ_venta UNDER EJEMPLAR_OBJ (
    IdEjemplar REF EJEMPLAR_OBJ,
    PrecioVenta NUMBER(10,2)
);
/

CREATE TABLE EjemplarVenta OF EJEMPLAR_OBJ_venta PRIMARY KEY (IdEjemplar);

CREATE OR REPLACE TYPE EJEMPLAR_OBJ_alquiler UNDER EJEMPLAR_OBJ (
    IdEjemplar REF EJEMPLAR_OBJ,
    PrecioPorDia NUMBER(10,2),
    DuracionAlquiler NUMBER
);
/

CREATE TABLE EjemplarAlquiler OF EJEMPLAR_OBJ_alquiler PRIMARY KEY (IdEjemplar);

CREATE OR REPLACE TYPE t_factura AS OBJECT (
    IdFactura NUMBER,
    Precio NUMBER(10,2),
    Comentario VARCHAR2(500),
    FechaEmision DATE,
    FechaVencimiento DATE,
    CosteEnvio NUMBER(10,2)
);
/

CREATE TABLE Factura OF t_factura PRIMARY KEY (IdFactura);

CREATE OR REPLACE TYPE t_linea_factura AS OBJECT (
    IdLineaFactura NUMBER,
    PrecioArticulo NUMBER(10,2),
    IdFactura REF t_factura
);
/

CREATE TABLE LineaFactura OF t_linea_factura PRIMARY KEY (IdLineaFactura);

CREATE OR REPLACE TYPE t_transaccion AS OBJECT (
    IdTransaccion NUMBER,
    Fecha DATE,
    MetodoPago VARCHAR2(50),
    ImporteTotal NUMBER(10,2)
)NOT FINAL;
/

CREATE TABLE Transaccion OF t_transaccion PRIMARY KEY (IdTransaccion);

CREATE OR REPLACE TYPE t_compra UNDER t_transaccion (
    IdTransaccion REF t_transaccion,
    Puntos NUMBER
);
/

CREATE TABLE Compra OF t_compra PRIMARY KEY (IdTransaccion);

CREATE OR REPLACE TYPE t_alquiler UNDER t_transaccion (
    IdAlquiler NUMBER,
    FechaInicio DATE,
    IdTransaccion REF t_transaccion
);
/

CREATE TABLE Alquiler OF t_alquiler PRIMARY KEY (IdAlquiler);

CREATE OR REPLACE TYPE t_linea_compra AS OBJECT (
    IdLineaCompra NUMBER,
    IdEjemplarCompra REF EJEMPLAR_OBJ_venta
);
/

CREATE TABLE LineaCompra OF t_linea_compra PRIMARY KEY (IdLineaCompra);

CREATE OR REPLACE TYPE t_linea_alquiler AS OBJECT (
    IdLineaAlquiler NUMBER,
    IdEjemplarAlquiler REF EJEMPLAR_OBJ_alquiler
);
/

CREATE TABLE LineaAlquiler OF t_linea_alquiler PRIMARY KEY (IdLineaAlquiler);

CREATE OR REPLACE TYPE USUARIO_OBJ AS OBJECT (
    Id NUMBER,
    Nombre VARCHAR2(255),
    CorreoElectronico VARCHAR2(255),
    Contrasena VARCHAR2(255),
    NumeroTlf VARCHAR2(20),
    FechaNacimiento DATE,
    DNI VARCHAR2(20)
)NOT FINAL;
/

 CREATE TABLE USUARIO_TAB OF USUARIO_OBJ (
 Id PRIMARY KEY,
 DNI UNIQUE NOT NULL,
 "REFERENCIA TABLA TRANSACCION");

CREATE OR REPLACE TYPE t_cliente UNDER USUARIO_OBJ (
    Id REF USUARIO_OBJ,
    Puntuacion NUMBER,
    TipoCuenta VARCHAR2(50)
);
/

CREATE TABLE Cliente OF t_cliente PRIMARY KEY (Id);

CREATE OR REPLACE TYPE t_administrador AS OBJECT (
    Id REF USUARIO_OBJ,
    FechaDeAlta DATE
);
/

CREATE TABLE Administrador OF t_administrador PRIMARY KEY (Id);

CREATE OR REPLACE TYPE t_direccion UNDER USUARIO_OBJ (
    Id NUMBER,
    TipoDeVia VARCHAR2(50),
    Nombre VARCHAR2(255),
    Numero VARCHAR2(10),
    Piso VARCHAR2(10),
    Puerta VARCHAR2(10),
    IdUsuario REF USUARIO_OBJ
);
/

CREATE TABLE Direccion OF t_direccion PRIMARY KEY (Id);

CREATE OR REPLACE TYPE t_resena AS OBJECT (
    IdResena NUMBER,
    TextoResena CLOB,
    Puntuacion NUMBER(5,2),
    Estrellas NUMBER(1),
    IdCliente REF t_cliente
);
/

CREATE TABLE Resena OF t_resena PRIMARY KEY (IdResena);
