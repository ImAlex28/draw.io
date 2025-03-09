
INSERT INTO TARJETA_TAB VALUES (
  TARJETA_OBJ(1111222233334444, 123, TO_DATE('2025-12-31','YYYY-MM-DD'))
);
INSERT INTO TARJETA_TAB VALUES (
  TARJETA_OBJ(2222333344445555, 234, TO_DATE('2026-06-30','YYYY-MM-DD'))
);
INSERT INTO TARJETA_TAB VALUES (
  TARJETA_OBJ(3333444455556666, 345, TO_DATE('2027-01-15','YYYY-MM-DD'))
);
INSERT INTO TARJETA_TAB VALUES (
  TARJETA_OBJ(4444555566667777, 456, TO_DATE('2025-08-20','YYYY-MM-DD'))
);
INSERT INTO TARJETA_TAB VALUES (
  TARJETA_OBJ(5555666677778888, 567, TO_DATE('2026-12-31','YYYY-MM-DD'))
);

INSERT INTO LIBRO_TAB VALUES (
  LIBRO_OBJ(
    '9783161484100',
    'El Principito',
    'Antoine de Saint-Exupéry',
    'Fantasía',
    'Español',
    'Un pequeño príncipe que viaja entre planetas y descubre la esencia de la amistad.',
    'portada1.jpg',
    EJEMPLARES_TABTYP(
      EJEMPLAR_OBJ(1, 'Nuevo', 'Tapa dura', 10.50, 'Sí', 5.00),
      EJEMPLAR_OBJ(2, 'Usado', 'Digital', 8.25, 'No', 3.50)
    )
  )
);

INSERT INTO LIBRO_TAB VALUES (
  LIBRO_OBJ(
    '9780141182803',
    'Cien Años de Soledad',
    'Gabriel García Márquez',
    'Realismo mágico',
    'Español',
    'La historia de la familia Buendía en el mítico pueblo de Macondo.',
    'portada2.jpg',
    EJEMPLARES_TABTYP(
      EJEMPLAR_OBJ(3, 'Nuevo', 'Tapa blanda', 12.00, 'Sí', 0.00),
      EJEMPLAR_OBJ(4, 'Usado', 'Digital', 9.50, 'Sí', 1.50)
    )
  )
);

INSERT INTO LIBRO_TAB VALUES (
  LIBRO_OBJ(
    '9788420471839',
    'Don Quijote de la Mancha',
    'Miguel de Cervantes',
    'Clásico',
    'Español',
    'Las aventuras del ingenioso hidalgo Don Quijote y su escudero Sancho.',
    'portada3.jpg',
    EJEMPLARES_TABTYP(
      EJEMPLAR_OBJ(5, 'Viejo', 'Tapa dura', 15.00, 'No', 2.00),
      EJEMPLAR_OBJ(6, 'Reacondicionado', 'Digital', 7.75, 'Sí', 1.00)
    )
  )
);

INSERT INTO LIBRO_TAB VALUES (
  LIBRO_OBJ(
    '9783161484101',
    'La Sombra del Viento',
    'Carlos Ruiz Zafón',
    'Misterio',
    'Español',
    'Un joven descubre un libro olvidado que cambiará su vida.',
    'portada4.jpg',
    EJEMPLARES_TABTYP(
      EJEMPLAR_OBJ(7, 'Nuevo', 'Tapa dura', 11.00, 'Sí', 0.00),
      EJEMPLAR_OBJ(8, 'Usado', 'Digital', 8.50, 'No', 1.50)
    )
  )
);

INSERT INTO EJEMPLARVENTA_TAB VALUES (
  EJEMPLARVENTA_OBJ(100, 'Nuevo', 'Tapa dura', 12.50, 'Sí', 0.00, 15.00)
);
INSERT INTO EJEMPLARVENTA_TAB VALUES (
  EJEMPLARVENTA_OBJ(101, 'Usado', 'Digital', 8.00, 'No', 2.00, 10.00)
);
INSERT INTO EJEMPLARVENTA_TAB VALUES (
  EJEMPLARVENTA_OBJ(102, 'Nuevo', 'Tapa blanda', 9.00, 'Sí', 1.50, 12.00)
);
INSERT INTO EJEMPLARVENTA_TAB VALUES (
  EJEMPLARVENTA_OBJ(103, 'Usado', 'Tapa dura', 7.50, 'No', 0.50, 9.00)
);
INSERT INTO EJEMPLARVENTA_TAB VALUES (
  EJEMPLARVENTA_OBJ(104, 'Nuevo', 'Digital', 10.00, 'Sí', 0.00, 13.50)
);

