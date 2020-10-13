
//Librerías por default
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.ServiceProcess;
using System.Text;

//Librerías de la plantilla  de servicios TSR
using System.Timers;
using System.Resources;

//Librerías del servicio específico
//using System.Drawing;
//using System.Windows.Forms;

using Teseracto.Data;
using Teseracto.IniFiles;
using Teseracto.Log;


namespace PrintRpt
{
   public partial class svcMain : ServiceBase
   {

      private void Inicia()
      {
         oLogFile.Reporta(Nivel.INF, "[???]", "Este código se ejecuta en el OnStart del servicio");
      }



      private void Procesa()
      {
         oLogFile.Reporta(Nivel.INF, "[???]", "Este es el proceso principal, se ejecuta cada Timer");

         //Añadir esta línea dentro de algún ciclo, para indicar al
         //WatchDog que el proceso sigue ejecutandose sin problemas
         watchDogCounter = 0;
      }




      /// <summary>
      /// Terminar cualquier cosa que se deba terminar al momento de detener el servicio
      /// </summary>
      private void Termina()
      {
         oLogFile.Reporta(Nivel.INF, "[???]", "Este código se ejecuta en el OnStop del servicio");
      }
   }
}
