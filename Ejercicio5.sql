-- 5.a
CREATE VIEW VistaReclamo AS
SELECT
    r.id,
    r.fecha,
    r.id_arbol,
    DATEDIFF(COALESCE(r.fecha_asignacion, NOW()), r.fecha) AS dias_asignacion,
    DATEDIFF(COALESCE(t.fecha_ejecucion, NOW()), r.fecha) AS dias_resolucion
FROM Reclamo r
LEFT JOIN Tarea t ON t.id = r.id_tarea;

SELECT * FROM VistaReclamo ORDER BY dias_resolucion DESC;

SELECT * FROM VistaReclamo WHERE dias_asignacion > 7;

-- 5.b
CREATE VIEW ResumenTareas AS
SELECT 
    tt.descripcion AS tipo_tarea,
    MIN(t.fecha_ejecucion) AS fecha_primer_tarea,
    MAX(t.fecha_ejecucion) AS fecha_ultima_tarea,
    COUNT(t.id) AS cantidad
FROM Tarea t
JOIN Tipo_Tarea tt ON t.id_tipo = tt.id
GROUP BY tt.descripcion;

SELECT * FROM ResumenTareas ORDER BY cantidad DESC LIMIT 10;

SELECT * FROM ResumenTareas WHERE cantidad > 5;
