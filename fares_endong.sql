-- Consultas

-- Historial de pedidos a proveedores con información del administrador y libros solicitados
CREATE OR REPLACE VIEW HISTORIAL_PEDIDOS_PROVEEDORES AS
SELECT 
    pp.ID AS ID_PEDIDO,
    pp.FECHA,
    pp.ESTADO,
    a.NOMBRE || ' ' || a.APELLIDO1 AS ADMINISTRADOR,
    p.NOMBRE AS PROVEEDOR,
    l.TITULO AS LIBRO,
    lp.CANTIDAD,
    lp.PRECIOUNITARIO,
    (lp.CANTIDAD * lp.PRECIOUNITARIO) AS TOTAL,
    d.TIPODEVIA || ' ' || d.NOMBRE || ', ' || d.LOCALIDAD AS DIRECCION_ENTREGA
FROM 
    PEDIDOPROVEEDOR_TAB pp,
    TABLE(pp.LINEAS_PEDIDO) lp,
    LIBRO_TAB l,
    ADMINISTRADOR_TAB a,
    PROVEEDOR_TAB p,
    DIRECCION_TAB d
WHERE 
    DEREF(pp.ADMINISTRADOR).DNI = a.DNI
    AND DEREF(pp.PROVEEDOR).ID = p.ID
    AND DEREF(pp.DIRECCION).NOMBRE = d.NOMBRE
    AND DEREF(lp.LIBRO).ISBN = l.ISBN
ORDER BY 
    pp.FECHA DESC;


-- Análisis de reseñas por cliente, media de puntuación y cantidad
CREATE OR REPLACE VIEW ANALISIS_RESEÑAS_CLIENTE AS
SELECT 
    c.NOMBRE || ' ' || c.APELLIDO1 AS CLIENTE,
    c.TIPOCUENTA,
    COUNT(CASE WHEN t.TIPO = 'Compra' THEN 1 END) AS NUM_COMPRAS,
    COUNT(CASE WHEN t.TIPO = 'Alquiler' THEN 1 END) AS NUM_ALQUILERES,
    AVG(NVL(lc.RESENA.PUNTUACION, 0)) AS PUNTUACION_PROMEDIO_COMPRAS,
    AVG(NVL(la.RESENA.PUNTUACION, 0)) AS PUNTUACION_PROMEDIO_ALQUILERES,
    COUNT(CASE WHEN lc.RESENA.PUNTUACION >= 4 THEN 1 END) AS RESEÑAS_POSITIVAS_COMPRAS,
    COUNT(CASE WHEN la.RESENA.PUNTUACION >= 4 THEN 1 END) AS RESEÑAS_POSITIVAS_ALQUILERES
FROM 
    CLIENTE_TAB c,
    (
        SELECT co.ID, co.TIPO, co.USUARIO FROM COMPRA_TAB co
        UNION ALL
        SELECT al.ID, al.TIPO, al.USUARIO FROM ALQUILER_TAB al
    ) t,
    COMPRA_TAB co,
    TABLE(co.LINEA_COMPRA) lc,
    ALQUILER_TAB al,
    TABLE(al.LINEA_ALQUILER) la
WHERE 
    DEREF(t.USUARIO).DNI = c.DNI
    AND ((t.TIPO = 'Compra' AND t.ID = co.ID) OR (t.TIPO = 'Alquiler' AND t.ID = al.ID))
GROUP BY 
    c.NOMBRE, c.APELLIDO1, c.TIPOCUENTA
ORDER BY 
    PUNTUACION_PROMEDIO_COMPRAS DESC;




-- Procedimientos -----------------------------------------------

-- Información detallada del cliente indicando dni
CREATE OR REPLACE PROCEDURE mostrar_info_cliente(
    p_dni IN CHAR
) IS
    v_nombre VARCHAR2(200);
    v_email VARCHAR2(50);
    v_tipocuenta VARCHAR2(20);
    v_puntuacion NUMBER;
    v_localidad VARCHAR2(50);
    v_num_compras NUMBER := 0;
    v_num_alquileres NUMBER := 0;
