USE RRHH_DW;

-- =========================================================================
-- SCRIPT 06: GENERACIÓN Y POBLADO DE LA DIMENSIÓN TIEMPO (DimFecha)
-- =========================================================================

DELIMITER //

DROP PROCEDURE IF EXISTS Generar_Dim_Fecha //

CREATE PROCEDURE Generar_Dim_Fecha(IN fecha_inicio DATE, IN fecha_fin DATE)
BEGIN
    DECLARE fecha_actual DATE;
    SET fecha_actual = fecha_inicio;

    WHILE fecha_actual <= fecha_fin DO
        
        INSERT IGNORE INTO DimFecha (
            FechaKey,
            FechaCompleta,
            Anio,
            Semestre,
            Trimestre,
            Mes,
            NombreMes,
            Dia,
            NombreDiaSemana
        ) VALUES (
            CAST(DATE_FORMAT(fecha_actual, '%Y%m%d') AS UNSIGNED),
            fecha_actual,
            YEAR(fecha_actual),
            CASE WHEN MONTH(fecha_actual) <= 6 THEN 1 ELSE 2 END,
            QUARTER(fecha_actual),
            MONTH(fecha_actual),
            MONTHNAME(fecha_actual),
            DAY(fecha_actual),
            DAYNAME(fecha_actual)
        );
        
        SET fecha_actual = DATE_ADD(fecha_actual, INTERVAL 1 DAY);
        
    END WHILE;
END //

DELIMITER ;

-- Ejecución: Se llena la dimensión desde 2020 hasta el 2025
CALL Generar_Dim_Fecha('2020-01-01', '2025-12-31');