-- Insertar direcciones
INSERT INTO DIRECCION_TAB (DIRECCION_OBJ)
VALUES ('Calle', 'Mayor', 10, 2, 'B', 'Madrid');

INSERT INTO DIRECCION_TAB (TIPODEVIA, NOMBRE, NUMERO, PISO, PUERTA, LOCALIDAD)
VALUES ('Avenida', 'Andalucía', 25, 3, 'A', 'Sevilla');


-- Insertar tarjetas
INSERT INTO TARJETA_TAB (NUMERO, CVV, FECHACADUCIDAD)
VALUES (1234567890123456, 123, TO_DATE('12/2026', 'MM/YYYY'));

INSERT INTO TARJETA_TAB (NUMERO, CVV, FECHACADUCIDAD)
VALUES (9876543210987654, 456, TO_DATE('11/2025', 'MM/YYYY'));


-- Insertar proveedores
INSERT INTO PROVEEDOR_TAB (ID, NOMBRE, EMAIL, TELEFONO)
VALUES (1, 'Editorial Planeta', 'contacto@planeta.es', 912345678);

INSERT INTO PROVEEDOR_TAB (ID, NOMBRE, EMAIL, TELEFONO)
VALUES (2, 'Editorial Anaya', 'info@anaya.es', 923456789);

COMMIT;

-- Cliente
INSERT INTO CLIENTE_TAB VALUES (
    3, 'Ana', 'Gomez', 'Lopez', 'ana.gomez@example.com', 'clave123', 612345678,
    TO_DATE('1990-04-15','YYYY-MM-DD'), '12345679A',
    (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Mayor'),
    4.5, 'Premium'
);

-- Administrador
INSERT INTO ADMINISTRADOR_TAB VALUES (
    4, 'Carlos', 'Ruiz', 'Martinez', 'carlos.ruiz@example.com', 'adminpass', 699112233,
    TO_DATE('1985-09-10','YYYY-MM-DD'), '87654329B',
    (SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Mayor'),
    TO_DATE('2020-01-01','YYYY-MM-DD')
);
COMMIT;

-- Libro
INSERT INTO LIBRO_TAB
VALUES('0123456789136', 'Helou', 'yo', 'drama', 'castellano', 'una historia de miedo', 'image.png', EJEMPLARESVENTA_NTABTYP(
EJEMPLAR_VENTA_OBJ(1,'Nuevo','Digital',12,1,10,16)
), EJEMPLARESALQUILER_NTABTYP(
EJEMPLAR_ALQUILER_OBJ(1,'Nuevo','Digital',12,1,10,2,10)
), (SELECT REF(p) FROM PROVEEDOR_TAB p WHERE p.ID = 1));
COMMIT;

-- Compra (Falla)
INSERT INTO COMPRA_TAB
VALUES (
1, TO_DATE('2025-03-15','YYYY-MM-DD'),20,'COMPRA',2.99,
(SELECT REF(t) FROM TARJETA_TAB t WHERE t.NUMERO = 1234567890123456),
(SELECT REF(d) FROM DIRECCION_TAB d WHERE d.NOMBRE = 'Mayor'),
(SELECT REF(c) FROM CLIENTE_TAB c WHERE c.DNI = '12345679A'),
10,
LINEA_COMPRA_NTABTYP(
        LINEA_COMPRA_OBJ(
            1,
            (SELECT REF(e)
            FROM TABLE(
                    SELECT l.EJEMPLARESVENTA
                    FROM LIBRO_TAB l
                    WHERE l.ISBN = '0123456789136'
             ) e
             WHERE e.ID = 1),
            1,
            RESENA_OBJ(1, 'Excelente libro', 5, 5,
                (SELECT REF(c) FROM CLIENTE_TAB c WHERE c.DNI = '12345679A'),
                (SELECT REF(a) FROM ADMINISTRADOR_TAB a WHERE a.DNI = '87654329B')
            )
        )
    )
);