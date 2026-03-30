USE RRHH_OLTP;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Ausencias;
TRUNCATE TABLE EvaluacionesDesempeno;
TRUNCATE TABLE EmpleadosCapacitaciones;
TRUNCATE TABLE Capacitaciones;
TRUNCATE TABLE Empleados;
TRUNCATE TABLE Puestos;
TRUNCATE TABLE Departamentos;
TRUNCATE TABLE Oficinas;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- OFICINAS
-- =========================================================
INSERT INTO Oficinas
(CodigoOficina, Ciudad, Pais, Region, CodigoPostal, Telefono, Direccion)
VALUES
('MAD-CENTRO', 'Madrid', 'España', 'Europa', '28001', '+34-910000001', 'Calle Gran Vía 100'),
('BOG-NORTE', 'Bogotá', 'Colombia', 'LatAm', '110111', '+57-601000001', 'Carrera 15 #100-20'),
('MEX-POLANCO', 'Ciudad de México', 'México', 'LatAm', '11560', '+52-550000001', 'Av. Ejército Nacional 250'),
('LIM-SANISIDRO', 'Lima', 'Perú', 'LatAm', '15073', '+51-100000001', 'Av. Javier Prado 850'),
('BUE-PUERTO', 'Buenos Aires', 'Argentina', 'Cono Sur', 'C1107', '+54-110000001', 'Av. Alicia Moreau 300');

-- =========================================================
-- DEPARTAMENTOS
-- =========================================================
INSERT INTO Departamentos (NombreDepartamento, Descripcion, OficinaID)
SELECT 'Recursos Humanos', 'Gestión integral de talento humano', OficinaID
FROM Oficinas
WHERE CodigoOficina = 'BOG-NORTE';

INSERT INTO Departamentos (NombreDepartamento, Descripcion, OficinaID)
SELECT 'Tecnología', 'Desarrollo, soporte e infraestructura', OficinaID
FROM Oficinas
WHERE CodigoOficina = 'MAD-CENTRO';

INSERT INTO Departamentos (NombreDepartamento, Descripcion, OficinaID)
SELECT 'Ventas', 'Gestión comercial y cierre de negocios', OficinaID
FROM Oficinas
WHERE CodigoOficina = 'MEX-POLANCO';

INSERT INTO Departamentos (NombreDepartamento, Descripcion, OficinaID)
SELECT 'Finanzas', 'Planeación financiera y contabilidad', OficinaID
FROM Oficinas
WHERE CodigoOficina = 'LIM-SANISIDRO';

INSERT INTO Departamentos (NombreDepartamento, Descripcion, OficinaID)
SELECT 'Marketing', 'Marca, campañas y estrategia digital', OficinaID
FROM Oficinas
WHERE CodigoOficina = 'BUE-PUERTO';

-- =========================================================
-- PUESTOS
-- =========================================================
INSERT INTO Puestos
(NombrePuesto, NivelSalarial, SalarioMinimo, SalarioMaximo)
VALUES
('Gerente RRHH', 'Senior', 8000, 14000),
('Analista RRHH', 'Mid-Level', 3500, 7000),
('Desarrollador Junior', 'Junior', 3000, 5500),
('Desarrollador Senior', 'Senior', 7000, 13000),
('Administrador de Infraestructura', 'Mid-Level', 4500, 8500),
('Analista de Ventas', 'Mid-Level', 3500, 7500),
('Ejecutivo Comercial', 'Junior', 2800, 6000),
('Analista Financiero', 'Mid-Level', 4000, 8000),
('Contador Senior', 'Senior', 7000, 12000),
('Especialista Marketing Digital', 'Mid-Level', 3500, 7800);
SELECT * FROM puestos;
-- =========================================================
-- 5 JEFES / RESPONSABLES
-- =========================================================
INSERT INTO Empleados
(Identificacion, Nombre, Apellidos, FechaNacimiento, Genero, EstadoCivil, Email, Telefono,
 FechaContratacion, DepartamentoID, PuestoID, SalarioActual, JefeID, OficinaID, Activo)
SELECT
    'EMP001','Laura','Gómez','1985-03-10','Femenino','Casado(a)',
    'laura.gomez@talentcorp.com','300000001',
    '2018-01-15', d.DepartamentoID, p.PuestoID, 12000, NULL, d.OficinaID, 1
