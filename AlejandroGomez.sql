--CONSULTAS
-- 1. Mostrar todos los ejemplares nuevos en venta de un libro según su ISBN.
SELECT l.ISBN, l.TITULO, e.ID as ID_EJEMPLAR, e.ESTADO, e.FORMATO, e.PRECIO_VENTA FROM LIBRO_TABl, TABKE(l.EJEMPLARESVENTA) e WHERE l.ISBN = '0123456789123' AND e.ESTADO = 'Nuevo';

--2. Media del precio de venta por estado del ejemplar.
SELECT e.ESTADO, AVG(e.PRECIO_VENTA) as MEDIA_PRECIO FROM LIBRO_TAB l, TABLE(l.EJEMPLARESVENTA) e GROUP BY e.ESTADO;

--Trigger
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