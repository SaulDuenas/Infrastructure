/****** Object:  LinkedServer [SAPSERVER]    Script Date: 11/29/2011 13:54:40 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'SAPSERVER'
                                  ,@srvproduct=N'sql_server'
                                  ,@provider=N'SQLNCLI'
                                  ,@datasrc=N'teseracto.dyndns.biz'   -- 

/* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SAPSERVER'
                                    ,@useself=N'False'
                                    ,@locallogin=NULL
                                    ,@rmtuser=N'SAPUser'
                                    ,@rmtpassword='########'

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SAPSERVER'
                                    ,@useself=N'False'
                                    ,@locallogin=N'sa'
                                    ,@rmtuser=N'SAPUser'
                                    ,@rmtpassword='########'

GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'SAPSERVER', @optname=N'use remote collation', @optvalue=N'true'