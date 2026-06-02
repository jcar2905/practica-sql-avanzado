-- ============================================================
-- CREATE FUNCTION nombre_funcion(parametro TIPO)
-- RETURNS TIPO
-- AS $$
-- BEGIN
--     RETURN resultado;
-- END;
-- $$ LANGUAGE plpgsql;
-- ============================================================

CREATE TABLE transacciones (
    id_transaccion INTEGER,
    id_cliente INTEGER,
    tipo TEXT,
    monto REAL,
    fecha TEXT
);

INSERT INTO transacciones VALUES
(1,1,'depósito',50000,'2024-01-10'),
(2,1,'retiro',20000,'2024-01-15'),
(3,2,'depósito',5000,'2024-01-12'),
(4,2,'retiro',3000,'2024-01-20'),
(5,3,'depósito',80000,'2024-02-05'),
(6,3,'retiro',10000,'2024-02-10'),
(7,4,'depósito',8000,'2024-02-15'),
(8,1,'depósito',30000,'2024-03-01');

-- ============================================================
-- EJERCICIO 1 — Función básica con parámetro
-- Crea una función llamada balance_cliente que reciba
-- un id_cliente y devuelva su balance final:
-- total depositado menos total retirado.
-- ============================================================

CREATE FUNCTION balance_final(p_id_cliente INTEGER)
RETURNS REAL
AS $$
BEGIN
    RETURN (
        SELECT
        SUM( CASE WHEN tipo = 'depósito' THEN monto ELSE -monto END)
        FROM transacciones
        WHERE id_cliente = p_id_cliente
    );
END;
$$ LANGUAGE plpgsql;