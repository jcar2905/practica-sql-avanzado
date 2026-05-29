-- ============================================================
-- CTEs (Common Table Expressions)
-- Sintaxis base:
--
-- WITH nombre_cte AS (
--     SELECT ...
--     FROM ...
--     WHERE ...
-- )
-- SELECT * FROM nombre_cte;
-- ============================================================

-- Tabla de práctica
CREATE TABLE ventas (
    id INTEGER,
    vendedor TEXT,
    region TEXT,
    monto REAL,
    fecha TEXT
);

INSERT INTO ventas VALUES
(1,'Ana','Norte',5000,'2024-01-15'),
(2,'Luis','Sur',3000,'2024-01-20'),
(3,'Ana','Norte',7000,'2024-02-10'),
(4,'María','Centro',4000,'2024-02-14'),
(5,'Luis','Sur',6000,'2024-03-05'),
(6,'María','Centro',2000,'2024-03-18'),
(7,'Ana','Norte',8000,'2024-04-02'),
(8,'Luis','Sur',1000,'2024-04-20');

-- ============================================================
-- EJERCICIO 1 — CTE básica
-- Calcula el total de ventas por vendedor
-- y filtra solo los que vendieron más de 10,000
-- ============================================================

WITH ventas_vendedor AS (
    SELECT vendedor, SUM(monto) AS total
    FROM ventas
    GROUP BY vendedor
)

SELECT *
FROM ventas_vendedor
WHERE total > 10000;

-- ============================================================
-- EJERCICIO 2 — CTEs encadenadas
-- Calcula el total de ventas por vendedor,
-- luego calcula el promedio general de esos totales,
-- y finalmente muestra solo los vendedores que están
-- por encima del promedio.
-- ============================================================

WITH ventas_vendedor AS (
    SELECT vendedor, SUM(monto) AS total
    FROM ventas
    GROUP BY vendedor
),
promedio_general AS (
    SELECT AVG(total) AS promedio
    FROM ventas_vendedor
)

SELECT v.vendedor,v.total,p.promedio
FROM ventas_vendedor v, promedio_general p
WHERE v.total > p.promedio;

-- ============================================================
-- EJERCICIO 3 — CTE con Window Function ROW_NUMBER
-- Genera un ranking de vendedores por total de ventas
-- y muestra solo el top 2.
-- ============================================================

WITH ventas_vendedor AS (
    SELECT vendedor, SUM(monto) AS total
    FROM ventas
    GROUP BY vendedor
),
ranking AS (
    SELECT vendedor, total,
           ROW_NUMBER() OVER (ORDER BY total DESC) AS posicion
    FROM ventas_vendedor
)
SELECT *
FROM ranking
WHERE posicion = 2;