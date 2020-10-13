using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Diagnostics;

/***************************************************************************
 *       Clase: TSR-LOG.                                                   *
 * Descripción: Permite establecer las funciones básicas para el manejo de *
 *              archivos Logs.                                             *
 *      Autor: Ing. Israel Hinojosa Sánchez.                               *
 *       Fecha: 17/Sep/2007.                                               *
 *     Versión: 1.0.0                                                      *
 ***************************************************************************/

namespace Teseracto.Log
{
   public enum Nivel
   {
      ERR=0,
      WRN=1,
      INF=2,
      DBG=3
   }
   public class TSR_LOG
   {
      //Constantes.
      //--Públicas.
      public const int LOG_ERR = 0;  //Log de tipo: Error.
      public const int LOG_WRN = 1;  //Log de tipo: Advertencia.
      public const int LOG_INF = 2;  //Log de tipo: Informativo.
      public const int LOG_DBG = 3;  //Log de Tipo: Depuración.
      public Nivel nDetLog = Nivel.INF; //Nivel de detalle del Log (Default INF).
      //Propiedades.
      //--Privadas.
      private string sArchivo = ""; //Ruta y Nombre del Archivo.
      private string sFecha = "";  //Fecha Actual del Log.
      private string sFileName = ""; //Soló nombre del archivo.
      private string sPathFile = "";   //Ruta del archivo.
      private bool bExiste;  //Existe el Archivo.
      private bool bUsarEventViewer; //Escribir en el Event Viewer de Windows (True = Sí, False = No)
      private string sEvtAppName; //Llave en el Event Viewer.
      private string sEvtFolderName; //Nombre en el Event Viewer.
      private bool bHabilitaDBG; //Llave que habilita la escritura de mensajes debug en el EventViewer.
      private string[] sValoresLog = { "ERR", "WRN", "INF", "DBG" }; //Valores que toma el mensaje a reportar.
      private int nTiempo; //Tiempo de Depuración.
      private System.Reflection.Assembly Info;
      //Métodos.
      //--Publicos.
      //----------------------------------------------------------------------------
      //    Nombre: Constructor (Sin parámetros).
      //  Objetivo: Inicializar la clase, estableciendo el archivo Log con el nombre
      //            de la aplicación que lo manda a llamar, fecha y hora actual.
      //    Autor: Ing. Israel Hinojosa Sánchez.
      //     Fecha: 17/Sep/2007.
      //----------------------------------------------------------------------------
      /// <summary>
      /// Permite registrar mensajes en un archivo Log únicamente
      /// </summary>
      public TSR_LOG()
      {
         System.Reflection.Assembly InfoFile;  //Información de la aplicación.

         //[1]Obtener Información del Ejecutable.
         InfoFile = System.Reflection.Assembly.GetExecutingAssembly();

         //[2]Establecer Nombre del Archivo.
         SetLogFile(Path.GetDirectoryName(InfoFile.Location), Path.GetFileNameWithoutExtension(InfoFile.Location));

         //[3]Desctivar uso de Event Viewer.
         bUsarEventViewer = false;
         sEvtAppName = "";
         sEvtFolderName = "";


         //[4]Tiempo de Depuración Default (7 Días)
         nTiempo = 7;
      }

