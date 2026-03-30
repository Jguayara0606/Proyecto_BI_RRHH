/* =========================================================
   03_DW_RRHH_mysql.sql
   Data Warehouse RRHH_DW
   ========================================================= */

DROP DATABASE IF EXISTS RRHH_DW;
CREATE DATABASE RRHH_DW ;
USE RRHH_DW;

/* =========================================================
   DIMENSIONES
   ========================================================= */

CREATE TABLE DimFecha (
    FechaKey          INT PRIMARY KEY,
    FechaCompleta     DATE NOT NULL,
    Anio              INT NOT NULL,
    Semestre          INT NOT NULL,
    Trimestre         INT NOT NULL,
    Mes               INT NOT NULL,
    NombreMes         VARCHAR(20) NOT NULL,
    Dia               INT NOT NULL,
    NombreDiaSemana   VARCHAR(20) NOT NULL
);

CREATE TABLE DimOficina (
    OficinaKey        INT AUTO_INCREMENT PRIMARY KEY,
    OficinaID_OLTP    INT NOT NULL,
    CodigoOficina     VARCHAR(20) NOT NULL,
    Ciudad            VARCHAR(100) NOT NULL,
    Pais              VARCHAR(100) NOT NULL,
    Region            VARCHAR(100) NOT NULL,
    CodigoPostal      VARCHAR(20) NULL
);

CREATE TABLE DimDepartamento (
    DepartamentoKey       INT AUTO_INCREMENT PRIMARY KEY,
    DepartamentoID_OLTP   INT NOT NULL,
    NombreDepartamento    VARCHAR(100) NOT NULL,
    Descripcion           VARCHAR(250) NULL
) ENGINE=InnoDB;

CREATE TABLE DimPuesto (
    PuestoKey          INT AUTO_INCREMENT PRIMARY KEY,
    PuestoID_OLTP      INT NOT NULL,
    NombrePuesto       VARCHAR(120) NOT NULL,
    NivelSalarial      VARCHAR(20) NOT NULL,
    SalarioMinimo      DECIMAL(12,2) NOT NULL,
    SalarioMaximo      DECIMAL(12,2) NOT NULL
);

CREATE TABLE DimEmpleado (
    EmpleadoKey           INT AUTO_INCREMENT PRIMARY KEY,
    EmpleadoID_OLTP       INT NOT NULL,
    Identificacion        VARCHAR(30) NOT NULL,
    NombreCompleto        VARCHAR(220) NOT NULL,
    Genero                VARCHAR(20) NOT NULL,
    EstadoCivil           VARCHAR(30) NOT NULL,
    Edad                  INT NOT NULL,
    FechaContratacion     DATE NOT NULL,
    AntiguedadAnios       INT NOT NULL,
    Activo                TINYINT(1) NOT NULL,
    DepartamentoID_OLTP   INT NOT NULL,
    PuestoID_OLTP         INT NOT NULL,
    OficinaID_OLTP        INT NOT NULL,
    JefeID_OLTP           INT NULL
);

CREATE TABLE DimTipoAusencia (
    TipoAusenciaKey    INT AUTO_INCREMENT PRIMARY KEY,
    TipoAusencia       VARCHAR(30) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE DimCapacitacion (
    CapacitacionKey      INT AUTO_INCREMENT PRIMARY KEY,
    CapacitacionID_OLTP  INT NOT NULL,
    NombreCapacitacion   VARCHAR(150) NOT NULL,
    Proveedor            VARCHAR(150) NOT NULL,
    Costo                DECIMAL(12,2) NOT NULL,
    DuracionDias         INT NOT NULL
);

/* =========================================================
   HECHOS
   ========================================================= */

CREATE TABLE FactAusencias (
    FactAusenciaKey    BIGINT AUTO_INCREMENT PRIMARY KEY,
    FechaKey           INT NOT NULL,
    EmpleadoKey        INT NOT NULL,
    OficinaKey         INT NOT NULL,
    DepartamentoKey    INT NOT NULL,
    TipoAusenciaKey    INT NOT NULL,
    CantidadAusencias  INT NOT NULL,
    DiasAusencia       INT NOT NULL,
    JustificadaFlag    TINYINT(1) NOT NULL,
    FOREIGN KEY (FechaKey) REFERENCES DimFecha(FechaKey),
    FOREIGN KEY (EmpleadoKey) REFERENCES DimEmpleado(EmpleadoKey),
    FOREIGN KEY (OficinaKey) REFERENCES DimOficina(OficinaKey),
    FOREIGN KEY (DepartamentoKey) REFERENCES DimDepartamento(DepartamentoKey),
    FOREIGN KEY (TipoAusenciaKey) REFERENCES DimTipoAusencia(TipoAusenciaKey)
);

CREATE TABLE FactEvaluaciones (
    FactEvaluacionKey      BIGINT AUTO_INCREMENT PRIMARY KEY,
    FechaKey               INT NOT NULL,
    EmpleadoKey            INT NOT NULL,
    EvaluadorEmpleadoKey   INT NOT NULL,
    OficinaKey             INT NOT NULL,
    DepartamentoKey        INT NOT NULL,
    PuestoKey              INT NOT NULL,
    Calificacion           DECIMAL(3,1) NOT NULL,
    CantidadEvaluaciones   INT NOT NULL,
    FOREIGN KEY (FechaKey) REFERENCES DimFecha(FechaKey),
    FOREIGN KEY (EmpleadoKey) REFERENCES DimEmpleado(EmpleadoKey),
    FOREIGN KEY (EvaluadorEmpleadoKey) REFERENCES DimEmpleado(EmpleadoKey),
    FOREIGN KEY (OficinaKey) REFERENCES DimOficina(OficinaKey),
    FOREIGN KEY (DepartamentoKey) REFERENCES DimDepartamento(DepartamentoKey),
    FOREIGN KEY (PuestoKey) REFERENCES DimPuesto(PuestoKey)
);

CREATE TABLE FactCapacitaciones (
    FactCapacitacionKey    BIGINT AUTO_INCREMENT PRIMARY KEY,
    FechaKey               INT NOT NULL,
    EmpleadoKey            INT NOT NULL,
    CapacitacionKey        INT NOT NULL,
    OficinaKey             INT NOT NULL,
    DepartamentoKey        INT NOT NULL,
    PuestoKey              INT NOT NULL,
    Estado                 VARCHAR(20) NOT NULL,
    CalificacionObtenida   DECIMAL(5,2) NULL,
    CantidadAsignaciones   INT NOT NULL,
    CostoCapacitacion      DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (FechaKey) REFERENCES DimFecha(FechaKey),
    FOREIGN KEY (EmpleadoKey) REFERENCES DimEmpleado(EmpleadoKey),
    FOREIGN KEY (CapacitacionKey) REFERENCES DimCapacitacion(CapacitacionKey),
    FOREIGN KEY (OficinaKey) REFERENCES DimOficina(OficinaKey),
    FOREIGN KEY (DepartamentoKey) REFERENCES DimDepartamento(DepartamentoKey),
    FOREIGN KEY (PuestoKey) REFERENCES DimPuesto(PuestoKey)
);

CREATE INDEX IX_FactAusencias_FechaKey ON FactAusencias(FechaKey);
CREATE INDEX IX_FactEvaluaciones_FechaKey ON FactEvaluaciones(FechaKey);
CREATE INDEX IX_FactCapacitaciones_FechaKey ON FactCapacitaciones(FechaKey);