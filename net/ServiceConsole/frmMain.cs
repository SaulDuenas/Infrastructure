/******************************************************************************
* Archivo:     frmMain.cs
* Descripción: Pantalla principal de la consola de control de servicios
* Proyecto:    Whirlpool - Line Performance System
* Autor(es):
*      MTB - Miguel A. Torres Orozco B.
* Notas:
*******************************************************************************/

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.ServiceProcess;
using System.IO;
using System.Resources;

namespace SrvControlPanel
{
   public partial class frmMain : Form
   {
      // Propiedades privadas del formulario
      private String ServicioActual;  //Servicio seleccionado
      private String ServicioAlterno; //Servicio seleccionado con click derecho
      private Dictionary<string, Servicio> mServicios = new Dictionary<string, Servicio>();
      private int mDetalleLog;  //Nivel de detalle del visor de logs: 0=ERR,1=WRN,2=INF,3=DBG
      private int mDiasLog;     //Días de log a mostrar
      private bool mCancelaLog;  //indica que se canceló el llenado del listview del log
      Dictionary<string, tTipoLog> mTiposLog = new Dictionary<string, tTipoLog>();

      //Constructor del formulario Principal
      public frmMain()
      {
         frmSplash frm = new frmSplash();

         frm.Show();
         frm.Refresh();
         System.Threading.Thread.Sleep(4000);
         frm.Close();
         frm.Dispose();
         frm = null;

         InitializeComponent();

         tTipoLog lTipoLog;
         ListViewItem listItem;

         /* Inicializa Diccionario de Servicios */
         //raíz
         mServicios.Add("tvnAplicacion", null);

         //Agrega cada uno de los servicios
         AñadirServicio("InViewSvc", "tvnInViewSvc");
         AñadirServicio("SyncSIMSvc", "tvnSyncSIMSvc");

         //Despliega los nodos
         tvServicios.Nodes[0].FirstNode.EnsureVisible();

         //Copia los servicios del treeview al listview de servicios
         foreach (TreeNode node in tvServicios.Nodes["tvnAplicacion"].Nodes)
            if (mServicios[node.Name] != null)
            {
               listItem=lvEstatusServicios.Items.Add(node.Name, node.Text, "Engrane");
               listItem.SubItems.Add("Estatus").Text = "";
            }
         lvEstatusServicios.Columns[0].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);

         //Activa el timer de verificación de estatus de servicios
         timerEstatusServicios.Enabled = true;


         //Inicializa Nivel de Logs
         mDetalleLog = 2; //2=INF
         cmbDiasLog.SelectedIndex = 0;
         mDiasLog = 0;

         // Inicializa colección de tipos
         lTipoLog.Descripcion = "Depuración"; lTipoLog.Nivel = 3; mTiposLog.Add("DBG", lTipoLog);
         lTipoLog.Descripcion = "Información"; lTipoLog.Nivel = 2; mTiposLog.Add("INF", lTipoLog);
         lTipoLog.Descripcion = "Advertencia"; lTipoLog.Nivel = 1; mTiposLog.Add("WRN", lTipoLog);
         lTipoLog.Descripcion = "Error"; lTipoLog.Nivel = 0; mTiposLog.Add("ERR", lTipoLog);
         lTipoLog.Descripcion = "No Reconocido!"; lTipoLog.Nivel = 1; mTiposLog.Add("???", lTipoLog);
      }

      //Añade un servicio a la colección
      //forma parte de la inicialización de la ventana
      private void AñadirServicio(string ServiceName, string NodeName)
      {
         Servicio lSrv;
         ServiceControllerStatus lDummy;
        
         //Crea el objeto ServiceController
         lSrv = new Servicio(ServiceName);
       
         //intenta leer su estatus
         try
         {
            lDummy = lSrv.Status;
         }
         catch
         {
            lSrv = null;
         }
         finally
         {
            //Añade el objeto a la colección, con llave igual a la del Nodo del TreeView
            mServicios.Add(NodeName, lSrv);
         }
      }

