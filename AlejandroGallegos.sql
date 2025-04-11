-- VISTAS
/*
    1. Unificar las transacciones de compras y alquileres en una tabla que incluya: el tipo de transacción, ID, fecha, importe, email del cliente, nombre de la calle de la dirección, puntos de la compra (sólo para compras), fecha de inicio de alquiler (sólo para alquileres), el número de líneas de la transacción y el importe del cargo (sólo para alquileres).

*/

CREATE OR REPLACE VIEW VISTA_TRANSACCIONES AS
-- Consulta de Compras
SELECT
    'COMPRA' AS TIPO_TRANSACCION,
    c.ID,
    c.FECHA,
    c.IMPORTE,
    DEREF(c.USUARIO).EMAIL AS EMAIL_CLIENTE,
    DEREF(c.DIRECCION).NOMBRE AS CALLE_DIRECCION,
    TO_CHAR(c.PUNTOS) AS PUNTOS_COMPRA,
    NULL AS FECHA_INICIO_ALQUILER,
    (SELECT COUNT(*) FROM TABLE(c.LINEA_COMPRA)) AS NUM_LINEAS,
    NULL AS IMPORTE_CARGO
FROM COMPRA_TAB c

UNION ALL

SELECT
    'ALQUILER' AS TIPO_TRANSACCION,
    a.ID,
    a.FECHA,
    a.IMPORTE,
    DEREF(a.USUARIO).EMAIL AS EMAIL_CLIENTE,
    DEREF(a.DIRECCION).NOMBRE AS CALLE_DIRECCION,
    NULL AS PUNTOS_COMPRA,
    TO_CHAR(a.FECHAINICIO) AS FECHA_INICIO_ALQUILER,
    (SELECT COUNT(*) FROM TABLE(a.LINEA_ALQUILER)) AS NUM_LINEAS,
    a.CARGO.IMPORTE AS IMPORTE_CARGO
FROM ALQUILER_TAB a;

/*
    2. Obtener, por género, el número de libros, total de ejemplares para venta y alquiler, precio medio de venta y precio medio por día de alquiler, ordenado por total de ejemplares de venta:
*/

CREATE OR REPLACE VIEW VISTA_RESUMEN_LIBROS AS
SELECT
    GENERO,
    COUNT(*) AS NUM_LIBROS,
    SUM(TOTAL_EJEMPLARES_VENTA) AS TOTAL_EJEMPLARES_VENTA,
    AVG(AVG_PRECIO_VENTA) AS AVG_PRECIO_VENTA,
    SUM(TOTAL_EJEMPLARES_ALQUILER) AS TOTAL_EJEMPLARES_ALQUILER,
    AVG(AVG_PRECIO_ALQUILER) AS AVG_PRECIO_ALQUILER
FROM (
  SELECT
      l.GENERO,
      l.ISBN,
      -- Para ventas:
      (SELECT COUNT(*)
         FROM TABLE(l.EJEMPLARESVENTA)
      ) AS TOTAL_EJEMPLARES_VENTA,
      (SELECT AVG(precio)
         FROM (
           SELECT DEREF(COLUMN_VALUE).PRECIO_VENTA AS precio
           FROM TABLE(l.EJEMPLARESVENTA)
         )
      ) AS AVG_PRECIO_VENTA,

      -- Para alquileres:
      (SELECT COUNT(*)
         FROM TABLE(l.EJEMPLARESALQUILER)
      ) AS TOTAL_EJEMPLARES_ALQUILER,
      (SELECT AVG(precio)
         FROM (
           SELECT DEREF(COLUMN_VALUE).PRECIO_POR_DIA AS precio
           FROM TABLE(l.EJEMPLARESALQUILER)
         )
      ) AS AVG_PRECIO_ALQUILER
  FROM LIBRO_TAB l
)
GROUP BY GENERO
ORDER BY TOTAL_EJEMPLARES_VENTA DESC;

-- DISPARADOR
/*
    Disparador que ponga como no disponibles los ejemplares de alquiler que son alquilados y los de compra que son comprados.
*/

CREATE OR REPLACE TRIGGER trg_after_insert_alquiler
AFTER INSERT ON ALQUILER_TAB
FOR EACH ROW
DECLARE
   v_lineas    LINEA_ALQUILER_NTABTYP;
   v_ejemplar  REF EJEMPLAR_ALQUILER_OBJ;
BEGIN
   -- Obtener la colección de líneas de alquiler del registro insertado
   v_lineas := :NEW.LINEA_ALQUILER;
   IF v_lineas IS NOT NULL THEN
      FOR i IN 1 .. v_lineas.COUNT LOOP
         v_ejemplar := v_lineas(i).EJEMPLAR_ALQUILER;
         -- Actualizar el ejemplar de alquiler: marcar DISPONIBILE a 0.
         UPDATE EJEMPLAR_ALQUILER_TAB e
         SET e.DISPONIBILE = 0
         WHERE REF(e) = v_ejemplar;
      END LOOP;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_after_insert_compra
AFTER INSERT ON COMPRA_TAB
FOR EACH ROW
DECLARE
   v_lineas    LINEA_COMPRA_NTABTYP;
   v_ejemplar  REF EJEMPLAR_VENTA_OBJ;
BEGIN
   -- Obtener la colección de líneas de compra del registro insertado
   v_lineas := :NEW.LINEA_COMPRA;
   IF v_lineas IS NOT NULL THEN
      FOR i IN 1 .. v_lineas.COUNT LOOP
         v_ejemplar := v_lineas(i).EJEMPLAR_COMPRA;

         -- Actualizar el ejemplar: marcar como no disponible.
         UPDATE EJEMPLAR_VENTA_TAB e
         SET e.DISPONIBILE = 0
         WHERE REF(e) = v_ejemplar;
      END LOOP;
   END IF;
END;
/




-- PROCEDURE
/*
    Mostrar en la consola los títulos y autores de los libros de un género dado.
*/

CREATE OR REPLACE PROCEDURE sp_listar_libros_por_genero (p_genero IN VARCHAR2) IS
BEGIN
  FOR rec IN (
    SELECT TITULO, AUTOR
    FROM LIBRO_TAB
    WHERE GENERO = p_genero
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Título: ' || rec.TITULO || ' | Autor: ' || rec.AUTOR);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No se encontraron libros para el género: ' || p_genero);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END sp_listar_libros_por_genero;
/