FROM Departamentos d
JOIN Puestos p ON p.NombrePuesto = 'Gerente RRHH'
WHERE d.NombreDepartamento = 'Recursos Humanos';

INSERT INTO Empleados
(Identificacion, Nombre, Apellidos, FechaNacimiento, Genero, EstadoCivil, Email, Telefono,
 FechaContratacion, DepartamentoID, PuestoID, SalarioActual, JefeID, OficinaID, Activo)
SELECT
    'EMP002','Carlos','Ruiz','1984-06-21','Masculino','Casado(a)',
    'carlos.ruiz@talentcorp.com','300000002',
    '2017-04-03', d.DepartamentoID, p.PuestoID, 12500, NULL, d.OficinaID, 1
FROM Departamentos d
JOIN Puestos p ON p.NombrePuesto = 'Desarrollador Senior'
WHERE d.NombreDepartamento = 'Tecnología';

INSERT INTO Empleados
(Identificacion, Nombre, Apellidos, FechaNacimiento, Genero, EstadoCivil, Email, Telefono,
 FechaContratacion, DepartamentoID, PuestoID, SalarioActual, JefeID, OficinaID, Activo)
SELECT
    'EMP003','Mariana','López','1987-11-08','Femenino','Soltero(a)',
    'mariana.lopez@talentcorp.com','300000003',
    '2019-07-01', d.DepartamentoID, p.PuestoID, 11000, NULL, d.OficinaID, 1
FROM Departamentos d
JOIN Puestos p ON p.NombrePuesto = 'Analista de Ventas'
WHERE d.NombreDepartamento = 'Ventas';

INSERT INTO Empleados
(Identificacion, Nombre, Apellidos, FechaNacimiento, Genero, EstadoCivil, Email, Telefono,
 FechaContratacion, DepartamentoID, PuestoID, SalarioActual, JefeID, OficinaID, Activo)
SELECT
    'EMP004','Andrés','Morales','1982-02-18','Masculino','Casado(a)',
    'andres.morales@talentcorp.com','300000004',
    '2016-09-12', d.DepartamentoID, p.PuestoID, 11500, NULL, d.OficinaID, 1
FROM Departamentos d
JOIN Puestos p ON p.NombrePuesto = 'Contador Senior'
WHERE d.NombreDepartamento = 'Finanzas';

INSERT INTO Empleados
(Identificacion, Nombre, Apellidos, FechaNacimiento, Genero, EstadoCivil, Email, Telefono,
 FechaContratacion, DepartamentoID, PuestoID, SalarioActual, JefeID, OficinaID, Activo)
SELECT
    'EMP005','Sofía','Paredes','1988-05-27','Femenino','Soltero(a)',
    'sofia.paredes@talentcorp.com','300000005',
    '2020-03-20', d.DepartamentoID, p.PuestoID, 9800, NULL, d.OficinaID, 1
FROM Departamentos d
JOIN Puestos p ON p.NombrePuesto = 'Especialista Marketing Digital'
WHERE d.NombreDepartamento = 'Marketing';
SELECT * FROM Empleados;
-- =========================================================
-- TABLA TEMPORAL DE NÚMEROS 1..45
-- =========================================================
DROP TEMPORARY TABLE IF EXISTS tmp_numeros;
CREATE TEMPORARY TABLE tmp_numeros (
    n INT PRIMARY KEY
);

INSERT INTO tmp_numeros (n)
VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
(41),(42),(43),(44),(45);

-- =========================================================
-- 45 EMPLEADOS ADICIONALES
-- TOTAL = 50
-- =========================================================
INSERT INTO Empleados
(Identificacion, Nombre, Apellidos, FechaNacimiento, Genero, EstadoCivil, Email, Telefono,
 FechaContratacion, DepartamentoID, PuestoID, SalarioActual, JefeID, OficinaID, Activo)
