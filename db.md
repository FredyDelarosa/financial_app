/*
In Neon, databases are stored on branches. By default, a project has one branch and one database.
You can select the branch and database to use from the drop-down menus above.

Try generating sample data and querying it by running the example statements below, or click
New Query to clear the editor.
*/
CREATE TABLE IF NOT EXISTS playing_with_neon(id SERIAL PRIMARY KEY, name TEXT NOT NULL, value REAL);
INSERT INTO playing_with_neon(name, value)
  SELECT LEFT(md5(i::TEXT), 10), random() FROM generate_series(1, 10) s(i);
SELECT * FROM playing_with_neon;


SELECT datname FROM pg_database;

CREATE DATABASE financial_app;

\c financiall_app;

SELECT tablename FROM pg_tables WHERE schemaname = 'public';

-- =============================================
-- 1. TABLA: usuarios
-- =============================================
CREATE TABLE usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    moneda_preferida VARCHAR(3) DEFAULT 'MXN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. TABLA: categorias
-- Categor�as predefinidas + personalizadas por usuario
-- =============================================
CREATE TABLE categorias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NULL, -- NULL = categor�a global predefinida
    nombre VARCHAR(50) NOT NULL,
    icono VARCHAR(50) DEFAULT 'shopping_cart', -- nombre de icono Material
    color VARCHAR(7) DEFAULT '#4CAF50', -- color en hex
    tipo VARCHAR(10) CHECK (tipo IN ('ingreso', 'gasto')) DEFAULT 'gasto',
    es_sistema BOOLEAN DEFAULT FALSE, -- si es categor�a predefinida
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- =============================================
-- 3. TABLA: transacciones
-- Coraz�n de la aplicaci�n
-- =============================================
CREATE TABLE transacciones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL,
    categoria_id UUID NOT NULL,
    monto DECIMAL(12,2) NOT NULL CHECK (monto > 0),
    descripcion TEXT,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    tipo VARCHAR(10) CHECK (tipo IN ('ingreso', 'gasto')) NOT NULL,
    es_recurrente BOOLEAN DEFAULT FALSE,
    frecuencia_recurrencia VARCHAR(20) NULL CHECK (frecuencia_recurrencia IN ('diario', 'semanal', 'mensual', 'anual')),
    metodo_pago VARCHAR(30) DEFAULT 'efectivo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE RESTRICT
);

-- =============================================
-- 4. TABLA: presupuestos_mensuales
-- Presupuesto por categor�a y mes
-- =============================================
CREATE TABLE presupuestos_mensuales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL,
    categoria_id UUID NOT NULL,
    mes INTEGER NOT NULL CHECK (mes BETWEEN 1 AND 12),
    a�o INTEGER NOT NULL,
    monto_limite DECIMAL(12,2) NOT NULL CHECK (monto_limite > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE,
    UNIQUE(usuario_id, categoria_id, mes, a�o)
);

