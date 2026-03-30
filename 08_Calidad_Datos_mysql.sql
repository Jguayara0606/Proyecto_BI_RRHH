USE RRHH_DW;

-- =======================================================================================
-- SCRIPT 08: VALIDACIONES DE CALIDAD DE DATOS (DATA QUALITY)
-- =======================================================================================
-- Descripción: Script analítico para detectar anomalías lógicas en el Data Warehouse
-- antes de proceder a la creación de tableros de control y métricas gerenciales.
-- =======================================================================================

-- 1. Auditoría de Edades: Buscar empleados con edades atípicas (menores de 18 o mayores de 80)
-- Propósito: Detectar errores de tipeo en las fechas de nacimiento del OLTP.
SELECT 
    EmpleadoKey, 
    NombreCompleto, 
    Edad,
    'Edad fuera de rango' AS TipoAnomalia
FROM DimEmpleado
WHERE Edad < 18 OR Edad > 80;

-- 2. Auditoría Financiera: Buscar salarios base iguales a cero o negativos
-- Propósito: Evitar errores de cálculo en los presupuestos de nómina.
SELECT 
    PuestoKey, 
    NombrePuesto, 
    SalarioMinimo, 
    SalarioMaximo,
    'Salario inválido' AS TipoAnomalia
FROM DimPuesto
WHERE SalarioMinimo <= 0 OR SalarioMaximo <= 0;

-- 3. Auditoría de Desempeño: Evaluaciones fuera del rango permitido (asumiendo escala 0 a 100)
-- Propósito: Encontrar calificaciones mal digitadas por los jefes.
SELECT 
    EmpleadoKey, 
    FechaKey, 
    Calificacion,
    'Calificación fuera de escala' AS TipoAnomalia
FROM FactEvaluaciones
WHERE Calificacion < 0 OR Calificacion > 100;

-- 4. Auditoría de Ausentismo: Ausencias extremadamente largas (más de 30 días en un solo registro)
-- Propósito: Detectar posibles abandonos de cargo o licencias mal registradas.
SELECT 
    fa.EmpleadoKey, 
    de.NombreCompleto,
    dta.TipoAusencia, 
    fa.DiasAusencia,
    'Ausencia anormalmente larga' AS TipoAnomalia
FROM FactAusencias fa
JOIN DimEmpleado de ON fa.EmpleadoKey = de.EmpleadoKey
JOIN DimTipoAusencia dta ON fa.TipoAusenciaKey = dta.TipoAusenciaKey
WHERE fa.DiasAusencia > 30;

-- 5. Auditoría de Integridad: Empleados "huérfanos" (Sin departamento asignado)
-- Propósito: Garantizar que todos los empleados pertenezcan a un área de la empresa.
SELECT 
    EmpleadoKey, 
    NombreCompleto, 
    DepartamentoID_OLTP,
    'Empleado sin departamento' AS TipoAnomalia
FROM DimEmpleado
WHERE DepartamentoID_OLTP IS NULL;