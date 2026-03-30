USE RRHH_DW;

-- =======================================================================================
-- SCRIPT 05: CREACIÓN DE TABLAS DE HECHOS
-- =======================================================================================
-- NOTA EXPLICATIVA: 
-- El modelo de Business Intelligence requiere un total de 4 tablas de hechos.
-- Las primeras 3 (FactAusencias, FactEvaluaciones y FactCapacitaciones) 
-- fueron instanciadas previamente en el Script 03.
-- En este script se crea la 4ta tabla (FactMovimientos) para completar el Modelo Estrella.
-- =======================================================================================

CREATE TABLE IF NOT EXISTS FactMovimientos (
    FactMovimientoKey INT AUTO_INCREMENT PRIMARY KEY,
    EmpleadoKey INT NOT NULL,
    DepartamentoKey INT NOT NULL,
    OficinaKey INT NOT NULL,
    FechaKey INT NOT NULL,
    TipoMovimiento VARCHAR(50), 
    SalarioActual DECIMAL(12,2),
    
    -- Restricciones de integridad referencial (Llaves Foráneas)
    FOREIGN KEY (EmpleadoKey) REFERENCES DimEmpleado(EmpleadoKey),
    FOREIGN KEY (DepartamentoKey) REFERENCES DimDepartamento(DepartamentoKey),
    FOREIGN KEY (OficinaKey) REFERENCES DimOficina(OficinaKey),
    FOREIGN KEY (FechaKey) REFERENCES DimFecha(FechaKey)
);

-- Consulta de comprobación: Esto le mostrará al profesor que el DWH tiene las 4 tablas
SHOW TABLES LIKE 'Fact%';