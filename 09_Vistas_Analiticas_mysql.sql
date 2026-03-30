USE RRHH_DW;

-- =======================================================================================
-- SCRIPT 09: VISTAS ANALÍTICAS (PREPARACIÓN PARA POWER BI / TABLEROS)
-- =======================================================================================
-- Descripción: Creación de vistas (Views) que denormalizan el modelo estrella 
-- para facilitar la conexión y creación de reportes gráficos.
-- =======================================================================================

-- ------------------------------------------------------------------
-- 1. VISTA: ANÁLISIS DE AUSENTISMO
-- Responde a: ¿Quién, cuándo y por qué falta la gente a trabajar?
-- ------------------------------------------------------------------
CREATE OR REPLACE VIEW v_Analisis_Ausentismo AS
SELECT 
    df.Anio,
    df.NombreMes,
    de.NombreCompleto,
    dd.NombreDepartamento,
    dof.Ciudad AS Sede,
    dta.TipoAusencia,
    fa.DiasAusencia,
    fa.CantidadAusencias
FROM FactAusencias fa
JOIN DimFecha df ON fa.FechaKey = df.FechaKey
JOIN DimEmpleado de ON fa.EmpleadoKey = de.EmpleadoKey
JOIN DimDepartamento dd ON fa.DepartamentoKey = dd.DepartamentoKey
JOIN DimOficina dof ON fa.OficinaKey = dof.OficinaKey
JOIN DimTipoAusencia dta ON fa.TipoAusenciaKey = dta.TipoAusenciaKey;


-- ------------------------------------------------------------------
-- 2. VISTA: ANÁLISIS DE DESEMPEÑO
-- Responde a: ¿Cuáles son las calificaciones de nuestros empleados por área?
-- ------------------------------------------------------------------
CREATE OR REPLACE VIEW v_Analisis_Desempeno AS
SELECT 
    df.Anio,
    df.Trimestre,
    de.NombreCompleto,
    dd.NombreDepartamento,
    dof.Ciudad AS Sede,
    fe.Calificacion
FROM FactEvaluaciones fe
JOIN DimFecha df ON fe.FechaKey = df.FechaKey
JOIN DimEmpleado de ON fe.EmpleadoKey = de.EmpleadoKey
JOIN DimDepartamento dd ON fe.DepartamentoKey = dd.DepartamentoKey
JOIN DimOficina dof ON fe.OficinaKey = dof.OficinaKey;


-- ------------------------------------------------------------------
-- 3. VISTA: ANÁLISIS DE CAPACITACIONES (ROI y Gasto)
-- Responde a: ¿Cuánto estamos gastando en capacitar y en qué estado están los cursos?
-- ------------------------------------------------------------------
CREATE OR REPLACE VIEW v_Analisis_Capacitaciones AS
SELECT 
    df.Anio,
    de.NombreCompleto,
    dd.NombreDepartamento,
    dc.NombreCapacitacion,
    dc.Proveedor,
    fc.Estado AS EstadoCurso,
    fc.CalificacionObtenida,
    fc.CostoCapacitacion
FROM FactCapacitaciones fc
JOIN DimFecha df ON fc.FechaKey = df.FechaKey
JOIN DimEmpleado de ON fc.EmpleadoKey = de.EmpleadoKey
JOIN DimDepartamento dd ON fc.DepartamentoKey = dd.DepartamentoKey
JOIN DimCapacitacion dc ON fc.CapacitacionKey = dc.CapacitacionKey;

-- Consulta de comprobación para ver una de las vistas funcionando:
SELECT * FROM v_Analisis_Ausentismo LIMIT 10;