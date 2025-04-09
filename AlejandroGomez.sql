--CONSULTAS
-- 1. Mostrar todos los ejemplares nuevos en venta de un libro según su ISBN.
SELECT l.ISBN, l.TITULO, e.ID as ID_EJEMPLAR, e.ESTADO, e.FORMATO, e.PRECIO_VENTA FROM LIBRO_TABl, TABKE(l.EJEMPLARESVENTA) e WHERE l.ISBN = '0123456789123' AND e.ESTADO = 'Nuevo';

--2. Media del precio de venta por estado del ejemplar.
SELECT e.ESTADO, AVG(e.PRECIO_VENTA) as MEDIA_PRECIO FROM LIBRO_TAB l, TABLE(l.EJEMPLARESVENTA) e GROUP BY e.ESTADO;