INSERT INTO EJEMPLARALQUILER_TAB VALUES (
  EJEMPLARALQUILER_OBJ(200, 'Reacondicionado', 'Digital', 6.00, 'Sí', 1.0, 3.50, 5)
);
INSERT INTO EJEMPLARALQUILER_TAB VALUES (
  EJEMPLARALQUILER_OBJ(201, 'Nuevo', 'Tapa blanda', 8.00, 'Sí', 0.0, 4.50, 7)
);
INSERT INTO EJEMPLARALQUILER_TAB VALUES (
  EJEMPLARALQUILER_OBJ(202, 'Usado', 'Digital', 5.00, 'No', 0.5, 2.50, 3)
);
INSERT INTO EJEMPLARALQUILER_TAB VALUES (
  EJEMPLARALQUILER_OBJ(203, 'Nuevo', 'Tapa dura', 10.00, 'Sí', 2.0, 5.00, 10)
);
INSERT INTO EJEMPLARALQUILER_TAB VALUES (
  EJEMPLARALQUILER_OBJ(204, 'Usado', 'Tapa blanda', 7.00, 'Sí', 1.0, 3.00, 4)
);

DECLARE
  v_tarjeta REF TARJETA_OBJ;
BEGIN
  SELECT REF(t) INTO v_tarjeta FROM TARJETA_TAB t WHERE t.Numero = 1111222233334444;
  INSERT INTO TRANSACCION_TAB VALUES (
    TRANSACCION_OBJ(1, TO_DATE('2023-10-01','YYYY-MM-DD'), v_tarjeta, 50.00)
  );
END;
/

DECLARE
  v_tarjeta REF TARJETA_OBJ;
BEGIN
  SELECT REF(t) INTO v_tarjeta FROM TARJETA_TAB t WHERE t.Numero = 2222333344445555;
  INSERT INTO TRANSACCION_TAB VALUES (
    TRANSACCION_OBJ(2, TO_DATE('2023-10-05','YYYY-MM-DD'), v_tarjeta, 75.50)
  );
END;
/

DECLARE
  v_tarjeta REF TARJETA_OBJ;
BEGIN
  SELECT REF(t) INTO v_tarjeta FROM TARJETA_TAB t WHERE t.Numero = 3333444455556666;
  INSERT INTO TRANSACCION_TAB VALUES (
    TRANSACCION_OBJ(3, TO_DATE('2023-10-07','YYYY-MM-DD'), v_tarjeta, 100.00)
  );
END;
/

DECLARE
  v_tarjeta REF TARJETA_OBJ;
BEGIN
  SELECT REF(t) INTO v_tarjeta FROM TARJETA_TAB t WHERE t.Numero = 1111222233334444;
  INSERT INTO COMPRA_TAB VALUES (
    COMPRA_OBJ(4, TO_DATE('2023-09-30','YYYY-MM-DD'), v_tarjeta, 85.00, 20)
  );
END;
/

DECLARE
  v_tarjeta REF TARJETA_OBJ;
BEGIN
  SELECT REF(t) INTO v_tarjeta FROM TARJETA_TAB t WHERE t.Numero = 2222333344445555;
  INSERT INTO COMPRA_TAB VALUES (
    COMPRA_OBJ(5, TO_DATE('2023-10-02','YYYY-MM-DD'), v_tarjeta, 65.50, 10)
  );
END;
/

DECLARE
  v_tarjeta REF TARJETA_OBJ;
BEGIN
  SELECT REF(t) INTO v_tarjeta FROM TARJETA_TAB t WHERE t.Numero = 3333444455556666;
  INSERT INTO ALQUILER_TAB VALUES (
    ALQUILER_OBJ(6, TO_DATE('2023-10-03','YYYY-MM-DD'), v_tarjeta, 40.00, 501, TO_DATE('2023-10-04','YYYY-MM-DD'))
  );
