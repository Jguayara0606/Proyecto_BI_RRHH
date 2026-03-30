/* =========================================================
   01_OLTP_RRHH_mysql.sql
   ========================================================= */

DROP DATABASE IF EXISTS RRHH_OLTP;
CREATE DATABASE RRHH_OLTP;
USE RRHH_OLTP;

/* =========================================================
   TABLAS MAESTRAS
   ========================================================= */

CREATE TABLE Oficinas (
    OficinaID         INT AUTO_INCREMENT PRIMARY KEY,
    CodigoOficina     VARCHAR(20) NOT NULL UNIQUE,
    Ciudad            VARCHAR(100) NOT NULL,
    Pais              VARCHAR(100) NOT NULL,
    Region            VARCHAR(100) NOT NULL,
    CodigoPostal      VARCHAR(20) NULL,
    Telefono          VARCHAR(30) NULL,
    Direccion         VARCHAR(200) NOT NULL,
    FechaCreacion     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Departamentos (
    DepartamentoID      INT AUTO_INCREMENT PRIMARY KEY,
    NombreDepartamento  VARCHAR(100) NOT NULL UNIQUE,
    Descripcion         VARCHAR(250) NULL,
    OficinaID           INT NOT NULL,
    FechaCreacion       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Departamentos_Oficinas
        FOREIGN KEY (OficinaID) REFERENCES Oficinas(OficinaID)
) ;

CREATE TABLE Puestos (
    PuestoID            INT AUTO_INCREMENT PRIMARY KEY,
    NombrePuesto        VARCHAR(120) NOT NULL,
    NivelSalarial       VARCHAR(20) NOT NULL,
    SalarioMinimo       DECIMAL(12,2) NOT NULL,
    SalarioMaximo       DECIMAL(12,2) NOT NULL,
    FechaCreacion       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT CK_Puestos_NivelSalarial
        CHECK (NivelSalarial IN ('Junior','Mid-Level','Senior')),
    CONSTRAINT CK_Puestos_RangoSalario
        CHECK (SalarioMinimo > 0 AND SalarioMaximo >= SalarioMinimo)
) ;

/* =========================================================
   EMPLEADOS
   ========================================================= */

CREATE TABLE Empleados (
    EmpleadoID            INT AUTO_INCREMENT PRIMARY KEY,
    Identificacion        VARCHAR(30) NOT NULL UNIQUE,
    Nombre                VARCHAR(80) NOT NULL,
    Apellidos             VARCHAR(120) NOT NULL,
    FechaNacimiento       DATE NOT NULL,
    Genero                VARCHAR(20) NOT NULL,
    EstadoCivil           VARCHAR(30) NOT NULL,
    Email                 VARCHAR(150) NOT NULL UNIQUE,
    Telefono              VARCHAR(30) NULL,
    FechaContratacion     DATE NOT NULL,
    DepartamentoID        INT NOT NULL,
    PuestoID              INT NOT NULL,
    SalarioActual         DECIMAL(12,2) NOT NULL,
    JefeID                INT NULL,
    OficinaID             INT NOT NULL,
    Activo                TINYINT(1) NOT NULL DEFAULT 1,
    FechaCreacion         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Empleados_Departamentos
        FOREIGN KEY (DepartamentoID) REFERENCES Departamentos(DepartamentoID),
    CONSTRAINT FK_Empleados_Puestos
        FOREIGN KEY (PuestoID) REFERENCES Puestos(PuestoID),
    CONSTRAINT FK_Empleados_Oficinas
        FOREIGN KEY (OficinaID) REFERENCES Oficinas(OficinaID),
    CONSTRAINT FK_Empleados_Jefe
        FOREIGN KEY (JefeID) REFERENCES Empleados(EmpleadoID),
    CONSTRAINT CK_Empleados_Genero
        CHECK (Genero IN ('Masculino','Femenino','No Binario','Otro')),
    CONSTRAINT CK_Empleados_Salario
        CHECK (SalarioActual > 0)
) ;

/* =========================================================
   AUSENCIAS
   ========================================================= */

CREATE TABLE Ausencias (
    AusenciaID         INT AUTO_INCREMENT PRIMARY KEY,
    EmpleadoID         INT NOT NULL,
    TipoAusencia       VARCHAR(30) NOT NULL,
    FechaInicio        DATE NOT NULL,
    FechaFin           DATE NOT NULL,
    DiasTotales        INT GENERATED ALWAYS AS (DATEDIFF(FechaFin, FechaInicio) + 1) STORED,
    Justificada        TINYINT(1) NOT NULL,
    Comentarios        VARCHAR(300) NULL,
    FechaRegistro      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Ausencias_Empleados
        FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID),
    CONSTRAINT CK_Ausencias_Tipo
        CHECK (TipoAusencia IN ('Vacaciones','Enfermedad','Permiso Personal','Licencia Médica')),
    CONSTRAINT CK_Ausencias_Fechas
        CHECK (FechaFin >= FechaInicio)
) ;

