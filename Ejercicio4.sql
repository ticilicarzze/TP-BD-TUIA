USE TP_BBDD1_2025_G13;
GO

-- ==============================================================================
-- 4.a. Mostrar la cuadrilla que más tareas realizó en Octubre de 2025
-- y la cantidad de tareas.
-- ==============================================================================
SELECT TOP 1 
    C.id_cuadrilla AS Id_Cuadrilla, 
    C.nombre AS Nombre_Cuadrilla,
    COUNT(T.id) AS Cantidad_Tareas
FROM Tarea T
JOIN Cuadrilla C ON T.id_cuadrilla = C.id_cuadrilla
WHERE YEAR(T.fecha_planificada) = 2025 
  AND MONTH(T.fecha_planificada) = 10
GROUP BY C.id_cuadrilla, C.nombre
ORDER BY Cantidad_Tareas DESC;

-- ==============================================================================
-- 4.b. Mostrar los Motivos de Reclamos que tengan más de 3 reclamos en estado
-- no asignado (sin tarea).
-- ==============================================================================
SELECT 
    M.descripcion AS Motivo, 
    COUNT(R.id) AS Cantidad_Reclamos_Pendientes
FROM Reclamo R
JOIN Motivo_Reclamo M ON R.id_motivo = M.id_motivo
WHERE R.id_tarea IS NULL
GROUP BY M.descripcion
HAVING COUNT(R.id) > 3;

-- ==============================================================================
-- 4.c. Mostrar los Árboles (código, especie y ubicación) que no tengan ningún
-- reclamo.
-- ==============================================================================
SELECT 
    A.id AS Codigo_Arbol, 
    E.nombre_comun AS Especie, 
    A.ubicacion AS Ubicacion
FROM Arbol A
JOIN Especie E ON A.id_especie = E.id_especie
LEFT JOIN Reclamo R ON A.id = R.id_arbol
WHERE R.id IS NULL;

-- ==============================================================================
-- 4.d. Mostrar los tres árboles (código y altura) más altos de cada especie.
-- Ordenados por especie y luego altura decreciente.
-- ==============================================================================

SELECT 
    E.nombre_comun AS Especie,
    A.id AS Codigo_Arbol,
    A.altura AS Altura
FROM Arbol A
JOIN Especie E ON A.id_especie = E.id_especie
WHERE A.altura IS NOT NULL 
  AND (
      SELECT COUNT(*)
      FROM Arbol A2
      WHERE A2.id_especie = A.id_especie
        AND A2.altura > A.altura
  ) < 3
ORDER BY E.nombre_comun ASC, A.altura DESC;

GO
