-- ============================================================
-- CREATE VIEW nombre_vista AS
-- SELECT ...
-- FROM ...
-- WHERE ...;

-- Usarla después:
-- SELECT * FROM nombre_vista;
-- ============================================================

-- ============================================================
-- Ejercicio 1 — Vista básica:
-- Crea una vista que muestre solo los vendedores de la región 
-- Norte con su total de ventas.
-- ============================================================

CREATE VIEW vendedores_norte AS
SELECT vendedor, region, SUM(monto) AS total
FROM ventas
WHERE region = 'Norte'
GROUP BY vendedor;

SELECT *
FROM vendedores_norte;