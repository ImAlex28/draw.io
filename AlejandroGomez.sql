-- CONSULTAS
-- 1. Mostrar todos los ejemplares nuevos en venta de un libro según su ISBN.
SELECT l.ISBN, 
       l.TITULO, 
       DEREF(VALUE(e)).ID AS ID_EJEMPLAR, 
       DEREF(VALUE(e)).ESTADO AS ESTADO, 
       DEREF(VALUE(e)).FORMATO AS FORMATO, 
       DEREF(VALUE(e)).PRECIO_VENTA AS PRECIOVENTA
FROM LIBRO_TAB l, 
     TABLE(CAST(l.EJEMPLARESVENTA AS EJEMPLARESVENTA_NTABTYP)) e
WHERE l.ISBN = '9783161484100'
AND DEREF(VALUE(e)).ESTADO = 'Nuevo';

-- 2. Media del precio de venta por estado del ejemplar.
SELECT DEREF(VALUE(e)).ESTADO AS ESTADO, AVG(DEREF(VALUE(e)).PRECIO_VENTA) AS MEDIA_PRECIO
FROM LIBRO_TAB l, TABLE(CAST(l.EJEMPLARESVENTA AS EJEMPLARESVENTA_NTABTYP)) e GROUP BY DEREF(VALUE(e)).ESTADO;

-- Trigger
-- Trigger que impide la inserción de un alquiler si el usuario ya tiene 3 alquileres activos.
CREATE OR REPLACE TRIGGER TGR_LIMITE_ALQUILER
BEFORE INSERT ON ALQUILER_TAB
FOR EACH ROW
DECLARE
    v_num_alquileres NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_num_alquileres FROM ALQUILER_TAB a, TABLE(a.LINEA_ALQUILER) l
    WHERE DEREF(a.USUARIO).DNI = DEREF(:NEW.USUARIO).DNI AND a.FECHAINICIO + DEREF(l.EJEMPLAR_ALQUILER).DURACION_ALQUILER > SYSDATE;  --Se compara dni anteriores con el que se va a insertar y se cinomprueba si la fecha de inicio + duracion es mayor a la fecha actual

    IF v_num_alquileres >= 3 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El usuario ya tiene 3 alquileres activos.');
    END IF;
END;
/

-- Prodedimiento
-- Procedimiento que aumenta el precio de venta de todos los ejemplares de un libro en una cantidad dada.
CREATE OR REPLACE PROCEDURE subir_precio_libro ( p_isbn IN CHAR, p_incremento IN NUMBER) IS
BEGIN
    FOR l IN ( SELECT REF(libro) AS ref_libro FROM LIBRO_TAB libro WHERE libro.ISBN = p_isbn)
    LOOP UPDATE TABLE(SELECT libro.EJEMPLARESVENTA FROM LIBRO_TAB libro WHERE REF(libro) = l.ref_libro) SET PRECIOVENTA = PRECIOVENTA + p_incremento;
  END LOOP;
END;
/
