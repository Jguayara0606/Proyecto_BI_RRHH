USE RRHH_DW;

-- =========================================================
-- LIMPIEZA
-- =========================================================
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE FactCapacitaciones;
TRUNCATE TABLE FactEvaluaciones;
TRUNCATE TABLE FactAusencias;

TRUNCATE TABLE DimCapacitacion;
TRUNCATE TABLE DimTipoAusencia;
TRUNCATE TABLE DimEmpleado;
TRUNCATE TABLE DimPuesto;
TRUNCATE TABLE DimDepartamento;
TRUNCATE TABLE DimOficina;
TRUNCATE TABLE DimFecha;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- TABLA TEMPORAL DE NÚMEROS 0..1095
-- PARA GENERAR FECHAS 2023-01-01 A 2025-12-31
-- =========================================================
DROP TEMPORARY TABLE IF EXISTS tmp_numeros_fecha;
CREATE TEMPORARY TABLE tmp_numeros_fecha (
    n INT PRIMARY KEY
);

INSERT INTO tmp_numeros_fecha (n)
SELECT u.n + d.n * 10 + c.n * 100 + m.n * 1000 AS numero
FROM
    (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) u
CROSS JOIN
    (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d
CROSS JOIN
    (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
CROSS JOIN
    (SELECT 0 AS n UNION ALL SELECT 1) m
WHERE (u.n + d.n * 10 + c.n * 100 + m.n * 1000) <= 1095;

-- =========================================================
-- DIM FECHA
-- =========================================================
INSERT INTO DimFecha
(FechaKey, FechaCompleta, Anio, Semestre, Trimestre, Mes, NombreMes, Dia, NombreDiaSemana)
SELECT
    DATE_FORMAT(DATE_ADD('2023-01-01', INTERVAL n DAY), '%Y%m%d') + 0 AS FechaKey,
    DATE_ADD('2023-01-01', INTERVAL n DAY) AS FechaCompleta,
    YEAR(DATE_ADD('2023-01-01', INTERVAL n DAY)) AS Anio,
    CASE
        WHEN MONTH(DATE_ADD('2023-01-01', INTERVAL n DAY)) BETWEEN 1 AND 6 THEN 1
        ELSE 2
    END AS Semestre,
    QUARTER(DATE_ADD('2023-01-01', INTERVAL n DAY)) AS Trimestre,
    MONTH(DATE_ADD('2023-01-01', INTERVAL n DAY)) AS Mes,
    MONTHNAME(DATE_ADD('2023-01-01', INTERVAL n DAY)) AS NombreMes,
    DAY(DATE_ADD('2023-01-01', INTERVAL n DAY)) AS Dia,
    DAYNAME(DATE_ADD('2023-01-01', INTERVAL n DAY)) AS NombreDiaSemana
FROM tmp_numeros_fecha
WHERE DATE_ADD('2023-01-01', INTERVAL n DAY) <= '2025-12-31';

-- =========================================================
-- DIM OFICINA
-- =========================================================
INSERT INTO DimOficina
(OficinaID_OLTP, CodigoOficina, Ciudad, Pais, Region, CodigoPostal)
SELECT
    OficinaID,
    CodigoOficina,
    Ciudad,
    Pais,
    Region,
    CodigoPostal
FROM RRHH_OLTP.Oficinas;

-- =========================================================
-- DIM DEPARTAMENTO
-- =========================================================
INSERT INTO DimDepartamento
(DepartamentoID_OLTP, NombreDepartamento, Descripcion)
SELECT
    DepartamentoID,
    NombreDepartamento,
    Descripcion
FROM RRHH_OLTP.Departamentos;

-- =========================================================
-- DIM PUESTO
-- =========================================================
INSERT INTO DimPuesto
(PuestoID_OLTP, NombrePuesto, NivelSalarial, SalarioMinimo, SalarioMaximo)
SELECT
    PuestoID,
    NombrePuesto,
    NivelSalarial,
    SalarioMinimo,
    SalarioMaximo
FROM RRHH_OLTP.Puestos;

-- =========================================================
-- DIM EMPLEADO
-- =========================================================
INSERT INTO DimEmpleado
(EmpleadoID_OLTP, Identificacion, NombreCompleto, Genero, EstadoCivil, Edad, FechaContratacion,
 AntiguedadAnios, Activo, DepartamentoID_OLTP, PuestoID_OLTP, OficinaID_OLTP, JefeID_OLTP)
SELECT
    e.EmpleadoID,
    e.Identificacion,
    CONCAT(e.Nombre, ' ', e.Apellidos) AS NombreCompleto,
    e.Genero,
    e.EstadoCivil,
    TIMESTAMPDIFF(YEAR, e.FechaNacimiento, CURDATE()) AS Edad,
    e.FechaContratacion,
    TIMESTAMPDIFF(YEAR, e.FechaContratacion, CURDATE()) AS AntiguedadAnios,
    e.Activo,
    e.DepartamentoID,
    e.PuestoID,
    e.OficinaID,
    e.JefeID
FROM RRHH_OLTP.Empleados e;

-- =========================================================
-- DIM TIPO AUSENCIA
-- =========================================================
INSERT INTO DimTipoAusencia
(TipoAusencia)
SELECT DISTINCT
    TipoAusencia
FROM RRHH_OLTP.Ausencias;

-- =========================================================
-- DIM CAPACITACION
-- =========================================================
INSERT INTO DimCapacitacion
(CapacitacionID_OLTP, NombreCapacitacion, Proveedor, Costo, DuracionDias)
SELECT
    CapacitacionID,
    NombreCapacitacion,
    Proveedor,
    Costo,
    DuracionDias
FROM RRHH_OLTP.Capacitaciones;

-- =========================================================
-- FACT AUSENCIAS
-- =========================================================
INSERT INTO FactAusencias
(FechaKey, EmpleadoKey, OficinaKey, DepartamentoKey, TipoAusenciaKey,
 CantidadAusencias, DiasAusencia, JustificadaFlag)
SELECT
    DATE_FORMAT(a.FechaInicio, '%Y%m%d') + 0 AS FechaKey,
    de.EmpleadoKey,
    dof.OficinaKey,
    dd.DepartamentoKey,
    dta.TipoAusenciaKey,
    1 AS CantidadAusencias,
    a.DiasTotales AS DiasAusencia,
    a.Justificada AS JustificadaFlag
FROM RRHH_OLTP.Ausencias a
JOIN RRHH_OLTP.Empleados e
    ON a.EmpleadoID = e.EmpleadoID
JOIN DimEmpleado de
    ON de.EmpleadoID_OLTP = e.EmpleadoID
JOIN DimOficina dof
    ON dof.OficinaID_OLTP = e.OficinaID
JOIN DimDepartamento dd
    ON dd.DepartamentoID_OLTP = e.DepartamentoID
JOIN DimTipoAusencia dta
    ON dta.TipoAusencia = a.TipoAusencia;

-- =========================================================
-- FACT EVALUACIONES
-- =========================================================
INSERT INTO FactEvaluaciones
(FechaKey, EmpleadoKey, EvaluadorEmpleadoKey, OficinaKey, DepartamentoKey, PuestoKey,
 Calificacion, CantidadEvaluaciones)
SELECT
    DATE_FORMAT(ev.FechaEvaluacion, '%Y%m%d') + 0 AS FechaKey,
    de.EmpleadoKey,
    dev.EmpleadoKey AS EvaluadorEmpleadoKey,
    dof.OficinaKey,
    dd.DepartamentoKey,
    dp.PuestoKey,
    ev.Calificacion,
    1 AS CantidadEvaluaciones
FROM RRHH_OLTP.EvaluacionesDesempeno ev
JOIN RRHH_OLTP.Empleados e
    ON ev.EmpleadoEvaluadoID = e.EmpleadoID
JOIN DimEmpleado de
    ON de.EmpleadoID_OLTP = e.EmpleadoID
JOIN DimEmpleado dev
    ON dev.EmpleadoID_OLTP = ev.EvaluadorID
JOIN DimOficina dof
    ON dof.OficinaID_OLTP = e.OficinaID
JOIN DimDepartamento dd
    ON dd.DepartamentoID_OLTP = e.DepartamentoID
JOIN DimPuesto dp
    ON dp.PuestoID_OLTP = e.PuestoID;

-- =========================================================
-- FACT CAPACITACIONES
-- =========================================================
INSERT INTO FactCapacitaciones
(FechaKey, EmpleadoKey, CapacitacionKey, OficinaKey, DepartamentoKey, PuestoKey,
 Estado, CalificacionObtenida, CantidadAsignaciones, CostoCapacitacion)
SELECT
    DATE_FORMAT(IFNULL(ec.FechaCompletado, c.FechaInicio), '%Y%m%d') + 0 AS FechaKey,
    de.EmpleadoKey,
    dc.CapacitacionKey,
    dof.OficinaKey,
    dd.DepartamentoKey,
    dp.PuestoKey,
    ec.Estado,
    ec.CalificacionObtenida,
    1 AS CantidadAsignaciones,
    c.Costo AS CostoCapacitacion
FROM RRHH_OLTP.EmpleadosCapacitaciones ec
JOIN RRHH_OLTP.Empleados e
    ON ec.EmpleadoID = e.EmpleadoID
JOIN RRHH_OLTP.Capacitaciones c
    ON ec.CapacitacionID = c.CapacitacionID
JOIN DimEmpleado de
    ON de.EmpleadoID_OLTP = e.EmpleadoID
JOIN DimCapacitacion dc
    ON dc.CapacitacionID_OLTP = c.CapacitacionID
JOIN DimOficina dof
    ON dof.OficinaID_OLTP = e.OficinaID
JOIN DimDepartamento dd
    ON dd.DepartamentoID_OLTP = e.DepartamentoID
JOIN DimPuesto dp
    ON dp.PuestoID_OLTP = e.PuestoID;

-- =========================================================
-- VALIDACIONES
-- =========================================================
SELECT COUNT(*) AS TotalDimFecha FROM DimFecha;
SELECT COUNT(*) AS TotalDimOficina FROM DimOficina;
SELECT COUNT(*) AS TotalDimDepartamento FROM DimDepartamento;
SELECT COUNT(*) AS TotalDimPuesto FROM DimPuesto;
SELECT COUNT(*) AS TotalDimEmpleado FROM DimEmpleado;
SELECT COUNT(*) AS TotalDimTipoAusencia FROM DimTipoAusencia;
SELECT COUNT(*) AS TotalDimCapacitacion FROM DimCapacitacion;

SELECT COUNT(*) AS TotalFactAusencias FROM FactAusencias;
SELECT COUNT(*) AS TotalFactEvaluaciones FROM FactEvaluaciones;
SELECT COUNT(*) AS TotalFactCapacitaciones FROM FactCapacitaciones;