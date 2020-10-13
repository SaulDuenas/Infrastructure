
/*****
   OJO: Remplazar 'DBName' con el nombre de la base de datos
******/

--Borrar el archivo Log de SQL
BACKUP LOG DBName WITH NO_LOG
--Reducir Base de datos
DBCC SHRINKDATABASE (DBName,1)
-- Hacerlo de nuevo
BACKUP LOG DBName WITH NO_LOG
DBCC SHRINKDATABASE (DBName,1)

-- Regenerar índices (opcional)
-- EXEC master.dbo.xp_sqlmaint '-D DBName -WriteHistory  -RebldIdx 10 -RmUnusedSpace 50 10 -Rpt C:\SQL_Maint.rpt'