END;
/

DECLARE
  v_tarjeta REF TARJETA_OBJ;
BEGIN
  SELECT REF(t) INTO v_tarjeta FROM TARJETA_TAB t WHERE t.Numero = 1111222233334444;
  INSERT INTO ALQUILER_TAB VALUES (
    ALQUILER_OBJ(7, TO_DATE('2023-10-08','YYYY-MM-DD'), v_tarjeta, 55.00, 502, TO_DATE('2023-10-09','YYYY-MM-DD'))
  );
END;
/

INSERT INTO DIRECCION_TAB VALUES (DIRECCION_OBJ('Calle', 'Mayor', 12, 'A', 3));
INSERT INTO DIRECCION_TAB VALUES (DIRECCION_OBJ('Avenida', 'Siempre Viva', 742, 'B', 1));
INSERT INTO DIRECCION_TAB VALUES (DIRECCION_OBJ('Plaza', 'Independencia', 5, 'C', 2));
INSERT INTO DIRECCION_TAB VALUES (DIRECCION_OBJ('Calle', 'Secundaria', 34, 'D', 4));

INSERT INTO CLIENTE_TAB VALUES(
  CLIENTE_OBJ(
    1,
    'Juan Pérez',
    'juan.perez@example.com',
    'pass123',
    '5551234567',
    TO_DATE('1980-05-15','YYYY-MM-DD'),
    '12345678A',
    TRANSACCIONES_TABTYP(),
    (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.Nombre = 'Mayor' AND d.Numero = 12),
    10,
    'Premium'
  )
);

INSERT INTO CLIENTE_TAB VALUES(
  CLIENTE_OBJ(
    2,
    'Laura Gómez',
    'laura.gomez@example.com',
    'securepwd',
    '5559871234',
    TO_DATE('1990-07-20','YYYY-MM-DD'),
    '87654321B',
    TRANSACCIONES_TABTYP(),
    (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.Nombre = 'Siempre Viva' AND d.Numero = 742),
    5,
    'Basica'
  )
);

INSERT INTO CLIENTE_TAB VALUES(
  CLIENTE_OBJ(
    3,
    'Carlos Rios',
    'carlos.rios@example.com',
    'myPasswd!',
    '5551122334',
    TO_DATE('1985-03-10','YYYY-MM-DD'),
    '11223344C',
    TRANSACCIONES_TABTYP(),
    (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.Nombre = 'Independencia' AND d.Numero = 5),
    15,
    'Premium'
  )
);

INSERT INTO ADMINISTRADOR_TAB VALUES(
  ADMINISTRADOR_OBJ(
    10,
    'María García',
    'maria.garcia@example.com',
    'adminPass',
    '5559988776',
    TO_DATE('1975-11-20','YYYY-MM-DD'),
    '98765432D',
    TRANSACCIONES_TABTYP(),
    (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.Nombre = 'Mayor' AND d.Numero = 12),
    TO_DATE('2022-01-10','YYYY-MM-DD')
  )
);

INSERT INTO ADMINISTRADOR_TAB VALUES(
  ADMINISTRADOR_OBJ(
    11,
    'Ricardo López',
    'ricardo.lopez@example.com',
    'lopezAdmin',
    '5556677889',
    TO_DATE('1980-02-25','YYYY-MM-DD'),
    '55667788E',
    TRANSACCIONES_TABTYP(),
    (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.Nombre = 'Secundaria' AND d.Numero = 34),
    TO_DATE('2021-05-15','YYYY-MM-DD')
  )
);

DECLARE
  v_ejemplar REF EJEMPLARVENTA_OBJ;
BEGIN
  SELECT REF(e) INTO v_ejemplar FROM EJEMPLARVENTA_TAB e WHERE e.Id = 100;
  INSERT INTO LINEA_COMPRA_TAB VALUES (
    LINEA_COMPRA_OBJ(1, v_ejemplar, 2)
  );
END;
/

DECLARE
  v_ejemplar REF EJEMPLARVENTA_OBJ;
