USE RRHH_DW;

-- =======================================================================================
-- SCRIPT 07: ETL - POBLAR NUEVA TABLA DE HECHOS (FactMovimientos)
-- =======================================================================================

-- 1. Limpiamos la tabla por si lo ejecutamos varias veces
TRUNCATE TABLE FactMovimientos;

-- 2. Insertamos usando exactamente la misma técnica de JOINs del profesor
INSERT INTO FactMovimientos (
    FechaKey,
    EmpleadoKey,
    DepartamentoKey,
    OficinaKey,
    TipoMovimiento,
    SalarioActual
)
SELECT 
    -- Tomamos la llave de fecha ya validada
    df.FechaKey,
    de.EmpleadoKey,
    dd.DepartamentoKey,
    dof.OficinaKey,
    'Contratación Inicial' AS TipoMovimiento,
    dp.SalarioMinimo AS SalarioActual 
FROM RRHH_OLTP.Empleados e
-- Hacemos los JOINs conectando el ID operativo (OLTP) con las dimensiones
JOIN DimEmpleado de 
    ON de.EmpleadoID_OLTP = e.EmpleadoID
JOIN DimOficina dof 
    ON dof.OficinaID_OLTP = e.OficinaID
JOIN DimDepartamento dd 
    ON dd.DepartamentoID_OLTP = e.DepartamentoID
JOIN DimPuesto dp 
    ON dp.PuestoID_OLTP = e.PuestoID
-- ESTA ES LA SOLUCIÓN: Solo cruzamos con fechas que SÍ existan en el calendario del profe
JOIN DimFecha df 
    ON df.FechaKey = DATE_FORMAT(e.FechaContratacion, '%Y%m%d') + 0;

-- 3. Comprobación para ver el éxito de la carga
SELECT COUNT(*) AS TotalFactMovimientos FROM FactMovimientos;
SELECT * FROM FactMovimientos LIMIT 10;