-- =============================================
-- 5. TABLA: metas_ahorro
-- Metas financieras del usuario
-- =============================================
CREATE TABLE metas_ahorro (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    monto_objetivo DECIMAL(12,2) NOT NULL CHECK (monto_objetivo > 0),
    monto_actual DECIMAL(12,2) DEFAULT 0,
    fecha_limite DATE NOT NULL,
    prioridad INTEGER DEFAULT 1 CHECK (prioridad BETWEEN 1 AND 5),
    estado VARCHAR(20) DEFAULT 'activa' CHECK (estado IN ('activa', 'completada', 'cancelada')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- =============================================
-- 6. TABLA: alertas
-- Alertas por l�mites de presupuesto
-- =============================================
CREATE TABLE alertas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL,
    presupuesto_id UUID NOT NULL,
    porcentaje_alerta INTEGER NOT NULL CHECK (porcentaje_alerta IN (50, 75, 90, 100)),
    notificado BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (presupuesto_id) REFERENCES presupuestos_mensuales(id) ON DELETE CASCADE
);

-- =============================================
-- �NDICES PARA OPTIMIZACI�N
-- =============================================
CREATE INDEX idx_transacciones_usuario_fecha ON transacciones(usuario_id, fecha);
CREATE INDEX idx_transacciones_categoria ON transacciones(categoria_id);
CREATE INDEX idx_presupuestos_usuario_mes ON presupuestos_mensuales(usuario_id, a�o, mes);
CREATE INDEX idx_metas_usuario_estado ON metas_ahorro(usuario_id, estado);

-- =============================================
-- DATOS INICIALES: Categor�as por defecto
-- =============================================
INSERT INTO categorias (id, nombre, icono, color, tipo, es_sistema) VALUES
-- Gastos
(gen_random_uuid(), 'Alimentos', 'restaurant', '#FF5722', 'gasto', TRUE),
(gen_random_uuid(), 'Transporte', 'directions_car', '#2196F3', 'gasto', TRUE),
(gen_random_uuid(), 'Vivienda', 'home', '#9C27B0', 'gasto', TRUE),
(gen_random_uuid(), 'Servicios', 'water_drop', '#00BCD4', 'gasto', TRUE),
(gen_random_uuid(), 'Entretenimiento', 'movie', '#FF9800', 'gasto', TRUE),
(gen_random_uuid(), 'Salud', 'local_hospital', '#4CAF50', 'gasto', TRUE),
(gen_random_uuid(), 'Educaci�n', 'school', '#3F51B5', 'gasto', TRUE),
(gen_random_uuid(), 'Compras', 'shopping_bag', '#E91E63', 'gasto', TRUE),
(gen_random_uuid(), 'Seguros', 'security', '#795548', 'gasto', TRUE),
-- Ingresos
(gen_random_uuid(), 'Salario', 'work', '#4CAF50', 'ingreso', TRUE),
(gen_random_uuid(), 'Freelance', 'computer', '#8BC34A', 'ingreso', TRUE),
(gen_random_uuid(), 'Inversiones', 'trending_up', '#009688', 'ingreso', TRUE),
(gen_random_uuid(), 'Regalos', 'card_giftcard', '#FF4081', 'ingreso', TRUE);

-- =============================================
-- FUNCI�N: Actualizar updated_at autom�ticamente
-- =============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para updated_at
CREATE TRIGGER update_usuarios_updated_at BEFORE UPDATE ON usuarios FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_transacciones_updated_at BEFORE UPDATE ON transacciones FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_presupuestos_updated_at BEFORE UPDATE ON presupuestos_mensuales FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_metas_updated_at BEFORE UPDATE ON metas_ahorro FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- VISTA: Resumen de gastos por mes
-- =============================================
CREATE VIEW vw_resumen_mensual AS
SELECT
    usuario_id,
    EXTRACT(YEAR FROM fecha) as a�o,
    EXTRACT(MONTH FROM fecha) as mes,
    tipo,
    SUM(monto) as total
FROM transacciones
GROUP BY usuario_id, a�o, mes, tipo;

-- =============================================
-- VISTA: Progreso de presupuestos
-- =============================================
CREATE VIEW vw_progreso_presupuesto AS
SELECT
    p.id as presupuesto_id,
    p.usuario_id,
    p.categoria_id,
    c.nombre as categoria_nombre,
    p.mes,
    p.a�o,
    p.monto_limite,
    COALESCE(SUM(t.monto), 0) as gastado,
    ROUND(COALESCE(SUM(t.monto), 0) / p.monto_limite * 100, 2) as porcentaje
FROM presupuestos_mensuales p
JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN transacciones t ON t.categoria_id = p.categoria_id
    AND t.usuario_id = p.usuario_id
    AND EXTRACT(YEAR FROM t.fecha) = p.a�o
    AND EXTRACT(MONTH FROM t.fecha) = p.mes
    AND t.tipo = 'gasto'
GROUP BY p.id, p.usuario_id, p.categoria_id, c.nombre, p.mes, p.a�o, p.monto_limite;