BEGIN
  SELECT REF(e) INTO v_ejemplar FROM EJEMPLARVENTA_TAB e WHERE e.Id = 102;
  INSERT INTO LINEA_COMPRA_TAB VALUES (
    LINEA_COMPRA_OBJ(2, v_ejemplar, 1)
  );
END;
/

DECLARE
  v_ejemplar REF EJEMPLARVENTA_OBJ;
BEGIN
  SELECT REF(e) INTO v_ejemplar FROM EJEMPLARVENTA_TAB e WHERE e.Id = 103;
  INSERT INTO LINEA_COMPRA_TAB VALUES (
    LINEA_COMPRA_OBJ(3, v_ejemplar, 3)
  );
END;
/

DECLARE
  v_ejemplar REF EJEMPLARALQUILER_OBJ;
BEGIN
  SELECT REF(e) INTO v_ejemplar FROM EJEMPLARALQUILER_TAB e WHERE e.Id = 200;
  INSERT INTO LINEA_ALQUILER_TAB VALUES (
    LINEA_ALQUILER_OBJ(1, v_ejemplar, 1)
  );
END;
/

DECLARE
  v_ejemplar REF EJEMPLARALQUILER_OBJ;
BEGIN
  SELECT REF(e) INTO v_ejemplar FROM EJEMPLARALQUILER_TAB e WHERE e.Id = 203;
  INSERT INTO LINEA_ALQUILER_TAB VALUES (
    LINEA_ALQUILER_OBJ(2, v_ejemplar, 2)
  );
END;
/

INSERT INTO PEDIDO_PROVEEDOR_TAB VALUES(
  PEDIDO_PROVEEDOR_OBJ(
    1,
    TO_DATE('2023-09-15','YYYY-MM-DD'),
    101,
    'Pendiente',
    LINEAS_PEDIDO_VARRAYTYP(
      LINEA_PEDIDO_OBJ(1, 10, 25.50),
      LINEA_PEDIDO_OBJ(2, 5, 30.00)
    )
  )
);

INSERT INTO PEDIDO_PROVEEDOR_TAB VALUES(
  PEDIDO_PROVEEDOR_OBJ(
    2,
    TO_DATE('2023-09-20','YYYY-MM-DD'),
    102,
    'Recibido',
    LINEAS_PEDIDO_VARRAYTYP(
      LINEA_PEDIDO_OBJ(3, 20, 15.00),
      LINEA_PEDIDO_OBJ(4, 8, 20.00)
    )
  )
);

INSERT INTO PEDIDO_PROVEEDOR_TAB VALUES(
  PEDIDO_PROVEEDOR_OBJ(
    3,
    TO_DATE('2023-09-25','YYYY-MM-DD'),
    101,
    'Cancelado',
    LINEAS_PEDIDO_VARRAYTYP(
      LINEA_PEDIDO_OBJ(5, 12, 22.00)
    )
  )
);

INSERT INTO PROVEEDOR_TAB VALUES(
  PROVEEDOR_OBJ(
    101,
    'proveedor101@example.com',
    'Proveedor Uno',
    '5553216548',
    PEDIDOS_PROVEEDOR_TABTYP(
      PEDIDO_PROVEEDOR_OBJ(
        4,
        TO_DATE('2023-09-30','YYYY-MM-DD'),
        101,
        'Recibido',
        LINEAS_PEDIDO_VARRAYTYP(
          LINEA_PEDIDO_OBJ(6, 20, 18.00)
        )
      )
    )
  )
);

INSERT INTO PROVEEDOR_TAB VALUES(
  PROVEEDOR_OBJ(
    102,
    'contacto@proveedor102.com',
    'Proveedor Dos',
    '5557845123',
    PEDIDOS_PROVEEDOR_TABTYP(
      PEDIDO_PROVEEDOR_OBJ(
        5,
        TO_DATE('2023-10-01','YYYY-MM-DD'),
        102,
        'Pendiente',
        LINEAS_PEDIDO_VARRAYTYP(
          LINEA_PEDIDO_OBJ(7, 15, 35.00),
          LINEA_PEDIDO_OBJ(8, 5, 40.00)
        )
      )
    )
  )
);


DECLARE
  v_ejemplarVenta REF EJEMPLARVENTA_OBJ;
  v_ejemplarAlquiler REF EJEMPLARALQUILER_OBJ;
