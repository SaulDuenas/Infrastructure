

--Para Restaurar una Base de Datos cuando se encuentra en Estado Sospechoso

EXEC sp_resetstatus 'yourDBname';
ALTER DATABASE yourDBname SET EMERGENCY
DBCC checkdb('yourDBname')
ALTER DATABASE yourDBname SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DBCC CheckDB ('yourDBname', REPAIR_ALLOW_DATA_LOSS)
ALTER DATABASE yourDBname SET MULTI_USER