      //Actualiza pantalla de acuerdo al nodo seleccionado
      private void tvServicios_AfterSelect(object sender, TreeViewEventArgs e)
      {
         //Establece el servicio Seleccionado
         ServicioActual = e.Node.Name;

         //Muestra el nombre del servicio seleccionado en la barra de estatus
         if (mServicios[ServicioActual] == null)
            if (ServicioActual != "tvnAplicacion")
               panelStatus.Text = "El servicio no está instalado!!!";
            else
               panelStatus.Text = "Todos los servicios";
         else
            panelStatus.Text = "Servicio: " + e.Node.Text;

         //Dependiendo del nodo muetra un ListView de Log o el de estatus de servicios
         switch (ServicioActual)
         {
            case "tvnAplicacion":
               lvEstatusServicios.Visible = true;
               lvEstatusServicios.Dock = DockStyle.Fill;
               lvLog.Visible = false;
               break;

            default:  //Un servicio
               lvLog.Visible = true;
               lvLog.Dock = DockStyle.Fill;
               lvEstatusServicios.Visible = false;
               break;
         }
         //Actualiza barras de herramientas
         EnableButtons();
         //Refresca ListView de Logs
         RefrescaLog();
      }


      //Refresca el ListView de Logs
      private void RefrescaLog()
      {
         //Variables locales
         System.Globalization.CultureInfo lCultura = new System.Globalization.CultureInfo("es-MX");
         string prefijoLogFileName;
         DateTime ldFechaIni, ldFechaFin, ldFecha;
         DateTime ldTimeoutLog;
         string fileName;
         string[] lCad;
         Stream lStream;
         StreamReader fs;
         ListViewItem listItem;

         //Limpia el ListView
         lvLog.Items.Clear();

         if (mServicios[ServicioActual] != null)
         {

            //Establece fechas de inicio y fin
            ldFechaFin = DateTime.Today;
            ldFechaIni = ldFechaFin.AddDays(-mDiasLog); //TODO manejar DiasLog=Todos (cuando DiasLog=3)


            //establece el prefijo del nombre del archivo log a desplegar
            prefijoLogFileName = mServicios[ServicioActual].ExeName.Remove(mServicios[ServicioActual].ExeName.LastIndexOf(".exe")) + "_";
            prefijoLogFileName = prefijoLogFileName.Insert(prefijoLogFileName.LastIndexOf('\\'), "\\Logs");

            //Recorre las fechas
            for (ldFecha = ldFechaIni; ldFecha <= ldFechaFin; ldFecha = ldFecha.AddDays(1))
            {
               //Arma el nombre del archivo log
               fileName = prefijoLogFileName + ldFecha.ToString("yyMMdd") + ".log";
               if (File.Exists(fileName))
               {
                  //Abre el archivo
                  lStream=File.Open(fileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
                  fs = new StreamReader(lStream, true);
                  mCancelaLog=false;


                  ldTimeoutLog=DateTime.Now.AddSeconds(3.5);

                  //barre renglón por renglón
                  while (!fs.EndOfStream && !mCancelaLog)
                  {
                     #region inserta un elemento al listview del log
                     lCad = fs.ReadLine().Split('\t');
                     //El renglón tiene 4 columnas segun lo esperado?
                     if (lCad.Length == 4)
                     {
                        //Ajusta el tipo en caso de ser necesario
                        if (!(lCad[1] == "DBG" || lCad[1] == "INF" || lCad[1] == "WRN" || lCad[1] == "ERR")) lCad[1] = "???";
                        //Cae dentro del nivel de reporteo?
                        if (ChecaNivelLog(lCad[1]))
                        {
                           // lo mete al listview
                           listItem = lvLog.Items.Add(mTiposLog[lCad[1]].Descripcion);
                           listItem.ImageKey = lCad[1];
                           listItem.SubItems.Add("FechaHora").Text = lCad[0];
                           listItem.SubItems.Add("Codigo").Text = lCad[2];
                           listItem.SubItems.Add("Mensaje").Text = lCad[3];
                        }
                     }
                     else //No tiene 4 columnas, lo mete sin formato
                     {
                        if (mTiposLog["???"].Nivel <= mDetalleLog)
                        {
                           listItem = lvLog.Items.Add(mTiposLog["???"].Descripcion);
                           listItem.ImageKey = "???";
                           listItem.SubItems.Add("FechaHora").Text = "";
                           listItem.SubItems.Add("Codigo").Text = "[???]";
                           listItem.SubItems.Add("Mensaje").Text = lCad[0];
                        }
                     }
                     #endregion

                     if (!progressBar.Visible)
                     {
                        if (DateTime.Now> ldTimeoutLog) ActivaBarraProgreso(true);
                     }
                     else
                     {
                        progressBar.Value=(int)(lStream.Position*100/lStream.Length);
                        lblPorcAvance.Text=progressBar.Value.ToString()+"%";
                        statusStrip1.Refresh();
                        Application.DoEvents();
                     }
                  }

                  ActivaBarraProgreso(false);

                  //Cierra el archivo
                  fs.Close();
                  fs = null;
                  lStream.Close();
                  lStream=null;
               }
            } // for de fechas

            //Verifica si el listview está vacío
            if (lvLog.Items.Count == 0)
            {
               //Reporta que no hay eventos
               listItem = lvLog.Items.Add(mTiposLog["INF"].Descripcion);
               listItem.ImageKey = "INF";
               listItem.SubItems.Add("FechaHora").Text = "";
               listItem.SubItems.Add("Codigo").Text = "[???]";
               listItem.SubItems.Add("Mensaje").Text = "No hay eventos reportados en el log";
            }
         }
         else
         {
            listItem = lvLog.Items.Add(mTiposLog["WRN"].Descripcion);
            listItem.ImageKey = "WRN";
            listItem.SubItems.Add("FechaHora").Text = "";
            listItem.SubItems.Add("Codigo").Text = "[???]";
            listItem.SubItems.Add("Mensaje").Text = "El servicio no está instalado";
         }
         //Termina
         lCultura = null;
         //Hace Resize de las columnas del listview
         foreach (ColumnHeader lCol in lvLog.Columns)
            if (lCol.Text == "Código")
               lCol.AutoResize(ColumnHeaderAutoResizeStyle.HeaderSize);
            else
               lCol.AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
      }


      private void ActivaBarraProgreso(bool activar)
      {
         menuStrip1.Enabled=!activar;
         lvLog.Visible=!activar;
         tvServicios.Enabled=!activar;
         toolStripPrincipal.Enabled=!activar;
         toolStripSecundaria.Enabled=!activar;
         progressBar.Visible=activar;
         lblPorcAvance.Visible=activar;
         lblBtnCancelar.Visible=activar;
      }



      private bool ChecaNivelLog(string Nivel)
      {
         bool lResult;

         switch (Nivel)
         {
            case "DBG":
               lResult = btnLogDebug.Checked;
               break;
            case "INF":
               lResult = btnLogInfo.Checked;
               break;
            case "WRN":
               lResult = btnLogWarning.Checked;
               break;
            case "ERR":
               lResult = btnLogError.Checked;
               break;
            default:
               lResult = true;
               break;
         }
         //Regresa
         return (lResult);
      }


      //Actualiza las barras de herramientas dependiendo del estatus del servicio actual (el seleccionado)
      private void EnableButtons()
      {
         if (mServicios[ServicioActual] == null)
         {
            if (ServicioActual == "tvnAplicacion")
            {
               //Aplicacion
               btnPlay.Enabled = true;
               btnStop.Enabled = true;
               btnConfigurar.Enabled = false;
               btnAbrirFolderLogs.Enabled=false;
               mnuSrvPlay.Enabled = true;
               mnuSrvStop.Enabled = true;
               mnuSrvConfigurar.Enabled = false;
            }
            else
            {
               //Servicio no instalado
               btnPlay.Enabled = false;
               btnStop.Enabled = false;
               btnConfigurar.Enabled = false;
               btnAbrirFolderLogs.Enabled=false;
               mnuSrvPlay.Enabled = false;
               mnuSrvStop.Enabled = false;
               mnuSrvConfigurar.Enabled = false;
            }
         }
         else
         {
            //Habilita Botones segun estado del servicio
            btnPlay.Enabled = mnuSrvPlay.Enabled = mServicios[ServicioActual].EnabledPlay;
            btnStop.Enabled = mnuSrvStop.Enabled = mServicios[ServicioActual].EnabledStop;
            btnConfigurar.Enabled = mnuSrvConfigurar.Enabled = mServicios[ServicioActual].EnabledConfig;
            btnAbrirFolderLogs.Enabled=true;
         }
      }

      //Inicia un servicio
      /// <summary>
      /// Inicia un servicio
      /// </summary>
      /// <param name="IDServicio">ID del servicio, corresponde también al Id del nodo del treeview</param>
      private void IniciarServicio(string IDServicio)
      {
         Servicio lSrv;
         DialogResult lBoton;

         if (IDServicio != "tvnAplicacion")
         {
            //Obtiene el servicio a partir del ID
            lSrv = mServicios[IDServicio];

            //Inicia el servicio (si existe y no está corriendo ya)
            if ((lSrv != null) && (lSrv.Status != ServiceControllerStatus.Running))
               lSrv.Start();
         }
         else // inicia todos
         {
            lBoton= MessageBox.Show("¿Desea iniciar todos los servicios?", "Confirmar Inicio de Servicios", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (lBoton==DialogResult.Yes)
            {
               foreach (string lKey in mServicios.Keys)
               {
                  //Obtiene el servicio a partir del ID
                  lSrv = mServicios[lKey];
                  //Inicia el servicio (si existe y no está corriendo ya)
                  if ((lSrv != null) && (lSrv.Status != ServiceControllerStatus.Running))
                     lSrv.Start();
               }
            }
         }
      }

      //Detiene un servicio
      /// <summary>
      /// Detiene un servicio
      /// </summary>
      /// <param name="IDServicio">ID del servicio, corresponde también al Id del nodo del treeview</param>
      private void DetenerServicio(string IDServicio)
      {
         Servicio lSrv;
         DialogResult lBoton;

         if (IDServicio != "tvnAplicacion")
         {
            //Obtiene el servicio a partir del ID
            lSrv = mServicios[IDServicio];

            //Detiene el servicio (si existe y no está detenido ya)
            if ((lSrv != null) && (lSrv.Status != ServiceControllerStatus.Stopped))
               lSrv.Stop();
         }
         else //detiene todos
         {
            lBoton= MessageBox.Show("¿Desea detener todos los servicios?", "Confirmar Detención de Servicios", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (lBoton==DialogResult.Yes)
            {
               foreach (string lKey in mServicios.Keys)
               {
                  //Obtiene el servicio a partir del ID
                  lSrv = mServicios[lKey];
                  //Detiene el servicio (si existe y no está detenido ya)
                  if ((lSrv != null) && (lSrv.Status != ServiceControllerStatus.Stopped))
                     lSrv.Stop();
               }
            }
         }
      }

      /**********************************************************************
       * BOTONES DE LA BARRA DE HERRAMIENTAS (PLAY, STOP, CONFIGURAR)
       *********************************************************************/
      private void btnPlay_Click(object sender, EventArgs e)
      {
         IniciarServicio((sender == mnuCtxPlay) ? ServicioAlterno : ServicioActual);
      }
      private void btnStop_Click(object sender, EventArgs e)
      {
         DetenerServicio((sender == mnuCtxStop) ? ServicioAlterno : ServicioActual);
      }
      private void btnConfigurar_Click(object sender, EventArgs e)
      {
         string lSrv;
         lSrv = (sender == mnuCtxConfig) ? ServicioAlterno : ServicioActual;

         if (lSrv!="tvnAplicacion")
         {
            if (lSrv == "tvnInViewSvc")
            {
               frmCfgInViewSvc frmConfig = new frmCfgInViewSvc(mServicios[lSrv].ExeName, tvServicios.Nodes["tvnAplicacion"].Nodes[lSrv].Text);
               frmConfig.ShowDialog(this);
               frmConfig = null;
            }
            if (lSrv == "tvnSyncSIMSvc")
            {
               frmCfgSyncSIMSvc frmConfig = new frmCfgSyncSIMSvc(mServicios[lSrv].ExeName, tvServicios.Nodes["tvnAplicacion"].Nodes[lSrv].Text);
               frmConfig.ShowDialog(this);
               frmConfig = null;
            }
         }
      }

      private void btnRefrescarLog_Click(object sender, EventArgs e)
      {
         RefrescaLog();
      }

      //Llamadas a los botones de la barra de herramientas (Stop, Play, Configurar)
      #region eventos de las barras de menu
      private void mnuSrvPlay_Click(object sender, EventArgs e) { btnPlay_Click(sender, e); }
      private void mnuSrvStop_Click(object sender, EventArgs e) { btnStop_Click(sender, e); }
      private void mnuSrvConfigurar_Click(object sender, EventArgs e) { btnConfigurar_Click(sender, e); }

      private void mnuCtxPlay_Click(object sender, EventArgs e) { btnPlay_Click(sender, e); }
      private void mnuCtxStop_Click(object sender, EventArgs e) { btnStop_Click(sender, e); }
      private void mnuCtxConfig_Click(object sender, EventArgs e) { btnConfigurar_Click(sender, e); }
      private void mnuRefrescarLog_Click(object sender, EventArgs e) { btnRefrescarLog_Click(sender, e); }

      #endregion

      //Refresca el estatus (iconos) de cada servicio 
      private void timerEstatusServicios_Tick(object sender, EventArgs e)
      {
         bool huboCambios = false;
         string iconAplicacion="Warning";

         //Recorre los nodos hijo (servicios)
         foreach (TreeNode nodo in tvServicios.Nodes["tvnAplicacion"].Nodes)
         {
            if (mServicios[nodo.Name] != null)
            {
               mServicios[nodo.Name].Refresh();
               switch (mServicios[nodo.Name].Status)
               {
                  case ServiceControllerStatus.Stopped:
                     huboCambios = SetNodeIcon(nodo, "Rojo");
                     if (huboCambios) lvEstatusServicios.Items[nodo.Name].SubItems[1].Text = "Detenido";
                     CalcAppIcon(ref iconAplicacion, "Rojo");
                     break;
                  case ServiceControllerStatus.Running:
                     huboCambios = SetNodeIcon(nodo, "Verde");
                     if (huboCambios) lvEstatusServicios.Items[nodo.Name].SubItems[1].Text = "En ejecución";
                     CalcAppIcon(ref iconAplicacion, "Verde");
                     break;
                  default:
                     huboCambios = SetNodeIcon(nodo, "Amarillo");
                     if (huboCambios) lvEstatusServicios.Items[nodo.Name].SubItems[1].Text = "Pendiente";
                     CalcAppIcon(ref iconAplicacion, "Amarillo");
                     break;
               }
            }
            else
               huboCambios = SetNodeIcon(nodo, "Warning");

            //Actualiza barras de herramientas de ser necesario
            if (nodo.Name == ServicioActual && huboCambios)
               EnableButtons();
         }
         //Actualiza estatus del nodo aplicacion
         SetNodeIcon(tvServicios.Nodes["tvnAplicacion"], iconAplicacion);
      }

      private void CalcAppIcon(ref string iconoActual, string iconoNuevo)
      {
         switch (iconoActual)
         {
            case "Warning":
               iconoActual=iconoNuevo;
               break;
            case "Verde":
               if (iconoNuevo=="Amarillo"||iconoNuevo=="Rojo")
                  iconoActual="Amarillo";
               break;
            case "Amarillo":
               break;
            case "Rojo":
               if (iconoNuevo=="Amarillo"||iconoNuevo=="Verde")
                  iconoActual="Amarillo";
               break;
         }

      }

      //cambia el icono de un nodo del treeview
      private bool SetNodeIcon(TreeNode Nodo, string IconKey)
      {
         bool HuboCambio = false;

         if (Nodo.ImageKey != IconKey)
         {
            Nodo.ImageKey = IconKey;
            Nodo.SelectedImageKey = IconKey;
            HuboCambio = true;
         }
         return HuboCambio;
      }


      /**********************************************************************
       * BOTONES DE LA BARRA DE HERRAMIENTAS (LOGS)
       *********************************************************************/
      //Cambia el nivel de detalle de la ventana de Logs
      private void BotonesDetalleLog_Click(object sender, EventArgs e)
      {
         ToolStripMenuItem lBtn;

         if (sender == btnLogDetalle)
            btnLogDetalle.ShowDropDown();
         else
         {
            //Obtiene el Botón oprimido
            lBtn = (ToolStripMenuItem)sender;

            //Marca el botón
            lBtn.Checked = !lBtn.Checked;
            //Refresca Ventana de Logs
            RefrescaLog();
         }
      }
      //Establece el número de días a visualizar del log
      private void cmbDiasLog_SelectedIndexChanged(object sender, EventArgs e)
      {
         mDiasLog = cmbDiasLog.SelectedIndex;
         if (lvLog.Visible) lvLog.Focus(); else tvServicios.Focus();
         if (ServicioActual!=null) RefrescaLog();
      }


      /****************************************************
       * Menú Contextual de Servicios
       ****************************************************/
      //Click sobre un Nodo del TreeView
      //Establece la variable ServicioAlterno
      private void tvServicios_NodeMouseClick(object sender, TreeNodeMouseClickEventArgs e)
      {
         //Es Click derecho?
         if (e.Button == MouseButtons.Right)
         {
            //Establece la variable ServicioAlterno
            ServicioAlterno = e.Node.Name;
            tvServicios.Tag = e.Node.Text;
         }
      }

      //Desplegar menú contextual
      private void contextMenuStrip1_Opening(object sender, CancelEventArgs e)
      {
         Servicio lServicio;

         //El nodo al que se le dió click derecho viene en el Tag del treeview
         if (ServicioAlterno != "")
         {
            //Nombre del servicio(nodo)
            mnuCtxNombreServicio.Text = tvServicios.Tag.ToString();

            //Obtiene el servicio en cuestión
            lServicio = mServicios[ServicioAlterno];
            if (lServicio != null)
            {
               //(Des)Habilita menús de acuerdo al estado del servicio
               mnuCtxPlay.Enabled = lServicio.EnabledPlay;
               mnuCtxStop.Enabled = lServicio.EnabledStop;
               mnuCtxConfig.Enabled = lServicio.EnabledConfig;
            }
            else
            {
               //No hay servicio en este nodo
               //Se trata del nodo raíz (tvnAplicación)?
               if (ServicioAlterno == "tvnAplicacion")
               {
                  //tvnAplicacion
                  mnuCtxPlay.Enabled = true;
                  mnuCtxStop.Enabled = true;
                  mnuCtxConfig.Enabled = false;
               }
               else
               {
                  //el nodo no tiene servicio. No se puede hacer nada.
                  mnuCtxPlay.Enabled = false;
                  mnuCtxStop.Enabled = false;
                  mnuCtxConfig.Enabled = false;
               }
            }
         }
         else
            e.Cancel = true;
      }


      private void acercaDeToolStripMenuItem1_Click(object sender, EventArgs e)
      {
         frmAcercade frm;
         frm = new frmAcercade();
         frm.Inicia();
         frm = null;
      }

      private void opcionesToolStripMenuItem_Click(object sender, EventArgs e)
      {
         string[] lRecursos;
         string lCad;

         //Obtiene un arreglo con todos los recursos incrustados en el ejecutable
         lRecursos = System.Reflection.Assembly.GetExecutingAssembly().GetManifestResourceNames();

         //Al meter el arreglo en un watch, pude observar que el que busco se llama "SrvControlPanel.Resources.Strings"
         // entonces, se crea un objeto ResourceManager asociado a ese recurso
         ResourceManager lRes=new ResourceManager("SrvControlPanel.Resources.Strings", System.Reflection.Assembly.GetExecutingAssembly());

         // de ese recurso obtengo la cadena que me interesa
         lCad = String.Format(lRes.GetString("msgIniciaServicio"), "XXX", "YYY");
         MessageBox.Show(lCad);
      }

      private void lblBtnCancelar_Click(object sender, EventArgs e)
      {
         mCancelaLog=true;
         ActivaBarraProgreso(false);
         statusStrip1.Refresh();
         Application.DoEvents();

      }

      private void btnAbrirFolderLogs_Click(object sender, EventArgs e)
      {
         string lFolder;
         lFolder = mServicios[ServicioActual].ExeName.Remove(mServicios[ServicioActual].ExeName.LastIndexOf("\\")+1) + "Logs";
         System.Diagnostics.Process.Start("explorer.exe", lFolder);
      }

      private void salirToolStripMenuItem1_Click(object sender, EventArgs e)
      {
         Application.Exit();
      }
   }
}