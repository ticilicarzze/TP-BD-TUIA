USE gestion_arbolado

-- 5.a

GO
CREATE or ALTER VIEW VistaReclamo as
SELECT
    r.id,
    r.fecha,
    r.id_arbol,
    DATEDIFF(DAY, r.fecha, COALESCE(r.fecha_asignacion, GETDATE())) AS dias_asignacion,
    DATEDIFF(DAY, r.fecha,  COALESCE(t.fecha_ejecucion, GETDATE())) AS dias_resolucion
FROM Reclamo r
LEFT JOIN Tarea t ON t.id = r.id_tarea;
GO

SELECT * FROM VistaReclamo ORDER BY dias_resolucion DESC;

SELECT * FROM VistaReclamo WHERE dias_asignacion > 7;

-- 5.b

GO
CREATE or ALTER VIEW ResumenTareas AS
SELECT 
    tt.descripcion AS tipo_tarea,
    MIN(t.fecha_ejecucion) AS fecha_primer_tarea,
    MAX(t.fecha_ejecucion) AS fecha_ultima_tarea,
    COUNT(t.id) AS cantidad
FROM Tarea AS t
JOIN Tipo_Tarea AS tt ON t.id_tipo = tt.id_tipo
GROUP BY tt.descripcion;
GO

SELECT TOP(10) * FROM ResumenTareas ORDER BY cantidad DESC;

SELECT * FROM ResumenTareas WHERE cantidad > 5;
