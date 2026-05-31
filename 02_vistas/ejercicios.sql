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

-- ============================================================
-- Ejercicio 2 — Vista con JOIN
-- Crea una segunda tabla y una vista que combine ambas, 
-- llamada cumplimiento_metas que muestre: 
-- vendedor, total vendido, meta, y una columna cumple que diga 
-- 'Sí' si el total supera la meta y 'No' si no.
-- ============================================================

CREATE TABLE metas (
    vendedor TEXT,
    meta REAL
);

INSERT INTO metas VALUES
('Ana', 18000),
('Luis', 12000),
('María', 8000);

CREATE VIEW cumplimiento_metas AS
SELECT 
    v.vendedor, 
    m.meta, 
    SUM(v.monto) AS total,
    CASE
        WHEN SUM(v.monto) > m.meta THEN 'Si'
        ELSE 'No'
    END AS cumplimiento
FROM ventas v
INNER JOIN metas m ON v.vendedor = m.vendedor
GROUP BY v.vendedor, m.meta;