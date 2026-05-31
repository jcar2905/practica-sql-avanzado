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

-- ============================================================
-- EJERCICIO 3 — Vista con JOIN, CASE y agregaciones
-- Crea una vista que muestre por cliente: nombre, segmento,
-- total depositado, total retirado y balance final.
-- Patrón clave: SUM(CASE WHEN tipo = '...' THEN monto ELSE 0 END)
-- Este patrón es estándar en SQL bancario para pivot de categorías.
-- ============================================================

CREATE TABLE clientes (
    id_cliente INTEGER,
    nombre TEXT,
    segmento TEXT
);

CREATE TABLE transacciones (
    id_transaccion INTEGER,
    id_cliente INTEGER,
    tipo TEXT,
    monto REAL,
    fecha TEXT
);

INSERT INTO clientes VALUES
(1,'Carlos','Premium'),
(2,'Laura','Estándar'),
(3,'Pedro','Premium'),
(4,'Sofía','Estándar');

INSERT INTO transacciones VALUES
(1,1,'depósito',50000,'2024-01-10'),
(2,1,'retiro',20000,'2024-01-15'),
(3,2,'depósito',5000,'2024-01-12'),
(4,2,'retiro',3000,'2024-01-20'),
(5,3,'depósito',80000,'2024-02-05'),
(6,3,'retiro',10000,'2024-02-10'),
(7,4,'depósito',8000,'2024-02-15'),
(8,1,'depósito',30000,'2024-03-01');

CREATE VIEW resumen_clientes AS
SELECT
    c.nombre,
    c.segmento,
    COALESCE(SUM(CASE WHEN t.tipo = 'depósito' THEN t.monto ELSE 0 END), 0) AS total_depositado,
    COALESCE(SUM(CASE WHEN t.tipo = 'retiro'   THEN t.monto ELSE 0 END), 0) AS total_retirado,
    COALESCE(SUM(CASE WHEN t.tipo = 'depósito' THEN t.monto ELSE 0 END), 0) -
    COALESCE(SUM(CASE WHEN t.tipo = 'retiro'   THEN t.monto ELSE 0 END), 0) AS balance_final
FROM clientes c
LEFT JOIN transacciones t ON c.id_cliente = t.id_cliente
GROUP BY c.nombre, c.segmento;