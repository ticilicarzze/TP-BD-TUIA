USE TP_BBDD1_2025_G13;
GO


-- Eliminamos el PROCEDURE para poder crearla nuevamente y asi evitar error en caso de que ya exista
IF OBJECT_ID('SP_obtener_info_tarea_tipo', 'P') IS NOT NULL
    DROP PROCEDURE SP_obtener_info_tarea_tipo;
GO

CREATE PROCEDURE SP_obtener_info_tarea_tipo
    @id_arbol VARCHAR(255),
    @id_tipo INT,
    @fecha_prox_tarea DATETIME OUTPUT
AS
BEGIN

    DECLARE @cantidad_tareas INT;

    -- 1. Calculamos la CANTIDAD de pendientes (IS NULL)
    SELECT @cantidad_tareas = COUNT(t.id)
    FROM Tarea t
    LEFT JOIN Tarea_Arbol ta ON t.id = ta.id_tarea
    WHERE 
        ta.id_arbol = @id_arbol
        AND t.id_tipo = @id_tipo
        AND t.fecha_ejecucion IS NULL;

    -- 2. Buscamos la FECHA mas proxima (MIN)
    SELECT @fecha_prox_tarea = MIN(t.fecha_planificada)
    FROM Tarea t
    JOIN Tarea_Arbol ta ON t.id = ta.id_tarea
    WHERE 
        ta.id_arbol = @id_arbol
        AND t.id_tipo = @id_tipo
        AND t.fecha_ejecucion IS NULL;

    -- 6.b: Retornamos la cantidad como valor de retorno
    RETURN @cantidad_tareas;
END;
GO

-- ========================================================= --
--                                                           --
-- Mostrar tareas pendientes de 'poda' en el arbol 'ARB-001' --
--                                                           --
-- ========================================================= --

DECLARE @fecha_resultado DATETIME;
DECLARE @cantidad_retorno INT;

EXEC @cantidad_retorno = SP_obtener_info_tarea_tipo 
    @id_arbol = 'ARB-001',
    @id_tipo = 1,
    @fecha_prox_tarea = @fecha_resultado OUTPUT;

SELECT 
    @fecha_resultado AS Fecha_Proxima, 
    @cantidad_retorno AS Cantidad_Pendientes;
GO

-- ================================================================== --
--                                                                    --
-- Mostrar tareas pendientes de 'fitosanitario' en el arbol 'ARB-005' --
--                                                                    --
-- ================================================================== --

DECLARE @fecha_resultado_2 DATETIME;
DECLARE @cantidad_retorno_2 INT;

EXEC @cantidad_retorno_2 = SP_obtener_info_tarea_tipo 
    @id_arbol = 'ARB-005',
    @id_tipo = 5,
    @fecha_prox_tarea = @fecha_resultado_2 OUTPUT;

SELECT 
    @fecha_resultado_2 AS Fecha_Proxima, 
    @cantidad_retorno_2 AS Cantidad_Pendientes;