      //----------------------------------------------------------------------------
      //    Nombre: Constructor (Con parámetros).
      //  Objetivo: Inicializar la clase, estableciendo el archivo Log con el nombre
      //            de la aplicación que lo manda a llamar, fecha y hora actual.
      //Parámetros:
      //            -Entrada-
      //                pbEventView: Habilita el uso del Event Viewer.
      //                psKeyEventView: Llave unica del Event Viewer.
      //                psNomKeyEventView: Nombre con la que se mostrara el registro
      //                                   en windows.
      //                pnTiempo: Tiempo de Depuración.
      //    Autor: Ing. Israel Hinojosa Sánchez.
      //     Fecha: 17/Dic/2008.
      //----------------------------------------------------------------------------
      /// <summary>
      /// Permite registrar mensajes en un archivo Log y adicionalmente en el registro
      /// de eventos del sistema (EventViewer)
      /// </summary>
      /// <param name="pbHabilitaDBG">Indica si debe registrar enventos tipo debug en el EventViewer (Se recomienda false)</param>
      /// <param name="psEvtAppName">Nombre de la aplicación como se registrará en el EventViewer</param>
      /// <param name="psEvtFolderName">Nombre del Folder dentro del EventViewer. 
      /// Puede ser: Application, System o cualquier otro nombre
      /// </param>
      public TSR_LOG(bool pbHabilitaDBG, string psEvtAppName, string psEvtFolderName, int pnTiempo)
      {
         System.Reflection.Assembly InfoFile;  //Información de la aplicación.

         //[1]Obtener Información del Archivo.
         InfoFile = System.Reflection.Assembly.GetExecutingAssembly();

         //[2]Establecer Nombre del Archivo.
         SetLogFile(Path.GetDirectoryName(InfoFile.Location), Path.GetFileNameWithoutExtension(InfoFile.Location));

         //[3]Inicializar propiedades del Event Viewer.
         bUsarEventViewer = true;
         bHabilitaDBG = pbHabilitaDBG;
         sEvtAppName = psEvtAppName;
         sEvtFolderName = psEvtFolderName;
         nTiempo = pnTiempo;
      }


      //----------------------------------------------------------------------------
      //    Nombre: SetLogFile.
      //  Objetivo: Establece el nombre del archivo Log con fecha actual.
      // Parámtros: 
      //            -Entrada-
      //               psPathFile: Ruta del Archivo.
      //               psFileName: Nombre del Archivo Log.
      //    Autor: Ing. Israel Hinojosa Sánchez.
      //     Fecha: 17/Sep/2007.
      //----------------------------------------------------------------------------
      public void SetLogFile(string psPathFile, string psFileName)
      {
         DateTime ldFecha = DateTime.Today;
         string lsFecha = "";  //Fecha en Texto.

         //[1]Establecer Fecha y recordar valores.
         sFecha = lsFecha = ldFecha.ToString("yyMMdd");
         sPathFile = psPathFile;
         sFileName = psFileName;

         //[2]Verificar existencia del directorio Logs, sí no existe crearlo.
         if (Directory.Exists(psPathFile + "\\Logs") == false)
            Directory.CreateDirectory(psPathFile + "\\Logs");

         //[3]Establecer nombre del Archivo.
         sArchivo = psPathFile + "\\Logs\\" + psFileName + "_" + lsFecha + ".log";

         //[4]Especificar Existencia del Archivo.
         bExiste = File.Exists(sArchivo);

         //[5]Depura Logs.
         DepurarLogs(psPathFile + "\\Logs", psFileName, nTiempo);
      }

