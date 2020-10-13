if exists (select 1
            from  sysobjects
           where  id = object_id('Parametros')
            and   type = 'U')
   drop table Parametros
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Produccion')
            and   type = 'U')
   drop table Produccion
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Tags')
            and   type = 'U')
   drop table Tags
go

/*==============================================================*/
/* Table: Parametros                                            */
/*==============================================================*/
create table Parametros (
   Categoria            varchar(20)          not null,
   Parametro            varchar(50)          not null,
   sAux                 varchar(50)          null,
   nValor               float                null,
   sValor               varchar(100)         null,
   dValor               datetime             null,
   Descripcion          varchar(300)         not null,
   constraint PK_PARAMETROS primary key nonclustered (Categoria, Parametro)
)
go

/*==============================================================*/
/* Table: Produccion                                            */
/*==============================================================*/
create table Produccion (
   Folio                bigint               identity,
   NumBala              varchar(15)          not null,
   FechaHora            datetime             not null,
   MasaBruta            float                not null,
   MasaNeta             float                not null,
   CveEstadoBala        varchar(4)           not null,
   NumLinea             int                  not null,
   CveLote              varchar(4)           not null,
   CvePlantaOrigen      int                  not null,
   Enviado              int                  not null default 0,
   constraint PK_PRODUCCION primary key (Folio)
)
go

/*==============================================================*/
/* Table: Tags                                                  */
/*==============================================================*/
create table Tags (
   Nombre               varchar(50)          not null,
   Grupo                Varchar(30)          null,
   Topico               varchar(50)          not null,
   TagPath              varchar(100)         not null,
   nValor               float                null,
   sValor               varchar(80)          null,
   Descripcion          varchar(500)         null,
   constraint PK_TAGS primary key (Nombre)
)
go