/* =========================================================
   EVALUACIONES
   ========================================================= */

CREATE TABLE EvaluacionesDesempeno (
    EvaluacionID         INT AUTO_INCREMENT PRIMARY KEY,
    EmpleadoEvaluadoID   INT NOT NULL,
    FechaEvaluacion      DATE NOT NULL,
    Calificacion         DECIMAL(3,1) NOT NULL,
    EvaluadorID          INT NOT NULL,
    Comentarios          VARCHAR(500) NULL,
    FechaRegistro        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Evaluaciones_EmpleadoEvaluado
        FOREIGN KEY (EmpleadoEvaluadoID) REFERENCES Empleados(EmpleadoID),
    CONSTRAINT FK_Evaluaciones_Evaluador
        FOREIGN KEY (EvaluadorID) REFERENCES Empleados(EmpleadoID),
    CONSTRAINT CK_Evaluaciones_Calificacion
        CHECK (Calificacion BETWEEN 1.0 AND 5.0)
) ENGINE=InnoDB;

/* =========================================================
   CAPACITACIONES
   ========================================================= */

CREATE TABLE Capacitaciones (
    CapacitacionID       INT AUTO_INCREMENT PRIMARY KEY,
    NombreCapacitacion   VARCHAR(150) NOT NULL,
    Descripcion          VARCHAR(300) NULL,
    Proveedor            VARCHAR(150) NOT NULL,
    Costo                DECIMAL(12,2) NOT NULL,
    FechaInicio          DATE NOT NULL,
    FechaFin             DATE NOT NULL,
    DuracionDias         INT GENERATED ALWAYS AS (DATEDIFF(FechaFin, FechaInicio) + 1) STORED,
    FechaCreacion        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT CK_Capacitaciones_Costo
        CHECK (Costo >= 0),
    CONSTRAINT CK_Capacitaciones_Fechas
        CHECK (FechaFin >= FechaInicio)
) ;

CREATE TABLE EmpleadosCapacitaciones (
    EmpleadoCapacitacionID INT AUTO_INCREMENT PRIMARY KEY,
    EmpleadoID             INT NOT NULL,
    CapacitacionID         INT NOT NULL,
    CalificacionObtenida   DECIMAL(5,2) NULL,
    FechaCompletado        DATE NULL,
    Estado                 VARCHAR(20) NOT NULL,
    Comentarios            VARCHAR(300) NULL,
    FechaRegistro          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_EmpleadoCap_Empleados
        FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID),
    CONSTRAINT FK_EmpleadoCap_Capacitaciones
        FOREIGN KEY (CapacitacionID) REFERENCES Capacitaciones(CapacitacionID),
    CONSTRAINT CK_EmpleadoCap_Estado
        CHECK (Estado IN ('Completada','En Curso')),
    CONSTRAINT CK_EmpleadoCap_Calificacion
        CHECK (CalificacionObtenida IS NULL OR CalificacionObtenida BETWEEN 0 AND 100),
    CONSTRAINT UQ_EmpleadoCap UNIQUE (EmpleadoID, CapacitacionID)
) ;

/* =========================================================
   ÍNDICES
   ========================================================= */

CREATE INDEX IX_Empleados_DepartamentoID ON Empleados(DepartamentoID);
CREATE INDEX IX_Empleados_PuestoID ON Empleados(PuestoID);
CREATE INDEX IX_Empleados_OficinaID ON Empleados(OficinaID);
CREATE INDEX IX_Empleados_JefeID ON Empleados(JefeID);

CREATE INDEX IX_Ausencias_EmpleadoID_FechaInicio ON Ausencias(EmpleadoID, FechaInicio);
CREATE INDEX IX_Evaluaciones_EmpleadoEvaluadoID_FechaEvaluacion ON EvaluacionesDesempeno(EmpleadoEvaluadoID, FechaEvaluacion);
CREATE INDEX IX_EmpleadoCap_EmpleadoID ON EmpleadosCapacitaciones(EmpleadoID);