//#define USA_DB_SECUNDARIA
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


using Teseracto.Data;
using Teseracto.IniFiles;
using Teseracto.Log;


namespace MyService
{
   public partial class svcMain : ServiceBase
   {


      #region "Variables y Constantes de la plantilla de servicios TSR"

      /*Constantes*/
      private const long INTERVALO_WATCHDOG=15;  //segundos

      //Nombre del Servicio
      private System.Reflection.Assembly lAssembly;  //Assembly del servicio
      private string lServiceName="";   //Nombre del servicio (se obtiene a traves de reflection.assembly)              

      //Control de timers
      private Timer oReloj = null;      //Objeto controlador del periodo de tiempo.
      private Timer oWatchDog=null;     //Timer de watchdog
      private int watchDogCounter=0;    //Contador para el watchdog
      //Logs
      private ResourceManager oMsg = null;  //Objeto controlador de mensajes.
      private TSR_LOG oLogFile = null;  //Objeto controlador del archivo Log.
      private bool bReLeerINI = true;     //Leer INI.
      private bool bDeteniendo = false;  //Bandera de detención.
      private bool bIniciando = true;  //Bandera de Inicialización.
      private bool bProcesando = false;  //Bandera de proceso.

      private int nDetLog = 3;      //Nivel de detalle de Logs.


      #endregion

      #region "Variables y Constantes Configurables"
      private const int KEY = 18;       //Llave de Encriptación del Archivo INI

      //Nombre del Recurso de Mensajes
      private const string MENSAJES="MensajesLog"; //Nombre del ResourceFile donde estan los mensajes del log


      private string DB_SRV = "";  //Servidor de DB
      private string DB_DB = "";   //Base de datos 
      private string DB_UID = "";  //Usuario de base de datos 
      private string DB_PWD = "";  //Contraseña de base de datos

      //Conexión a DB (Secundaria)
#if USA_DB_SECUNDARIA         //Este define está hasta arriba del archivo
      private string DB2_SRV = "";  //Servidor de DB
      private string DB2_DB = "";   //Base de datos 
      private string DB2_UID = "";  //Usuario de base de datos 
      private string DB2_PWD = "";  //Contraseña de base de datos
#endif

      //Proceso
      private int nFrecuencia = 10;           //Frecuencia de activación del proceso.
      private const int UNIDAD_TIEMPO= 1000; //unidad de tiempo para la activación: 1000=segundos, 60,000=minutos 

      //Event Viewer
      private const bool bUsarEventViewer=true;              //Usar o no el EventViewer para registrar mensajes
      private const string sEventViewerFolder="MyService";   //Folder del EventViewer (Application,System u otro)

      #endregion
      
      /// <summary>
      /// Inicializa Variables básicas del servicio
      /// </summary>
      public svcMain()
      {
         //Inicializa variables básicas
         lAssembly=System.Reflection.Assembly.GetExecutingAssembly();
         lServiceName=lAssembly.GetName().Name;
         InitializeComponent();
      }

      protected override void OnStart(string[] args)
      {
         if (bUsarEventViewer)
         {
            oLogFile = new TSR_LOG(false, lServiceName, sEventViewerFolder, 7);
         }

         else
         {
            oLogFile = new TSR_LOG();
         }

         //Instancia de archivo de Recursos.
         oMsg = new ResourceManager(lServiceName+"."+MENSAJES, lAssembly);
         bIniciando = true;
         bDeteniendo = false;
         bProcesando = false;
         //Iniciando servicio
         oLogFile.Reporta(Nivel.INF, "[001]", oMsg.GetString("Msg_001"));
         oLogFile.Reporta(Nivel.DBG, "[002]", oMsg.GetString("Msg_002"));
         Inicializa();
         Inicia();
         // actualizamos las banderas
         bIniciando = false;
         
         oLogFile.Reporta(Nivel.DBG, "[003]", oMsg.GetString("Msg_003"));
         
      
      }

      protected override void OnStop()
      {
         //Indicar detención del Servicio.
         bDeteniendo = true;
         oLogFile.Reporta(Nivel.INF, "[051]", oMsg.GetString("Msg_051"));

         //Detener Reloj.
         oLogFile.Reporta(Nivel.DBG, "[052]", oMsg.GetString("Msg_052"));
         
         //[3]Esperar si está procesando.
         DateTime lTimeout = DateTime.Now.AddSeconds(20); //Le concedemos 20 segundos para terminar
         while (bProcesando && (DateTime.Now<lTimeout)) ;

         //Termina otras cosas que se deban cerrar o detener
         Termina();

         //[4]Reportar fin de Servicio.
         oLogFile.Reporta(Nivel.INF, "[053]", oMsg.GetString("Msg_053"));
      }