SELECT
    CONCAT('EMP', LPAD(n.n + 5, 3, '0')) AS Identificacion,
    CASE MOD(n.n, 10)
        WHEN 1 THEN 'Juan'
        WHEN 2 THEN 'Ana'
        WHEN 3 THEN 'Pedro'
        WHEN 4 THEN 'Luisa'
        WHEN 5 THEN 'Miguel'
        WHEN 6 THEN 'Valentina'
        WHEN 7 THEN 'Diego'
        WHEN 8 THEN 'Camila'
        WHEN 9 THEN 'Jorge'
        ELSE 'Daniela'
    END AS Nombre,
    CASE MOD(n.n, 10)
        WHEN 1 THEN 'Pérez'
        WHEN 2 THEN 'Martínez'
        WHEN 3 THEN 'Rodríguez'
        WHEN 4 THEN 'Fernández'
        WHEN 5 THEN 'Torres'
        WHEN 6 THEN 'Ramírez'
        WHEN 7 THEN 'Castro'
        WHEN 8 THEN 'Sánchez'
        WHEN 9 THEN 'Vargas'
        ELSE 'Mendoza'
    END AS Apellidos,
    DATE_ADD('1988-01-01', INTERVAL n.n * 200 DAY) AS FechaNacimiento,
    CASE WHEN MOD(n.n, 2) = 0 THEN 'Femenino' ELSE 'Masculino' END AS Genero,
    CASE WHEN MOD(n.n, 3) = 0 THEN 'Casado(a)' ELSE 'Soltero(a)' END AS EstadoCivil,
    CONCAT('empleado', n.n + 5, '@talentcorp.com') AS Email,
    CONCAT('310000', LPAD(n.n, 3, '0')) AS Telefono,
    DATE_ADD('2020-01-01', INTERVAL n.n * 30 DAY) AS FechaContratacion,
    d.DepartamentoID,
    CASE
        WHEN d.NombreDepartamento = 'Recursos Humanos' THEN p_rrhh.PuestoID
        WHEN d.NombreDepartamento = 'Tecnología' AND MOD(n.n, 2) = 0 THEN p_devjr.PuestoID
        WHEN d.NombreDepartamento = 'Tecnología' AND MOD(n.n, 2) = 1 THEN p_infra.PuestoID
        WHEN d.NombreDepartamento = 'Ventas' AND MOD(n.n, 2) = 0 THEN p_ejv.PuestoID
        WHEN d.NombreDepartamento = 'Ventas' AND MOD(n.n, 2) = 1 THEN p_av.PuestoID
        WHEN d.NombreDepartamento = 'Finanzas' THEN p_af.PuestoID
        WHEN d.NombreDepartamento = 'Marketing' THEN p_mkt.PuestoID
    END AS PuestoID,
    CASE
        WHEN d.NombreDepartamento = 'Recursos Humanos' THEN 4200 + (n.n * 20)
        WHEN d.NombreDepartamento = 'Tecnología' THEN 5000 + (n.n * 50)
        WHEN d.NombreDepartamento = 'Ventas' THEN 3900 + (n.n * 30)
        WHEN d.NombreDepartamento = 'Finanzas' THEN 4700 + (n.n * 35)
        WHEN d.NombreDepartamento = 'Marketing' THEN 4100 + (n.n * 25)
    END AS SalarioActual,
    jefe.EmpleadoID AS JefeID,
    d.OficinaID,
    1 AS Activo
FROM tmp_numeros n
JOIN Departamentos d
    ON d.NombreDepartamento =
       CASE
           WHEN n.n BETWEEN 1 AND 8 THEN 'Recursos Humanos'
           WHEN n.n BETWEEN 9 AND 20 THEN 'Tecnología'
           WHEN n.n BETWEEN 21 AND 30 THEN 'Ventas'
           WHEN n.n BETWEEN 31 AND 38 THEN 'Finanzas'
           ELSE 'Marketing'
       END
JOIN Empleados jefe
    ON jefe.DepartamentoID = d.DepartamentoID
   AND jefe.JefeID IS NULL
JOIN Puestos p_rrhh ON p_rrhh.NombrePuesto = 'Analista RRHH'
JOIN Puestos p_devjr ON p_devjr.NombrePuesto = 'Desarrollador Junior'
JOIN Puestos p_infra ON p_infra.NombrePuesto = 'Administrador de Infraestructura'
JOIN Puestos p_ejv ON p_ejv.NombrePuesto = 'Ejecutivo Comercial'
JOIN Puestos p_av ON p_av.NombrePuesto = 'Analista de Ventas'
JOIN Puestos p_af ON p_af.NombrePuesto = 'Analista Financiero'
JOIN Puestos p_mkt ON p_mkt.NombrePuesto = 'Especialista Marketing Digital';

