/**********************************************************
  -- INSERTS PARA TABLAS “BASE” (objetos independientes)
**********************************************************/
/* DIRECCIONES: Inserta unos cuantos domicilios */
INSERT INTO DIRECCION_TAB
  VALUES(DIRECCION_OBJ('Calle', 'Mayor', 23, 2, 'B', 'Madrid'));

INSERT INTO DIRECCION_TAB
  VALUES(DIRECCION_OBJ('Avenida', 'Diagonal', 45, 3, 'A', 'Barcelona'));

INSERT INTO DIRECCION_TAB
  VALUES(DIRECCION_OBJ('Plaza', 'Nueva', 1, 1, 'C', 'Valencia'));

INSERT INTO DIRECCION_TAB
  VALUES(DIRECCION_OBJ('Camino', 'Real', 12, 0, 'D', 'Sevilla'));

/* TARJETAS: Dos ejemplos de tarjetas de crédito */
INSERT INTO TARJETA_TAB
  VALUES(TARJETA_OBJ(1234567890123456, 123, TO_DATE('2028-12-31','YYYY-MM-DD')));

INSERT INTO TARJETA_TAB
  VALUES(TARJETA_OBJ(9876543210987654, 456, TO_DATE('2027-06-30','YYYY-MM-DD')));

/* PROVEEDORES: Tres proveedores para poder referenciarlos desde LIBRO_TAB */
INSERT INTO PROVEEDOR_TAB
  VALUES(PROVEEDOR_OBJ(1, 'Proveedor Uno', 'proveedor1@ejemplo.com', 600123456));

INSERT INTO PROVEEDOR_TAB
  VALUES(PROVEEDOR_OBJ(2, 'Proveedor Dos', 'contacto@proveedordos.com', 600654321));

INSERT INTO PROVEEDOR_TAB
  VALUES(PROVEEDOR_OBJ(3, 'Proveedor Tres', 'info@proveedortres.com', 600789012));

/* CLIENTES: Inserta varios CLIENTE_OBJ (subtipo de USUARIO_OBJ).
   Se utiliza subconsulta con REF para enlazar la dirección.
   Nota: Asegúrate que las condiciones del WHERE identifiquen unívocamente el objeto. */