      private void Inicializa()
      {
         //Leer parámetros de Configuración.
         if (!LeerParamConfig() && (oLogFile != null))
               oLogFile.Reporta(Nivel.ERR, "[018]", oMsg.GetString("Msg_018"));

         //Configurar e Inicializar periodo de tiempo.
         oLogFile.Reporta(Nivel.DBG, "[030]", oMsg.GetString("Msg_030"));
         if (nFrecuencia <= 0)
         {
            oLogFile.Reporta(Nivel.ERR, "[016]", oMsg.GetString("Msg_016"));
            nFrecuencia=5000;
         }

         //Arranca Timers
         oReloj = new Timer(1000); //la primer ejecución del proceso la hace en un segundo, el resto, cada nFrecuencia
         this.oReloj.Elapsed += new ElapsedEventHandler(this.oReloj_Elapsed);
         oLogFile.Reporta(Nivel.DBG, "[031]", oMsg.GetString("Msg_031"));
         oReloj.Start();
         //oReloj.Enabled = bProcesando;
                  
         oLogFile.Reporta(Nivel.DBG, "[032]", String.Format(oMsg.GetString("Msg_032"), Convert.ToString(nFrecuencia/1000)));
         oWatchDog=new Timer(INTERVALO_WATCHDOG*1000); //cada 15 segundos
         this.oWatchDog.Elapsed += new ElapsedEventHandler(this.oWatchDog_Elapsed);
         oWatchDog.Start();
         //oWatchDog.Enabled = bProcesando;  

      }

      private void oReloj_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
      {
         //Detener momentaneamente el reloj.
         oLogFile.Reporta(Nivel.DBG, "[007]", oMsg.GetString("Msg_007"));
         oReloj.Enabled = false;

         //Asignar el nuevo valor del reloj
         if (nFrecuencia != oReloj.Interval) oReloj.Interval = nFrecuencia;

         //Realizar Proceso.
         oLogFile.Reporta(Nivel.DBG, "[008]", oMsg.GetString("Msg_008"));
         bProcesando = true;
         if (bReLeerINI) LeerParamConfig();
         if (!bReLeerINI) Procesa();
         
         //Reanudar el Reloj
         //Estan deteniendo el servicio?
         if (!bDeteniendo) //No, el servicio sigue encendido
         {
            oLogFile.Reporta(Nivel.DBG, "[009]", oMsg.GetString("Msg_009"));
            //[12.1]Activar reloj si esta detenido.
            if (oReloj.Enabled == false)
            {
               oLogFile.Reporta(Nivel.DBG, "[004]", oMsg.GetString("Msg_004"));
               oReloj.Enabled = true;
            }
         }
         else //Están Deteniendo al servicio
         {
            bDeteniendo = false;
            oLogFile.Reporta(Nivel.INF, "[017]", oMsg.GetString("Msg_017"));
         }

         bProcesando = false;
         // Detuvieron el servicio, detenemos el timer
         if (bDeteniendo) oReloj.Stop();
            

      }
      
