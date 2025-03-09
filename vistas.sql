CREATE OR REPLACE VIEW VISTA_TRANSACCIONES_POR_MES AS
WITH Ventas AS (
  SELECT
    TO_CHAR(Fecha, 'YYYY-MM') AS Mes,
    SUM(ImporteTotal) AS TotalVentas
  FROM COMPRA_TAB
  GROUP BY TO_CHAR(Fecha, 'YYYY-MM')
),
Alquileres AS (
  SELECT
    TO_CHAR(Fecha, 'YYYY-MM') AS Mes,
    SUM(ImporteTotal) AS TotalAlquileres
  FROM ALQUILER_TAB
  GROUP BY TO_CHAR(Fecha, 'YYYY-MM')
)
SELECT
  COALESCE(V.Mes, A.Mes) AS Mes,
  COALESCE(V.TotalVentas, 0) AS TotalVentas,
  COALESCE(A.TotalAlquileres, 0) AS TotalAlquileres
FROM Ventas V
FULL OUTER JOIN Alquileres A ON V.Mes = A.Mes;

CREATE OR REPLACE VIEW VISTA_COMPRAS_ALQUILERES_POR_LIBRO AS
WITH Compras AS (
  SELECT
    L.ISBN,
    L.Titulo,
    COUNT(*) AS NumCompras
  FROM LINEA_COMPRA_TAB LC
  JOIN EJEMPLARVENTA_TAB EV
       ON LC.IdEjemplarVenta = REF(EV)
  JOIN LIBRO_TAB L
       ON EXISTS (
            SELECT 1
            FROM TABLE(L.Ejemplares) E
            WHERE E.Id = (EV.Id - 99)
       )
  GROUP BY L.ISBN, L.Titulo
),
Alquileres AS (
  SELECT
    L.ISBN,
    L.Titulo,
    COUNT(*) AS NumAlquileres
  FROM LINEA_ALQUILER_TAB LA
  JOIN EJEMPLARALQUILER_TAB EA
       ON LA.IdEjemplarAlquiler = REF(EA)
  JOIN LIBRO_TAB L
       ON EXISTS (
            SELECT 1
            FROM TABLE(L.Ejemplares) E
            WHERE E.Id = (EA.Id - 199)
       )
  GROUP BY L.ISBN, L.Titulo
)
SELECT
  COALESCE(C.ISBN, A.ISBN) AS ISBN,
  COALESCE(C.Titulo, A.Titulo) AS Titulo,
  COALESCE(C.NumCompras, 0) AS TotalCompras,
  COALESCE(A.NumAlquileres, 0) AS TotalAlquileres
FROM Compras C
FULL OUTER JOIN Alquileres A ON C.ISBN = A.ISBN;

CREATE OR REPLACE VIEW VISTA_CARGOS_POR_MES AS
WITH CargosPorMes AS (
  SELECT
    TO_CHAR(C.Fecha, 'YYYY-MM') AS Mes,
    SUM(C.Importe) AS TotalCargos
  FROM CARGO_TAB C
  GROUP BY TO_CHAR(C.Fecha, 'YYYY-MM')
)
SELECT
  Mes,
  COALESCE(TotalCargos, 0) AS TotalCargos
FROM CargosPorMes;

CREATE OR REPLACE VIEW VISTA_PAGOS_PROVEEDORES AS
WITH PagosProveedores AS (
  SELECT
    P.Id AS IdProveedor,
    P.Nombre AS NombreProveedor,
    SUM(F.PrecioTotal) AS TotalPagado
  FROM FACTURA_TAB F
  JOIN PEDIDO_PROVEEDOR_TAB PP ON PP.Id = F.IdFactura
  JOIN PROVEEDOR_TAB P ON P.Id = PP.IdProveedor
  GROUP BY P.Id, P.Nombre
)
SELECT
  IdProveedor,
  NombreProveedor,
  TotalPagado
FROM PagosProveedores;
