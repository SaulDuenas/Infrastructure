using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.ServiceProcess;
using Microsoft.Win32;

namespace SrvControlPanel
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new frmMain());
        }
    }
	 //Tipos
	 public struct tTipoLog
	 {
		 public string Descripcion;
		 public int Nivel;
	 }

	//Clase Servicio heredada de ServiceController
	public class Servicio:ServiceController
	{
		//variables locales para almecenar las nuevas propiedades
		private bool lEnabledPlay;
		private bool lEnabledStop;
		private bool lEnabledConfig;
		private string lExeName;
		private string lExePath;

		//Constructores que invocan a los constructores originales (de la clase base) mas una inicialización
		public Servicio() : base() { inicializa(); }
		public Servicio(string name) : base(name) { inicializa(); }
		public Servicio(string name, string machineName) : base(name, machineName) { inicializa(); }

		//inicialización de las nuevas propiedades
		private void inicializa()
		{
			string lKeyName;

			lEnabledPlay = false;
			lEnabledStop = false;
			lEnabledConfig = false;

			//Obtiene el nombre del EXE del servicio
			try
			{
				lKeyName = "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\" + base.ServiceName;
				lExeName = Registry.GetValue(lKeyName, "ImagePath", "").ToString();
				lExeName = lExeName.Replace("\"", ""); //quita las comillas
				lExePath= lExeName.Remove(lExeName.LastIndexOf("\\")+1);
			}
			catch
			{
				lExeName = "";
				lExePath = "";
			}
		}

		//Propiedades nuevas

		/// <summary>
		/// Nombre y ruta del ejecutable (.exe) del servicio
		/// </summary>
		public string ExeName { get { return lExeName; } }
		
		/// <summary>
		/// Ruta del ejecutable (.exe) del servicio
		/// </summary>
		public string ExePath { get { return lExePath; } }
		
		/// <summary>
		/// Indica si el botón Play debe estar habilitado (dependiendo del estatus del servicio)
		/// </summary>
		public bool EnabledPlay { get {return lEnabledPlay;} }

		/// <summary>
		/// Indica si el botón Stop debe estar habilitado (dependiendo del estatus del servicio)
		/// </summary>
		public bool EnabledStop { get { return lEnabledStop; } }

		/// <summary>
		/// Indica si el botón Configurar debe estar habilitado (dependiendo del estatus del servicio)
		/// </summary>
		public bool EnabledConfig { get { return lEnabledConfig; } }

		//Nueva definición del método refresh
		public new void Refresh()
		{
			//invoca al refresh original
			base.Refresh();
			switch (base.Status)
			{
				case ServiceControllerStatus.Stopped:
					lEnabledPlay = true;
					lEnabledStop = false;
					lEnabledConfig = true;
					break;
				case ServiceControllerStatus.Paused:
					lEnabledPlay = true;
					lEnabledStop = true;
					lEnabledConfig = false;
					break;
				case ServiceControllerStatus.Running:
				case ServiceControllerStatus.ContinuePending:
				case ServiceControllerStatus.StartPending:
					lEnabledPlay = false;
					lEnabledStop = true;
					lEnabledConfig = false;
					break;
				case ServiceControllerStatus.StopPending:
				case ServiceControllerStatus.PausePending:
					lEnabledPlay = false;
					lEnabledStop = false;
					lEnabledConfig = false;
					break;
			}
		}
	}


}