      private void oWatchDog_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
      {
         string lsCad;
         long lnMinutos;
         long lnSegundos;

         //Inicia
         lnMinutos=INTERVALO_WATCHDOG*watchDogCounter/60;
         lnSegundos=INTERVALO_WATCHDOG*watchDogCounter % 60;
         lsCad=lnMinutos.ToString("00")+":"+lnSegundos.ToString("00");

         if (bProcesando)
         {
            if (watchDogCounter>=2)
               oLogFile.Reporta(Nivel.WRN, "[005]", string.Format(oMsg.GetString("Msg_005"), lsCad));
            if (watchDogCounter>=12)
            {
               oLogFile.Reporta(Nivel.ERR, "[006]", oMsg.GetString("Msg_006"));
               bProcesando=false;
               oReloj.Enabled = true;
               watchDogCounter=0;
            }
            watchDogCounter++;
         }

         // Detuvieron el servicio, detenemos el timer
         if (bDeteniendo) oWatchDog.Stop();
         
      }

/// <summary>
      /// Lee los parámetros de configuración desde el archivo INI y los
      /// carga en variables de módulo
      /// </summary>
      /// <returns>true=Leyo todo bien, false=hubo un error al leer el INI</returns>
      private bool LeerParamConfig()
      {
         bool lbOk = true;  //Validar acciones.
         TSR_INI loIniFile = new TSR_INI();  //Objeto controlador del archivo INI.

         // [1]Obtener parámetros del archivo INI.
         oLogFile.Reporta(Nivel.DBG, "[002]", oMsg.GetString("Msg_002"));
         if (loIniFile != null)
         {
            // 
            try
            {
               //[1] Obtener nivel de detalle de Log.
               oLogFile.Reporta(Nivel.DBG, "[010]", oMsg.GetString("Msg_010"));
               nDetLog = Convert.ToInt16(loIniFile.ObtenValor("Parametros", "DetalleLog", "2"));
               if (nDetLog < 0 || nDetLog >= 4) nDetLog = 2;
               oLogFile.nDetLog = (Nivel)nDetLog;

               //[1.4]Obtener frecuencia de Ejecución.
               oLogFile.Reporta(Nivel.DBG, "[013]", oMsg.GetString("Msg_013"));
               nFrecuencia = Convert.ToInt16(loIniFile.ObtenValor("Parametros", "Frecuencia", "1"));
               nFrecuencia = nFrecuencia * UNIDAD_TIEMPO;
               if (nFrecuencia<=0)
               {
                  oLogFile.Reporta(Nivel.ERR, "[016]", oMsg.GetString("Msg_016"));
                  lbOk=false;
               }

               #region Parámetros de conexión a la Base de Datos
                  // Lee Parámetros de conexión de la base de datos (Primaria).
                  oLogFile.Reporta(Nivel.DBG, "[011]", oMsg.GetString("Msg_011"));
                  DB_SRV = loIniFile.ObtenValor("ConexionDB", "Server", "");
                  DB_DB = loIniFile.ObtenValor("ConexionDB", "DataBase", "");
                  DB_UID = loIniFile.ObtenValor("ConexionDB", "User", "");
                 // DB_PWD = loIniFile.Desencripta(loIniFile.ObtenValor("ConexionDB", "Password", ""), KEY);
                  DB_PWD = loIniFile.ObtenValor("ConexionDB", "Password", "");
                  // 
                  if (DB_SRV.Trim() == "")
                  {
                     oLogFile.Reporta(Nivel.ERR, "[033]", oMsg.GetString("Msg_033"));
                     lbOk=false;
                  }
                  else if (DB_DB.Trim() == "")
                  {
                     oLogFile.Reporta(Nivel.ERR, "[034]", oMsg.GetString("Msg_034"));
                     lbOk=false;
                  }
                  else if (DB_UID.Trim() == "")
                  {
                     oLogFile.Reporta(Nivel.ERR, "[035]", oMsg.GetString("Msg_035"));
                     lbOk=false;
                  }
               #endregion
               
               //[1.5]Lectura correcta.
               if (lbOk) oLogFile.Reporta(Nivel.DBG, "[014]", oMsg.GetString("Msg_014"));
            }
            catch (Exception loErr)
            {
               oLogFile.Reporta(Nivel.ERR, "[015]", String.Format(oMsg.GetString("Msg_015"), loErr.Message));
               loIniFile = null;
               lbOk=false;
            }

            // [2] Actualizar información en el INI.
            try
            {
               //Actualizar Valores en INI
               oLogFile.Reporta(Nivel.DBG, "[020]", oMsg.GetString("Msg_020"));

               //Parámetros de Configuración
               oLogFile.Reporta(Nivel.DBG, "[021]", oMsg.GetString("Msg_021"));
               //Frecuencia de Ejecución.
               loIniFile.EscribeValor("Parametros", "Frecuencia", Convert.ToString(nFrecuencia / UNIDAD_TIEMPO));
               //Nivel de detalle de Log.
               loIniFile.EscribeValor("Parametros", "DetalleLog", nDetLog.ToString());


               //Parámetros de conexión de la base de datos (Primaria).
               oLogFile.Reporta(Nivel.DBG, "[022]", oMsg.GetString("Msg_022"));
               loIniFile.EscribeValor("ConexionDB", "Server", DB_SRV);
               loIniFile.EscribeValor("ConexionDB", "DataBase", DB_DB);
               loIniFile.EscribeValor("ConexionDB", "User", DB_UID);
               loIniFile.EscribeValor("ConexionDB", "Password", loIniFile.Encripta(DB_PWD, KEY));

            }
            catch (Exception loErr)
            {
               oLogFile.Reporta(Nivel.ERR, "[024]", String.Format(oMsg.GetString("Msg_024"), loErr.Message));
            }
         }
         else //no se pudo crear el objeto LOG
            lbOk=false;

         //[3]Retornar valor.
         bReLeerINI=!lbOk;
         return lbOk;
      }



   }
}