-- =========================================================
-- VALIDACIÓN EMPLEADOS
-- =========================================================
SELECT COUNT(*) AS TotalEmpleados FROM Empleados;

-- =========================================================
-- TABLA TEMPORAL DE NÚMEROS 1..100
-- =========================================================
DROP TEMPORARY TABLE IF EXISTS tmp_100;
CREATE TEMPORARY TABLE tmp_100 (
    n INT PRIMARY KEY
);

INSERT INTO tmp_100 (n)
VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
(41),(42),(43),(44),(45),(46),(47),(48),(49),(50),
(51),(52),(53),(54),(55),(56),(57),(58),(59),(60),
(61),(62),(63),(64),(65),(66),(67),(68),(69),(70),
(71),(72),(73),(74),(75),(76),(77),(78),(79),(80),
(81),(82),(83),(84),(85),(86),(87),(88),(89),(90),
(91),(92),(93),(94),(95),(96),(97),(98),(99),(100);

-- =========================================================
-- AUSENCIAS
-- =========================================================
DROP TEMPORARY TABLE IF EXISTS tmp_empleados_rn;
CREATE TEMPORARY TABLE tmp_empleados_rn (
    rn INT AUTO_INCREMENT PRIMARY KEY,
    EmpleadoID INT NOT NULL
);

INSERT INTO tmp_empleados_rn (EmpleadoID)
SELECT EmpleadoID
FROM Empleados
ORDER BY EmpleadoID;

INSERT INTO Ausencias
(EmpleadoID, TipoAusencia, FechaInicio, FechaFin, Justificada, Comentarios, FechaRegistro)
SELECT
    e.EmpleadoID,
    CASE MOD(t.n, 4)
        WHEN 1 THEN 'Vacaciones'
        WHEN 2 THEN 'Enfermedad'
        WHEN 3 THEN 'Permiso Personal'
        ELSE 'Licencia Médica'
    END,
    DATE_ADD('2023-01-01', INTERVAL t.n * 5 DAY),
    DATE_ADD('2023-01-01', INTERVAL (t.n * 5 + MOD(t.n, 6)) DAY),
    CASE WHEN MOD(t.n, 5) = 0 THEN 0 ELSE 1 END,
    CONCAT('Registro de ausencia #', t.n),
    DATE_ADD('2023-01-01', INTERVAL t.n * 5 DAY)
FROM tmp_100 t
JOIN tmp_empleados_rn e
  ON e.rn = MOD(t.n - 1, (SELECT COUNT(*) FROM Empleados)) + 1;

-- =========================================================
-- TABLA TEMPORAL DE NÚMEROS 1..80
-- =========================================================
DROP TEMPORARY TABLE IF EXISTS tmp_80;
CREATE TEMPORARY TABLE tmp_80 (
    n INT PRIMARY KEY
);

INSERT INTO tmp_80 (n)
VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
(41),(42),(43),(44),(45),(46),(47),(48),(49),(50),
(51),(52),(53),(54),(55),(56),(57),(58),(59),(60),
(61),(62),(63),(64),(65),(66),(67),(68),(69),(70),
(71),(72),(73),(74),(75),(76),(77),(78),(79),(80);

-- =========================================================
-- EVALUACIONES
-- =========================================================
INSERT INTO EvaluacionesDesempeno
(EmpleadoEvaluadoID, FechaEvaluacion, Calificacion, EvaluadorID, Comentarios, FechaRegistro)
SELECT
    e.EmpleadoID,
    DATE_ADD('2023-01-15', INTERVAL t.n * 12 DAY),
    ROUND(3.0 + (MOD(t.n, 20) * 0.1), 1),
    jefe.EmpleadoID,
    CONCAT('Evaluación de desempeño #', t.n, '. Resultado satisfactorio con oportunidades de mejora.'),
    DATE_ADD('2023-01-15', INTERVAL t.n * 12 DAY)
FROM tmp_80 t
JOIN tmp_empleados_rn e
  ON e.rn = MOD(t.n - 1, (SELECT COUNT(*) FROM Empleados)) + 1
JOIN Empleados emp
  ON emp.EmpleadoID = e.EmpleadoID
