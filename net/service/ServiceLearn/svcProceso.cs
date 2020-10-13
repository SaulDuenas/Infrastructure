
//Librerías por default
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.ServiceProcess;
using System.Text;
using System.IO;

//Librerías de la plantilla  de servicios TSR
using System.Timers;
using System.Resources;
using System.Threading;

//Librerías del servicio específico
//using System.Drawing;
//using System.Windows.Forms;

using Teseracto.Data;
using Teseracto.IniFiles;
using Teseracto.Log;


namespace MyService
{
   public partial class svcMain : ServiceBase
   {
      #region "Variables Privadas"
         private TSR_DB dbSQL;  //Base de datos principal
         private Int32 count;
         private string sArchivo = ""; //Ruta y Nombre del Archivo.
         private string sFecha = "";  //Fecha Actual.
         private string sFileName = ""; //Soló nombre del archivo.
         private string sPathFile = "";   //Ruta del archivo.
         private bool bExiste;  //Existe el Archivo.
      #endregion
      
      private bool ConectarSEY()
         {
            bool lOK;

            /* 1. Se conecta a la base de datos primaria */
            //Estblecer conexiones.
            oLogFile.Reporta(Nivel.DBG, "[101]", oMsg.GetString("Msg_101"));
            dbSQL = new TSR_DB(DB_SRV, DB_DB, DB_UID, DB_PWD);
     
            //Conectarse con la base de datos.
            watchDogCounter = 0;
            lOK = dbSQL.DBConectar();
            
            if (lOK)
               oLogFile.Reporta(Nivel.DBG, "[102]", oMsg.GetString("Msg_102")); //Conexión exitosa con la base de datos primaria
            else
               oLogFile.Reporta(Nivel.WRN, "[103]", String.Format(oMsg.GetString("Msg_103"), dbSQL.sError)); //No se pudo conectar a la base de datos primaria: {0}
         
            //Regresa
            watchDogCounter = 0;
            return lOK;
         }

         private void DesconectarSEY()
         {
            // Cierra conexiones a las DB
            oLogFile.Reporta(Nivel.DBG, "[115]", oMsg.GetString("Msg_115")); //Cerrando conexión primaria
            dbSQL.DBDesconectar();
            dbSQL = null;
         }


      private void Inicia()
      {
         System.Reflection.Assembly InfoFile;  //Información de la aplicación.

         // Detengo momentaneamente los timers
         oWatchDog.Enabled = false;
         oReloj.Enabled = false; 
         
         oLogFile.Reporta(Nivel.INF, "[007]", "Este código se ejecuta en el OnStart del servicio");
         // Inicializo mi archivo de escritura
         // creo el archivo donde mi servicio estara escribiendo
         // [1] Obtener Información del Archivo.
         InfoFile = System.Reflection.Assembly.GetExecutingAssembly();

         //[2]Establecer Nombre del Archivo.
         SetFile(Path.GetDirectoryName(InfoFile.Location), Path.GetFileNameWithoutExtension(InfoFile.Location));
         // Habilitamos los timers del servicio
         oWatchDog.Enabled = bIniciando;
         oReloj.Enabled = bIniciando;

      }

      private void Procesa()
      {
         bool SiConectaSEY;
         string lQry;
         object Nombre="";
        
         SiConectaSEY = ConectarSEY();

         if (SiConectaSEY)
         {
            // Generamos consulta SQL
            lQry = "SELECT TOP (1) Celda FROM SEY_Celdas ORDER BY Celda ASC";

            Nombre = dbSQL.DBQryDato(lQry);
            watchDogCounter = 0;

            if (Nombre != null)
            {
               Reporta("Resultado consulta SQL: " +
                       "\nNombre: " + Nombre.ToString());

            }
            else
            {
               // ocurrio un error en la consulta 
               oLogFile.Reporta(Nivel.INF, "[104]", String.Format(oMsg.GetString("Msg_104"), dbSQL.sError));
            }

            //oLogFile.Reporta(Nivel.INF, "[777]", "Este es el proceso principal, se ejecuta cada Timer");

            watchDogCounter = 0;
         }
         //Añadir esta línea dentro de algún ciclo, para indicar al
         //WatchDog que el proceso sigue ejecutandose sin problemas

         DesconectarSEY();
         watchDogCounter = 0;

         //oLogFile.Reporta(Nivel.INF, "[777]", "Este es el proceso principal, se ejecuta cada Timer");
         //count++;
         //Reporta("Mi mensaje N." + Convert.ToString(count) + " desde el servicio");
         //watchDogCounter = 0;

      }
      
      /// <summary>
      /// Terminar cualquier cosa que se deba terminar al momento de detener el servicio
      /// </summary>
      private void Termina()
      {
         oLogFile.Reporta(Nivel.INF, "[???]", "Este código se ejecuta en el OnStop del servicio");
      }


      //----------------------------------------------------------------------------
      //    Nombre: SetFile.

      //     Fecha: 17/Sep/2007.
      //----------------------------------------------------------------------------
      private void SetFile(string psPathFile, string psFileName)
      {
         DateTime ldFecha = DateTime.Today;
         string lsFecha = "";  //Fecha en Texto.

         //[1]Establecer Fecha y recordar valores.
         sFecha = lsFecha = ldFecha.ToString("yyMMdd");
         sPathFile = psPathFile;
         sFileName = psFileName;

         //[2]Verificar existencia del directorio Logs, sí no existe crearlo.
         if (Directory.Exists(psPathFile + "\\MyService") == false)
            Directory.CreateDirectory(psPathFile + "\\MyService");

         //[3]Establecer nombre del Archivo.
         sArchivo = psPathFile + "\\MyService\\" + psFileName + "_" + lsFecha + ".txt";

      }


      //----------------------------------------------------------------------------
      //    Nombre: Reporta.
      //  Objetivo: Establece el mensaje especifico en el archivo Log.
      // Parámtros: 

      //     Fecha: 17/Sep/2007.
      //----------------------------------------------------------------------------
      private void Reporta(string psMensaje)
      {
         string lsMensaje = "";  //Mensaje a escribir en el archivo Log.
         Stream lStream;
         StreamWriter loFile = null;   //Objeto de control del Archivo Log. (Nuevo)

                   //[2]Valida Archivo.
            if (sArchivo == "")
            {
               //Reportar error en log
             
            }
            else
            {
               try
               {
                  //[3]Armar mensaje.
                  lsMensaje = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff") + "\t" + psMensaje.Trim();

                  //[A.1]Establecer Archivo Log Nuevo.
                  if (sFecha != DateTime.Today.ToString("yyMMdd")) SetFile(sPathFile, sFileName);
                  lStream = File.Open(sArchivo, FileMode.Append, FileAccess.Write, FileShare.ReadWrite);
                  loFile = new StreamWriter(lStream);

                  //[A.2]Esteblecer mensaje en el archivo.
                  loFile.WriteLine(lsMensaje);

                  //[A.3]Cerrar Archivo.
                  loFile.Flush();
                  lStream.Flush();
                  loFile.Close();
                  lStream.Close();

                  //[A.4]Actualizar existencia de archivo.
                  bExiste = true;


               }
               catch (Exception loErr)
               {
                  //Reportar error en el event viewer.
               }
            }
         }
      }
   }