INSERT INTO CLIENTE_TAB
  VALUES(
    CLIENTE_OBJ(
      1,
      'Alejandro', 'Pérez', 'García',
      'alejandro@correo.com', 'pass123',
      600111222, TO_DATE('1990-01-15','YYYY-MM-DD'), '12345678A',
      (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Mayor'),
      400, 'Premium'
    )
  );

INSERT INTO CLIENTE_TAB
  VALUES(
    CLIENTE_OBJ(
      2,
      'María', 'López', 'Fernández',
      'maria@correo.com', 'maria456',
      600222333, TO_DATE('1988-03-22','YYYY-MM-DD'), '87654321B',
      (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Diagonal'),
      250, 'Premium'
    )
  );

INSERT INTO CLIENTE_TAB
  VALUES(
    CLIENTE_OBJ(
      3,
      'Carlos', 'Sánchez', 'Ramírez',
      'carlos@correo.com', 'carlos789',
      600333444, TO_DATE('1992-07-30','YYYY-MM-DD'), '11223344C',
      (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Nueva'),
      100, 'Estandar'
    )
  );

/* ADMINISTRADORES: Dos administradores, utilizando también REF para la dirección */
INSERT INTO ADMINISTRADOR_TAB
  VALUES(
    ADMINISTRADOR_OBJ(
      1,
      'Laura', 'Martínez', 'Sánchez',
      'laura@correo.com', 'adminpass1',
      600444555, TO_DATE('1985-05-20','YYYY-MM-DD'), '98765432D',
      (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Diagonal'),
      TO_DATE('2020-03-10','YYYY-MM-DD')
    )
  );

INSERT INTO ADMINISTRADOR_TAB
  VALUES(
    ADMINISTRADOR_OBJ(
      2,
      'Miguel', 'Gómez', 'Díaz',
      'miguel@correo.com', 'adminpass2',
      600555666, TO_DATE('1980-11-05','YYYY-MM-DD'), '55667788E',
      (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Real'),
      TO_DATE('2019-08-15','YYYY-MM-DD')
    )
  );

/**********************************************************
  -- INSERTS PARA TABLAS DE EJEMPLARES
**********************************************************/
/* EJEMPLAR_VENTA_TAB: Registra ejemplares para venta
   La estructura es: id, estado, formato, preciocoste, disponible, descuentopremium, precio_venta */
INSERT INTO EJEMPLAR_VENTA_TAB
  VALUES(EJEMPLAR_VENTA_OBJ(1, 'Nuevo', 'Tapa dura', 10, 1, 0, 20));

INSERT INTO EJEMPLAR_VENTA_TAB
  VALUES(EJEMPLAR_VENTA_OBJ(2, 'Usado', 'Paperback', 5, 1, 10, 15));

INSERT INTO EJEMPLAR_VENTA_TAB
  VALUES(EJEMPLAR_VENTA_OBJ(5, 'Nuevo', 'Ebook', 2, 1, 0, 5));

/* EJEMPLAR_ALQUILER_TAB: Registra ejemplares para alquiler.
   La estructura es: id, estado, formato, preciocoste, disponible, descuentopremium, precio_por_dia, duracion_alquiler */
INSERT INTO EJEMPLAR_ALQUILER_TAB
  VALUES(EJEMPLAR_ALQUILER_OBJ(3, 'Nuevo', 'Digital', 8, 1, 5, 2, 7));

INSERT INTO EJEMPLAR_ALQUILER_TAB
  VALUES(EJEMPLAR_ALQUILER_OBJ(4, 'Usado', 'Paperback', 4, 1, 0, 1, 5));

INSERT INTO EJEMPLAR_ALQUILER_TAB
  VALUES(EJEMPLAR_ALQUILER_OBJ(6, 'Nuevo', 'Audiobook', 3, 1, 2, 3, 10));

/**********************************************************
  -- INSERTS PARA TABLA DE LIBROS
  -- Cada LIBRO_OBJ contiene además dos tablas anidadas:
  --   EJEMPLARESVENTA: Table of REF EJEMPLAR_VENTA_OBJ.
  --   EJEMPLARESALQUILER: Table of REF EJEMPLAR_ALQUILER_OBJ.
  -- Además se asocia un proveedor mediante REF.
**********************************************************/
INSERT INTO LIBRO_TAB
  VALUES(
    LIBRO_OBJ(
      '9783161484100',
      'El Quijote',
      'Miguel de Cervantes',
      'Novela',
      'Español',
      'Una novela de aventuras y caballería ambientada en la España del Siglo de Oro.',
      'quijote.jpg',
      EJEMPLARESVENTA_NTABTYP(
         (SELECT REF(e) FROM EJEMPLAR_VENTA_TAB e WHERE e.ID = 1),
         (SELECT REF(e) FROM EJEMPLAR_VENTA_TAB e WHERE e.ID = 2)
      ),
      EJEMPLARESALQUILER_NTABTYP(
         (SELECT REF(ea) FROM EJEMPLAR_ALQUILER_TAB ea WHERE ea.ID = 3)
      ),
      (SELECT REF(p) FROM PROVEEDOR_TAB p WHERE p.ID = 1)
    )
  );

INSERT INTO LIBRO_TAB
  VALUES(
    LIBRO_OBJ(
      '9781234567897',
      'La sombra del viento',
      'Carlos Ruiz Zafón',
      'Misterio',
      'Español',
      'Una intrigante novela ambientada en la Barcelona de la posguerra.',
      'sombra.jpg',
      EJEMPLARESVENTA_NTABTYP(
         (SELECT REF(e) FROM EJEMPLAR_VENTA_TAB e WHERE e.ID = 2)
      ),
      EJEMPLARESALQUILER_NTABTYP(
         (SELECT REF(ea) FROM EJEMPLAR_ALQUILER_TAB ea WHERE ea.ID = 4)
      ),
      (SELECT REF(p) FROM PROVEEDOR_TAB p WHERE p.ID = 2)
    )
  );

INSERT INTO LIBRO_TAB
  VALUES(
    LIBRO_OBJ(
      '9780987654321',
      'Cien años de soledad',
      'Gabriel García Márquez',
      'Realismo mágico',
      'Español',
      'La historia de la familia Buendía a lo largo de generaciones en el pueblo ficticio de Macondo.',
      'soledad.jpg',
      EJEMPLARESVENTA_NTABTYP(
         (SELECT REF(e) FROM EJEMPLAR_VENTA_TAB e WHERE e.ID = 5)
      ),
      EJEMPLARESALQUILER_NTABTYP(
         (SELECT REF(ea) FROM EJEMPLAR_ALQUILER_TAB ea WHERE ea.ID = 6)
      ),
      (SELECT REF(p) FROM PROVEEDOR_TAB p WHERE p.ID = 3)
    )
  );

/**********************************************************
  -- INSERTS PARA TRANSACCIONES
  -- Se deberán poblar las tablas COMPRA_TAB y ALQUILER_TAB,
  -- las cuales son subtipos de TRANSACCION_OBJ.
  -- Se utilizó, para cada caso, una línea de pedido o de alquiler
  -- representada en una tabla anidada.
**********************************************************/
/* COMPRA_TAB: La estructura (heredada de TRANSACCION_OBJ) es:
   ID, FECHA, IMPORTE, TIPO, COSTEENVIO, TARJETA (REF), DIRECCION (REF),
   USUARIO (REF), PUNTOS y LINEA_COMPRA (tabla anidada de LINEAPEDIDO_OBJ) */
-- Insert de la primera transacción de compra utilizando LINEA_COMPRA_OBJ
INSERT INTO COMPRA_TAB
  VALUES(
    COMPRA_OBJ(
      1,  -- ID de la transacción
      TO_DATE('2025-04-10','YYYY-MM-DD'),
      40,  -- Importe
      'Compra',
      5,   -- Coste de envío
      (SELECT REF(t) FROM TARJETA_TAB t WHERE t.NUMERO = 1234567890123456),
      (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Mayor'),
      (SELECT REF(c) FROM CLIENTE_TAB c WHERE c.DNI = '12345678A'),
      400,  -- Puntos
      LINEA_COMPRA_NTABTYP(
         LINEA_COMPRA_OBJ(
            1,  -- ID_LINEACOMPRA
            (SELECT REF(e) FROM EJEMPLAR_VENTA_TAB e WHERE e.ID = 1),
            2,  -- Cantidad
            RESENA_OBJ(
               101,   -- ID de la reseña
               'Muy buena calidad, recomendado para lectura.',
               5,     -- Puntuación
               5,     -- Número de estrellas
               (SELECT REF(c) FROM CLIENTE_TAB c WHERE c.DNI = '12345678A'),
               (SELECT REF(a) FROM ADMINISTRADOR_TAB a WHERE a.DNI = '98765432D')
            )
         )
      )
    )
  );

-- Insert de la segunda transacción de compra utilizando LINEA_COMPRA_OBJ
INSERT INTO COMPRA_TAB
  VALUES(
    COMPRA_OBJ(
      2,
      TO_DATE('2025-04-15','YYYY-MM-DD'),
      25,
      'Compra',
      3,
      (SELECT REF(t) FROM TARJETA_TAB t WHERE t.NUMERO = 9876543210987654),
      (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Nueva'),
      (SELECT REF(c) FROM CLIENTE_TAB c WHERE c.DNI = '87654321B'),
      250,
      LINEA_COMPRA_NTABTYP(
         LINEA_COMPRA_OBJ(
            1,
            (SELECT REF(e) FROM EJEMPLAR_VENTA_TAB e WHERE e.ID = 2),
            1,
            RESENA_OBJ(
               102,
               'El ejemplar está en buen estado, compra satisfactoria.',
               4,
               4,
               (SELECT REF(c) FROM CLIENTE_TAB c WHERE c.DNI = '87654321B'),
               (SELECT REF(a) FROM ADMINISTRADOR_TAB a WHERE a.DNI = '55667788E')
            )
         )
      )
    )
  );


/* ALQUILER_TAB: La estructura (heredada de TRANSACCION_OBJ) es:
   ID, FECHA, IMPORTE, TIPO, COSTEENVIO, TARJETA (REF), DIRECCION (REF),
   USUARIO (REF), además de FECHAINICIO, CARGO (objeto CARGO_OBJ) y
   LINEA_ALQUILER (tabla anidada de LINEA_ALQUILER_OBJ) */
INSERT INTO ALQUILER_TAB
  VALUES(
    ALQUILER_OBJ(
      3,
      TO_DATE('2025-04-11','YYYY-MM-DD'),
      30,
      'Alquiler',
      3,
      (SELECT REF(t) FROM TARJETA_TAB t WHERE t.NUMERO = 9876543210987654),
      (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Diagonal'),
      (SELECT REF(c) FROM CLIENTE_TAB c WHERE c.DNI = '12345678A'),
      TO_DATE('2025-04-11','YYYY-MM-DD'),
      CARGO_OBJ(2, TO_DATE('2025-04-12','YYYY-MM-DD')),
      LINEA_ALQUILER_NTABTYP(
         LINEA_ALQUILER_OBJ(
           1,
           (SELECT REF(ea) FROM EJEMPLAR_ALQUILER_TAB ea WHERE ea.ID = 3),
           1,
           RESENA_OBJ(
               1,
               'Excelente calidad, muy recomendable.',
               5,
               5,
               (SELECT REF(c) FROM CLIENTE_TAB c WHERE c.DNI = '12345678A'),
               (SELECT REF(a) FROM ADMINISTRADOR_TAB a WHERE a.DNI = '98765432D')
           )
         )
      )
    )
  );

INSERT INTO ALQUILER_TAB
  VALUES(
    ALQUILER_OBJ(
      4,
      TO_DATE('2025-04-18','YYYY-MM-DD'),
      20,
      'Alquiler',
      4,
      (SELECT REF(t) FROM TARJETA_TAB t WHERE t.NUMERO = 1234567890123456),
      (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Real'),
      (SELECT REF(c) FROM CLIENTE_TAB c WHERE c.DNI = '11223344C'),
      TO_DATE('2025-04-18','YYYY-MM-DD'),
      CARGO_OBJ(3, TO_DATE('2025-04-19','YYYY-MM-DD')),
      LINEA_ALQUILER_NTABTYP(
         LINEA_ALQUILER_OBJ(
           1,
           (SELECT REF(ea) FROM EJEMPLAR_ALQUILER_TAB ea WHERE ea.ID = 4),
           2,
           RESENA_OBJ(
               2,
               'Buen libro, pero la edición usada deja que desear.',
               3,
               3,
               (SELECT REF(c) FROM CLIENTE_TAB c WHERE c.DNI = '11223344C'),
               (SELECT REF(a) FROM ADMINISTRADOR_TAB a WHERE a.DNI = '55667788E')
           )
         )
      )
    )
  );

/**********************************************************
  -- INSERTS PARA PEDIDO A PROVEEDOR Y FACTURAS
**********************************************************/
/* PEDIDOPROVEEDOR_TAB: Cada registro incluye líneas de pedido (LINEASPEDIDO_NTABTYP) */
INSERT INTO PEDIDOPROVEEDOR_TAB
  VALUES(
    PEDIDOPROVEEDOR_OBJ(
       1,
       TO_DATE('2025-04-10','YYYY-MM-DD'),
       'Pendiente',
       LINEASPEDIDO_NTABTYP(
         LINEAPEDIDO_OBJ(1, 10, 15, (SELECT REF(l) FROM LIBRO_TAB l WHERE l.ISBN = '9781234567897'))
       ),
       (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Diagonal'),
       (SELECT REF(p) FROM PROVEEDOR_TAB p WHERE p.ID = 2),
       (SELECT REF(a) FROM ADMINISTRADOR_TAB a WHERE a.DNI = '98765432D')
    )
  );

INSERT INTO PEDIDOPROVEEDOR_TAB
  VALUES(
    PEDIDOPROVEEDOR_OBJ(
       2,
       TO_DATE('2025-04-12','YYYY-MM-DD'),
       'Enviado',
       LINEASPEDIDO_NTABTYP(
         LINEAPEDIDO_OBJ(1, 5, 10, (SELECT REF(l) FROM LIBRO_TAB l WHERE l.ISBN = '9780987654321'))
       ),
       (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Real'),
       (SELECT REF(p) FROM PROVEEDOR_TAB p WHERE p.ID = 3),
       (SELECT REF(a) FROM ADMINISTRADOR_TAB a WHERE a.DNI = '55667788E')
    )
  );

/* FACTURA_TAB: Cada factura agrupa compras y alquileres,
   mediante tablas anidadas COMPRA_NTABTYP y ALQUILER_NTABTYP */
INSERT INTO FACTURA_TAB
  VALUES(
    FACTURA_OBJ(
       1,
       75,
       'Factura de la compra y alquiler del mes.',
       TO_DATE('2025-04-12','YYYY-MM-DD'),
       TO_DATE('2025-05-12','YYYY-MM-DD'),
       COMPRA_NTABTYP(
         (SELECT REF(c) FROM COMPRA_TAB c WHERE c.ID = 1)
       ),
       ALQUILER_NTABTYP(
         (SELECT REF(a) FROM ALQUILER_TAB a WHERE a.ID = 3)
       )
    )
  );

INSERT INTO FACTURA_TAB
  VALUES(
    FACTURA_OBJ(
       2,
       50,
       'Segunda factura de ejemplo',
       TO_DATE('2025-04-20','YYYY-MM-DD'),
       TO_DATE('2025-05-20','YYYY-MM-DD'),
       COMPRA_NTABTYP(
         (SELECT REF(c) FROM COMPRA_TAB c WHERE c.ID = 2)
       ),
       ALQUILER_NTABTYP(
         (SELECT REF(a) FROM ALQUILER_TAB a WHERE a.ID = 4)
       )
    )
  );