JOIN Empleados jefe
  ON jefe.DepartamentoID = emp.DepartamentoID
 AND jefe.JefeID IS NULL;

-- =========================================================
-- CAPACITACIONES
-- =========================================================
INSERT INTO Capacitaciones
(NombreCapacitacion, Descripcion, Proveedor, Costo, FechaInicio, FechaFin)
VALUES
('Liderazgo', 'Habilidades de liderazgo y gestión de equipos', 'SkillCenter', 1500, '2023-02-10', '2023-02-12'),
('Excel Avanzado', 'Funciones avanzadas, Power Query y dashboards', 'DataAcademy', 800, '2023-03-05', '2023-03-06'),
('Power BI', 'Modelado de datos y visualización', 'BI Labs', 1200, '2023-04-15', '2023-04-17'),
('Python', 'Automatización y análisis de datos con Python', 'TechSchool', 1800, '2023-05-20', '2023-05-24'),
('Marketing Digital', 'Estrategia digital y campañas', 'GrowthHub', 1000, '2023-06-10', '2023-06-12'),
('SQL Server', 'Consultas y optimización', 'DB Institute', 1600, '2023-07-05', '2023-07-08'),
('Comunicación Efectiva', 'Habilidades blandas corporativas', 'Talent Academy', 600, '2024-01-12', '2024-01-13'),
('Gestión del Tiempo', 'Productividad y priorización', 'SkillCenter', 500, '2024-02-20', '2024-02-20'),
('Finanzas para No Financieros', 'Conceptos base financieros', 'FinancePro', 900, '2024-03-14', '2024-03-15'),
('Analítica de RRHH', 'KPIs de talento y people analytics', 'HR Metrics', 1400, '2024-05-10', '2024-05-12');

-- =========================================================
-- TABLA TEMPORAL DE NÚMEROS 1..50
-- =========================================================
DROP TEMPORARY TABLE IF EXISTS tmp_50;
CREATE TEMPORARY TABLE tmp_50 (
    n INT PRIMARY KEY
);

INSERT INTO tmp_50 (n)
VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
(41),(42),(43),(44),(45),(46),(47),(48),(49),(50);

DROP TEMPORARY TABLE IF EXISTS tmp_caps_rn;
CREATE TEMPORARY TABLE tmp_caps_rn (
    rn INT AUTO_INCREMENT PRIMARY KEY,
    CapacitacionID INT NOT NULL
);

INSERT INTO tmp_caps_rn (CapacitacionID)
SELECT CapacitacionID
FROM Capacitaciones
ORDER BY CapacitacionID;

-- =========================================================
-- EMPLEADOS CAPACITACIONES
-- =========================================================
INSERT INTO EmpleadosCapacitaciones
(EmpleadoID, CapacitacionID, CalificacionObtenida, FechaCompletado, Estado, Comentarios)
SELECT
    e.EmpleadoID,
    c.CapacitacionID,
    CASE WHEN MOD(t.n, 4) = 0 THEN NULL ELSE 60 + MOD(t.n, 41) END,
    CASE WHEN MOD(t.n, 4) = 0 THEN NULL ELSE DATE_ADD('2023-02-15', INTERVAL t.n * 10 DAY) END,
    CASE WHEN MOD(t.n, 4) = 0 THEN 'En Curso' ELSE 'Completada' END,
    CONCAT('Seguimiento capacitación #', t.n)
FROM tmp_50 t
JOIN tmp_empleados_rn e
  ON e.rn = t.n
JOIN tmp_caps_rn c
  ON c.rn = MOD(t.n - 1, 10) + 1;

-- =========================================================
-- VALIDACIONES FINALES
-- =========================================================
SELECT COUNT(*) AS TotalOficinas FROM Oficinas;
SELECT COUNT(*) AS TotalDepartamentos FROM Departamentos;
SELECT COUNT(*) AS TotalPuestos FROM Puestos;
SELECT COUNT(*) AS TotalEmpleados FROM Empleados;
SELECT COUNT(*) AS TotalAusencias FROM Ausencias;
SELECT COUNT(*) AS TotalEvaluaciones FROM EvaluacionesDesempeno;
SELECT COUNT(*) AS TotalCapacitaciones FROM Capacitaciones;
SELECT COUNT(*) AS TotalEmpleadoCapacitaciones FROM EmpleadosCapacitaciones;