BEGIN
    -- Obtener datos básicos del cliente
    SELECT 
        c.NOMBRE || ' ' || c.APELLIDO1 || ' ' || c.APELLIDO2,
        c.EMAIL,
        c.TIPOCUENTA,
        c.PUNTUACION,
        DEREF(c.DIRECCION).LOCALIDAD
    INTO
        v_nombre, v_email, v_tipocuenta, v_puntuacion, v_localidad
    FROM CLIENTE_TAB c
    WHERE c.DNI = p_dni;
    
    -- Contar transacciones
    SELECT COUNT(*) INTO v_num_compras
    FROM COMPRA_TAB co
    WHERE DEREF(co.USUARIO).DNI = p_dni;
    
    SELECT COUNT(*) INTO v_num_alquileres
    FROM ALQUILER_TAB al
    WHERE DEREF(al.USUARIO).DNI = p_dni;
    
    -- Mostrar información
    DBMS_OUTPUT.PUT_LINE('=== INFORMACIÓN DEL CLIENTE ===');
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre);
    DBMS_OUTPUT.PUT_LINE('DNI: ' || p_dni);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Localidad: ' || v_localidad);
    DBMS_OUTPUT.PUT_LINE('Tipo de cuenta: ' || v_tipocuenta);
    DBMS_OUTPUT.PUT_LINE('Puntuación: ' || v_puntuacion);
    DBMS_OUTPUT.PUT_LINE('Compras realizadas: ' || v_num_compras);
    DBMS_OUTPUT.PUT_LINE('Alquileres realizados: ' || v_num_alquileres);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró ningún cliente con DNI: ' || p_dni);
END;
/
-- Ordenes de prueba
EXECUTE mostrar_info_cliente('12345678A');
EXECUTE mostrar_info_cliente('87654321B');


-- Disparadores ----------------------------------------
-- Este disparador actúa sobre el vista análisis de reseñas por cliente para
-- actualizar el tipo de cuenta basado en sus reseñas
CREATE OR REPLACE TRIGGER trg_actualizar_tipocuenta
INSTEAD OF UPDATE ON ANALISIS_RESEÑAS_CLIENTE
FOR EACH ROW
DECLARE
    v_nombre_cliente VARCHAR2(100);
    v_apellido_cliente VARCHAR2(100);
    v_cliente_encontrado BOOLEAN := FALSE;
    v_dni CHAR(9);
BEGIN
    -- Extraer nombre y apellido del cliente
    v_nombre_cliente := SUBSTR(:NEW.CLIENTE, 1, INSTR(:NEW.CLIENTE, ' ') - 1);
    v_apellido_cliente := SUBSTR(:NEW.CLIENTE, INSTR(:NEW.CLIENTE, ' ') + 1);
    
    -- Buscar el DNI del cliente basado en su nombre y apellido
    BEGIN
        SELECT DNI INTO v_dni
        FROM CLIENTE_TAB
        WHERE NOMBRE = v_nombre_cliente
        AND APELLIDO1 = v_apellido_cliente;
        
        v_cliente_encontrado := TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No se encontró el cliente: ' || :NEW.CLIENTE);
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Existe más de un cliente con el mismo nombre: ' || :NEW.CLIENTE);
    END;
    
    -- Si se encontró el cliente y el tipo de cuenta ha cambiado, actualizarlo
    IF v_cliente_encontrado AND :OLD.TIPOCUENTA != :NEW.TIPOCUENTA THEN
        UPDATE CLIENTE_TAB
        SET TIPOCUENTA = :NEW.TIPOCUENTA
        WHERE DNI = v_dni;
        
        DBMS_OUTPUT.PUT_LINE('Cliente ' || :NEW.CLIENTE || ' actualizado a tipo de cuenta: ' || :NEW.TIPOCUENTA);
        
        -- Verificar si el cliente es ahora Premium y aplicar descuentos
        IF :NEW.TIPOCUENTA = 'Premium' THEN
            -- Si es premium, ajustar puntuación si es necesario
            UPDATE CLIENTE_TAB
            SET PUNTUACION = GREATEST(PUNTUACION, 500)
            WHERE DNI = v_dni;
            
            DBMS_OUTPUT.PUT_LINE('Puntuación actualizada para cliente Premium');
        END IF;
    END IF;
END;
/

-- Ordenes de prueba
-- 1. Ver el estado actual de los clientes en la vista
SELECT CLIENTE, TIPOCUENTA, 
       NUM_COMPRAS, NUM_ALQUILERES, 
       PUNTUACION_PROMEDIO_COMPRAS 
FROM ANALISIS_RESEÑAS_CLIENTE;

-- 2. Actualizar el tipo de cuenta de un cliente a través de la vista
UPDATE ANALISIS_RESEÑAS_CLIENTE
SET TIPOCUENTA = 'Premium'
WHERE CLIENTE = 'Alejandro Pérez'
AND PUNTUACION_PROMEDIO_COMPRAS >= 4;

-- 3. Verificar que el cambio se ha aplicado correctamente
SELECT CLIENTE, TIPOCUENTA FROM ANALISIS_RESEÑAS_CLIENTE
WHERE CLIENTE = 'Alejandro Pérez';

-- 4. Verificar directamente en la tabla de clientes
SELECT NOMBRE, APELLIDO1, TIPOCUENTA, PUNTUACION
FROM CLIENTE_TAB
WHERE APELLIDO1 = 'Pérez';