BEGIN
  SELECT REF(e) INTO v_ejemplarVenta FROM EJEMPLARVENTA_TAB e WHERE e.Id = 100;
  SELECT REF(e) INTO v_ejemplarAlquiler FROM EJEMPLARALQUILER_TAB e WHERE e.Id = 200;

  INSERT INTO FACTURA_TAB VALUES(
    FACTURA_OBJ(
      1,
      100.50,
      'Factura de ejemplo 1',
      TO_DATE('2023-10-01','YYYY-MM-DD'),
      TO_DATE('2023-11-01','YYYY-MM-DD'),
      5.00,
      TRANSACCIONES_TABTYP(),
      LINEAS_COMPRA_TABTYP(
        LINEA_COMPRA_OBJ(4, v_ejemplarVenta, 1)
      ),
      LINEAS_ALQUILER_TABTYP(
        LINEA_ALQUILER_OBJ(3, v_ejemplarAlquiler, 1)
      )
    )
  );
END;
/

DECLARE
  v_ejemplarVenta REF EJEMPLARVENTA_OBJ;
  v_ejemplarAlquiler REF EJEMPLARALQUILER_OBJ;
BEGIN
  SELECT REF(e) INTO v_ejemplarVenta FROM EJEMPLARVENTA_TAB e WHERE e.Id = 101;
  SELECT REF(e) INTO v_ejemplarAlquiler FROM EJEMPLARALQUILER_TAB e WHERE e.Id = 203;

  INSERT INTO FACTURA_TAB VALUES(
    FACTURA_OBJ(
      2,
      150.00,
      'Factura de ejemplo 2',
      TO_DATE('2023-10-05','YYYY-MM-DD'),
      TO_DATE('2023-11-05','YYYY-MM-DD'),
      7.50,
      TRANSACCIONES_TABTYP(),
      LINEAS_COMPRA_TABTYP(
        LINEA_COMPRA_OBJ(5, v_ejemplarVenta, 2)
      ),
      LINEAS_ALQUILER_TABTYP(
        LINEA_ALQUILER_OBJ(4, v_ejemplarAlquiler, 1)
      )
    )
  );
END;
/

DECLARE
  v_ejemplarVenta REF EJEMPLARVENTA_OBJ;
  v_ejemplarAlquiler REF EJEMPLARALQUILER_OBJ;
BEGIN
  SELECT REF(e) INTO v_ejemplarVenta FROM EJEMPLARVENTA_TAB e WHERE e.Id = 102;
  SELECT REF(e) INTO v_ejemplarAlquiler FROM EJEMPLARALQUILER_TAB e WHERE e.Id = 201;

  INSERT INTO FACTURA_TAB VALUES(
    FACTURA_OBJ(
      3,
      200.75,
      'Factura de ejemplo 3',
      TO_DATE('2023-10-10','YYYY-MM-DD'),
      TO_DATE('2023-11-10','YYYY-MM-DD'),
      6.00,
      TRANSACCIONES_TABTYP(),
      LINEAS_COMPRA_TABTYP(
        LINEA_COMPRA_OBJ(6, v_ejemplarVenta, 1)
      ),
      LINEAS_ALQUILER_TABTYP(
        LINEA_ALQUILER_OBJ(5, v_ejemplarAlquiler, 2)
      )
    )
  );
END;
/


DECLARE
  v_alquiler REF ALQUILER_OBJ;
BEGIN
  SELECT REF(a) INTO v_alquiler FROM ALQUILER_TAB a WHERE a.IdTransaccion = 6;
  INSERT INTO CARGO_TAB VALUES(
    CARGO_OBJ(1, 5.50, TO_DATE('2023-10-04','YYYY-MM-DD'), v_alquiler)
  );
END;
/

DECLARE
  v_alquiler REF ALQUILER_OBJ;
BEGIN
  SELECT REF(a) INTO v_alquiler FROM ALQUILER_TAB a WHERE a.IdTransaccion = 7;
  INSERT INTO CARGO_TAB VALUES(
    CARGO_OBJ(2, 7.00, TO_DATE('2023-10-09','YYYY-MM-DD'), v_alquiler)
  );
END;
/


