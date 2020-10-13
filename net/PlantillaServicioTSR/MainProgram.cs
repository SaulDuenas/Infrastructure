using System;
using System.Collections.Generic;
using System.ServiceProcess;
using System.Text;

namespace PrintRpt
{
   static class MainProgram
   {
      /// <summary>
      /// The main entry point for the application.
      /// </summary>
      static void Main()
      {
         ServiceBase[] ServicesToRun;
         ServicesToRun = new ServiceBase[] 
			{ 
				new svcMain() 
			};
         ServiceBase.Run(ServicesToRun);
      }
   }
}