      //----------------------------------------------------------------------------
      //    Nombre: Reporta.
      //  Objetivo: Establece el mensaje especifico en el archivo Log.
      // Parámtros: 
      //            -Entrada-
      //               psCodigo: Código de Error.
      //              psMensaje: Mensaje de Error.
      //    Autor: Ing. Israel Hinojosa Sánchez.
      //     Fecha: 17/Sep/2007.
      //----------------------------------------------------------------------------
      public void Reporta(Nivel pNivel, string psCode, string psMensaje)
      {
         string lsMensaje = "";  //Mensaje a escribir en el archivo Log.
         Stream lStream;
         StreamWriter loLogFile = null;   //Objeto de control del Archivo Log. (Nuevo)

         if (pNivel <= nDetLog)  //Valida el nivel de detalle a reportar.
         {
            //[1]Inicializa objetos de validación 
            if (bUsarEventViewer)
            {
               if (!EventLog.SourceExists(sEvtAppName))
                  EventLog.CreateEventSource(sEvtAppName, sEvtFolderName);
            }

            //[2]Valida Archivo.
            if (sArchivo == "")
            {
               //Reportar error en el event viewer.
               if (bUsarEventViewer)
                  EventLog.WriteEntry(sEvtAppName, "El archivo LOG no existe.", EventLogEntryType.Error);
            }
            else
            {
               try
               {
                  //[3]Armar mensaje.
                  lsMensaje = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff") + "\t" + sValoresLog[(int)pNivel] + "\t" + psCode.Trim() + "\t" + psMensaje.Trim();

                  //[A.1]Establecer Archivo Log Nuevo.
                  if (sFecha != DateTime.Today.ToString("yyMMdd")) SetLogFile(sPathFile, sFileName);
                  lStream=File.Open(sArchivo, FileMode.Append, FileAccess.Write, FileShare.ReadWrite);
                  loLogFile = new StreamWriter(lStream);

                  //[A.2]Esteblecer mensaje en el archivo.
                  loLogFile.WriteLine(lsMensaje);

                  //[A.3]Cerrar Archivo.
                  loLogFile.Flush();
                  lStream.Flush();
                  loLogFile.Close();
                  lStream.Close();

                  //[A.4]Actualizar existencia de archivo.
                  bExiste = true;

                  //[A.5]Reportar en el EventViewer.

                  try
                  {

                     switch (pNivel)
                     {
                        case Nivel.ERR:  //Tipo Error.
                           EventLog.WriteEntry(sEvtAppName, psMensaje, EventLogEntryType.Error);
                           break;
                        case Nivel.WRN:
                           EventLog.WriteEntry(sEvtAppName, psMensaje, EventLogEntryType.Warning);
                           break;
                        case Nivel.INF:  //Tipo Informativo.
                           EventLog.WriteEntry(sEvtAppName, psMensaje, EventLogEntryType.Information);
                           break;
                        case Nivel.DBG:  //Tipo Debug.
                           if (bHabilitaDBG)
                              EventLog.WriteEntry(sEvtAppName, psMensaje, EventLogEntryType.SuccessAudit);
                           break;
                     }
                  }
                  catch 
                  {
                     //Es posible que este lleno y se sobreescribira
                     try
                     {
                        EventLog.Delete(sEvtFolderName);
                        if (!EventLog.SourceExists(sEvtAppName))
                           EventLog.CreateEventSource(sEvtAppName, sEvtFolderName);

                     }
                     catch
                     {

                     }
                  }

               }
               catch (Exception loErr)
               {
                  //Reportar error en el event viewer.
                  if (bUsarEventViewer)
                     EventLog.WriteEntry(sEvtAppName, "Error en el archivo Log: " + loErr.Message + "    Mensaje original:" + lsMensaje, EventLogEntryType.Error);
                  if (loLogFile!=null) loLogFile.Close();
               }
            }
         }
      }

      //----------------------------------------------------------------------------
      //    Nombre: DepuraLog.
      //  Objetivo: Borra los archivos de Tipo Log que no son necesarios.
      // Parámtros: 
      //            -Entrada-
      //               psRuta: Ruta del directorio Log.
      //                psNom: Nombre de la aplicación.
      //             pnTiempo: Tiempo de Depuración en Días.
      //    Autor: Ing. Israel Hinojosa Sánchez.
      //     Fecha: 05/Ene/20078.
      //----------------------------------------------------------------------------
      private void DepurarLogs(string psRuta, string psNom, int pnTiempo)
      {
         string lsDir = "";     //Directorio.
         string lsArcDep = "";  //Archivo de Depuración.

         //[1]Ensamblar Ruta.
         lsDir = psRuta + "\\";

         //[2]Establecer archivo de depuración.
         if (pnTiempo < 2) pnTiempo = 2;
         lsArcDep = lsDir + psNom + "_" + DateTime.Today.AddDays(-1 * (pnTiempo-1)).ToString("yyMMdd");

         //[3]Procesar directorio.
         try
         {
            foreach (string lsArchivo in Directory.GetFiles(lsDir, psNom + "*.log"))
            {
               pnTiempo = lsArchivo.CompareTo(lsArcDep);
               if (lsArchivo.CompareTo(lsArcDep) <=0)
               {
                  try
                  {
                     File.Delete(lsArchivo);
                  }
                  catch (Exception loError)
                  {
                     System.Diagnostics.EventLog log = new System.Diagnostics.EventLog("Application", ".", Info.GetName().ToString());
                     log.WriteEntry(loError.Message, System.Diagnostics.EventLogEntryType.Warning, 123);
                  }
               }
            }
         }
         catch (Exception loError)
         {
            System.Diagnostics.EventLog log2 = new System.Diagnostics.EventLog("Application", ".", Info.GetName().ToString());
            log2.WriteEntry(loError.Message, System.Diagnostics.EventLogEntryType.Warning, 123);
         }
      }

   }
}
