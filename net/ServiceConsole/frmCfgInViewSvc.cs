using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;

using Teseracto.Data;
using Teseracto.IniFiles;


namespace SrvControlPanel
{
   public partial class frmCfgInViewSvc : Form
   {
      private string IniFileName;
      private RadioButton[] optNivelLog=new RadioButton[4];
      private TSR_INI oIni;
      private TSR_DB oDB;
      private const int KEY=8;
      private bool Conectado=false;
      private string numInviews;

      public frmCfgInViewSvc(string pSrvExeName, string pSrvDescripcion)
      {
         InitializeComponent();

         //Inicializa arreglos de controles
         optNivelLog[0] = optError;
         optNivelLog[1] = optWarning;
         optNivelLog[2] = optInfo;
         optNivelLog[3] = optDebug;


         //Obtiene el nombre del archivo Ini
         IniFileName = pSrvExeName.Remove(pSrvExeName.LastIndexOf(".exe"))+".ini";

         //Pone el título de la ventana
         this.Text="Configuración de " + pSrvDescripcion;

         //Crea el objeto INI
         oIni = new TSR_INI(IniFileName);
         //Crea el objeto DB
         oDB = new TSR_DB();
         Conectado=false;


         //Inicializa controles
         InicializaControles();
      }

      private void InicializaControles()
      {
         int nivelLog;
         int i;
         int Cuantas;
         bool lHayIni=true;
         ListViewItem listItem;

         //Verifica si el archivo existe
         if (!File.Exists(IniFileName))
         {
            lHayIni=false;
            MessageBox.Show("No de encontró el archivo INI correspondiente. \nSe cargarán los valores predeterminados", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
         }

         /* Lee parámetros del archivo INI */
         //Intervalo de Análisis
         txtIntervaloAnalisis.Value = int.Parse(oIni.ObtenValor("Parametros", "IntervaloAnalisis", "0"));
         //Nivel de detalle de log
         nivelLog=int.Parse(oIni.ObtenValor("Parametros", "DetalleLog", "2"));
         optNivelLog[nivelLog].Checked=true;
         //Días de Log
         txtDiasLog.Value= int.Parse(oIni.ObtenValor("Parametros", "DiasLog", "2"));

         //DB LPS
         txtSVR_Origen.Text = oIni.ObtenValor("Conexion", "Server", "");
         txtDB_Origen.Text = oIni.ObtenValor("Conexion", "DataBase", "");
         txtUID_Origen.Text = oIni.ObtenValor("Conexion", "User", "");
         txtPWD_Origen.Text = oIni.Desencripta(oIni.ObtenValor("Conexion", "Password", ""), KEY);

         //se conecta a la DB
         Cursor.Current=Cursors.WaitCursor;
         oDB.DBIniParam(txtSVR_Origen.Text, txtDB_Origen.Text, txtUID_Origen.Text, txtPWD_Origen.Text);
         if ((!(Conectado=oDB.DBConectar()))&&(lHayIni))
         {
            Cursor.Current=Cursors.Default;
            MessageBox.Show("No se pudo conectar a la base de datos. \nLa pestaña 'Celdas' no se mostrará correctamente hasta que los datos de conexión estén correctos y oprima el botón 'Probar'", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
         }
         Cursor.Current=Cursors.Default;

         //InViews
         numInviews=oIni.ObtenValor("Inviews", "Unidades", "4");

         //Inview 1
         ucInViewCfg1.IPAddress= oIni.ObtenValor("Inview-0", "NetworkAddress", "");
         ucInViewCfg1.IPPort= oIni.ObtenValor("Inview-0", "NetworkPort", "3001");
         ucInViewCfg1.DisplayAddress=oIni.ObtenValor("Inview-0", "DisplayAddress", "");
         ucInViewCfg1.Frecuencia=oIni.ObtenValor("Inview-0", "Frecuencia", "");

         //Inview 2
         ucInViewCfg2.IPAddress= oIni.ObtenValor("Inview-1", "NetworkAddress", "");
         ucInViewCfg2.IPPort= oIni.ObtenValor("Inview-1", "NetworkPort", "3001");
         ucInViewCfg2.DisplayAddress=oIni.ObtenValor("Inview-1", "DisplayAddress", "");
         ucInViewCfg2.Frecuencia=oIni.ObtenValor("Inview-1", "Frecuencia", "");

         //Inview 3
         ucInViewCfg3.IPAddress = oIni.ObtenValor("Inview-2", "NetworkAddress", "");
         ucInViewCfg3.IPPort = oIni.ObtenValor("Inview-2", "NetworkPort", "3001");
         ucInViewCfg3.DisplayAddress = oIni.ObtenValor("Inview-2", "DisplayAddress", "");
         ucInViewCfg3.Frecuencia = oIni.ObtenValor("Inview-2", "Frecuencia", "");

         //Inview 4
         ucInViewCfg4.IPAddress = oIni.ObtenValor("Inview-3", "NetworkAddress", "");
         ucInViewCfg4.IPPort = oIni.ObtenValor("Inview-3", "NetworkPort", "3001");
         ucInViewCfg4.DisplayAddress = oIni.ObtenValor("Inview-3", "DisplayAddress", "");
         ucInViewCfg4.Frecuencia = oIni.ObtenValor("Inview-3", "Frecuencia", "");




         //Celdas InView 1
         ucListaCeldas1.Celdas.Items.Clear();
         Cuantas=int.Parse(oIni.ObtenValor("Celdas-0", "Cantidad", "0"));
         for (i=0; i<Cuantas; i++)
         {
            listItem=ucListaCeldas1.Celdas.Items.Add(oIni.ObtenValor("Celdas-0", "Celda_"+i.ToString(), ""));
            listItem.ImageKey="Celda";
            if (Conectado)
               listItem.SubItems.Add((string)oDB.DBQryDato("SELECT sDescription FROM OEEConfigWorkcell WHERE lOEELineId="+listItem.Text));
            else
               listItem.SubItems.Add("<No hay conexión a DB>");
         }
         ucListaCeldas1.oDB=oDB;

         //Celdas InView 2
         ucListaCeldas2.Celdas.Items.Clear();
         Cuantas=int.Parse(oIni.ObtenValor("Celdas-1", "Cantidad", "0"));
         for (i=0; i<Cuantas; i++)
         {
            listItem=ucListaCeldas2.Celdas.Items.Add(oIni.ObtenValor("Celdas-1", "Celda_"+i.ToString(), ""));
            listItem.ImageKey="Celda";
            if (Conectado)
               listItem.SubItems.Add((string)oDB.DBQryDato("SELECT sDescription FROM OEEConfigWorkcell WHERE lOEELineId="+listItem.Text));
            else
               listItem.SubItems.Add("<No hay conexión a DB>");
         }
         ucListaCeldas2.oDB=oDB;

         //Celdas InView 3
         ucListaCeldas3.Celdas.Items.Clear();
         Cuantas = int.Parse(oIni.ObtenValor("Celdas-2", "Cantidad", "0"));
         for (i = 0; i < Cuantas; i++)
         {
             listItem = ucListaCeldas3.Celdas.Items.Add(oIni.ObtenValor("Celdas-2", "Celda_" + i.ToString(), ""));
             listItem.ImageKey = "Celda";
             if (Conectado)
                 listItem.SubItems.Add((string)oDB.DBQryDato("SELECT sDescription FROM OEEConfigWorkcell WHERE lOEELineId=" + listItem.Text));
             else
                 listItem.SubItems.Add("<No hay conexión a DB>");
         }
         ucListaCeldas3.oDB = oDB;

         //Celdas InView 4
         ucListaCeldas4.Celdas.Items.Clear();
         Cuantas = int.Parse(oIni.ObtenValor("Celdas-3", "Cantidad", "0"));
         for (i = 0; i < Cuantas; i++)
         {
             listItem = ucListaCeldas4.Celdas.Items.Add(oIni.ObtenValor("Celdas-3", "Celda_" + i.ToString(), ""));
             listItem.ImageKey = "Celda";
             if (Conectado)
                 listItem.SubItems.Add((string)oDB.DBQryDato("SELECT sDescription FROM OEEConfigWorkcell WHERE lOEELineId=" + listItem.Text));
             else
                 listItem.SubItems.Add("<No hay conexión a DB>");
         }
         ucListaCeldas4.oDB = oDB;

      }

      private void btnAceptar_Click(object sender, EventArgs e)
      {
         int i;   //Índice de botones de opción.
         bool lbOk = false;

         //[1]Validando campos de conexión.
         if (txtDB_Origen.Text.Trim() == "")
             MessageBox.Show("El campo base de datos es requerido.", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
         else if (txtSVR_Origen.Text.Trim() == "")
             MessageBox.Show("El campo servidor es requerido.", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
         else if (txtUID_Origen.Text.Trim() == "")
             MessageBox.Show("El campo usuario es requerido.", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
         else
             lbOk = ValidaInviews();

         if (!lbOk) tabControl1.SelectTab(1);

         //Escribe los valores en el archivo INI y cierra la ventana.
         if (lbOk)
         {
            

            //Escribe los Parametros de conexion 
            oIni.EscribeValor("Conexion", "Server", txtSVR_Origen.Text);
            oIni.EscribeValor("Conexion", "DataBase", txtDB_Origen.Text);
            oIni.EscribeValor("Conexion", "User", txtUID_Origen.Text);
            oIni.EscribeValor("Conexion", "Password", oIni.Encripta(txtPWD_Origen.Text, KEY));

            //Escribe la sección de parámetros            
            //Nivel de detalle de log
            for (i = 0; i < 4; i++)
                if (optNivelLog[i].Checked)
                    oIni.EscribeValor("Parametros", "DetalleLog", i.ToString());
            //Dias de Log
            oIni.EscribeValor("Parametros", "DiasLog", txtDiasLog.Value.ToString());
            //InViews
            oIni.EscribeValor("Inviews", "Unidades", numInviews);


             //Escribe los Inviews y sus celdas asociadas
            //Inview 1
            EscribeEnIni_Inview_Celdas(ref oIni, ucInViewCfg1, ucListaCeldas1, 0);         
            //Inview 2
            EscribeEnIni_Inview_Celdas(ref oIni, ucInViewCfg2, ucListaCeldas2, 1);            
            //Inview 3
            EscribeEnIni_Inview_Celdas(ref oIni, ucInViewCfg3, ucListaCeldas3, 2);            
            //Inview 4
            EscribeEnIni_Inview_Celdas(ref oIni, ucInViewCfg4, ucListaCeldas4, 3);                  

                      
            this.Close();
         }
      }


      private bool ValidaInviews()
      {
          bool Ret = false;
          //Inview 1
          Ret=ValidaParametrosInview(ucInViewCfg1, 1);
          //Inview 2
          Ret = ValidaParametrosInview(ucInViewCfg2, 2);
          //Inview 3
          Ret = ValidaParametrosInview(ucInViewCfg3, 3);
          //Inview 4
          Ret = ValidaParametrosInview(ucInViewCfg4, 4);

          return Ret;
      }
      private bool ValidaParametrosInview(ucInViewCfg lucInViewCfg,short NumInview)
      {
          
          //Configuración de Inviews 
          if (string.IsNullOrEmpty(lucInViewCfg.IPAddress))
          {
              MessageBox.Show("El campo Direccion IP del Inview " + NumInview.ToString() + " es requerido.", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
              return false;
          }
          if (string.IsNullOrEmpty(lucInViewCfg.IPPort))
          {
              MessageBox.Show("El campo Puerto del Inview " + NumInview.ToString() + " es requerido.", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
              return false;
          }
          if (string.IsNullOrEmpty(lucInViewCfg.DisplayAddress))
          {
              MessageBox.Show("El campo Dirección serial del Inview " + NumInview.ToString() + " es requerido.", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
              return false;
          }
          if (string.IsNullOrEmpty(lucInViewCfg.Frecuencia))
          {
              MessageBox.Show("El campo Refrescar cada del Inview " + NumInview.ToString() + " es requerido.", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
              return false;
          }

          return true;
      }
      private void EscribeEnIni_Inview_Celdas(ref TSR_INI oIni, ucInViewCfg lucInViewCfg, ucListaCeldas lucListaCeldas,short NumInview)
      {


          oIni.EscribeValor("Inview-" + NumInview.ToString(), "NetworkAddress", lucInViewCfg.IPAddress);
          oIni.EscribeValor("Inview-" + NumInview.ToString(), "NetworkPort", lucInViewCfg.IPPort);
          oIni.EscribeValor("Inview-" + NumInview.ToString(), "DisplayAddress", lucInViewCfg.DisplayAddress);
          oIni.EscribeValor("Inview-" + NumInview.ToString(), "Frecuencia", lucInViewCfg.Frecuencia);

          //Configuración de Celdas
          int i = 0;
          if (lucListaCeldas.Celdas.Items.Count > 0)
          {
              oIni.EscribeValor("Celdas-" + NumInview.ToString() , "Cantidad", lucListaCeldas.Celdas.Items.Count.ToString());
              for (i = 0; i < lucListaCeldas.Celdas.Items.Count; i++)
                  oIni.EscribeValor("Celdas-" + NumInview.ToString(), "Celda_" + i.ToString(), lucListaCeldas.Celdas.Items[i].Text);
          }
      }

      private void btnCancelar_Click(object sender, EventArgs e)
      {
         this.Close();
      }

      private void frmConfigurar_FormClosed(object sender, FormClosedEventArgs e)
      {
         //se desconecta de la base de datos
         if (Conectado)
            oDB.DBDesconectar();
         oDB=null;
      }

      private void btnProbar_Click(object sender, EventArgs e)
      {
         //se desconecta
         if (Conectado) oDB.DBDesconectar();

         //Establece parámetros de conexión
         oDB.DBIniParam(txtSVR_Origen.Text, txtDB_Origen.Text, txtUID_Origen.Text, txtPWD_Origen.Text);

         //intenta conectarse
         Cursor.Current=Cursors.WaitCursor;
         if (Conectado=oDB.DBConectar())
         {
            //refresca celdas
            foreach (ListViewItem item in ucListaCeldas1.Celdas.Items)
               item.SubItems[1].Text=(string)oDB.DBQryDato("SELECT sDescription FROM OEEConfigWorkcell WHERE lOEELineId="+item.Text);
            foreach (ListViewItem item in ucListaCeldas2.Celdas.Items)
               item.SubItems[1].Text=(string)oDB.DBQryDato("SELECT sDescription FROM OEEConfigWorkcell WHERE lOEELineId="+item.Text);
            foreach (ListViewItem item in ucListaCeldas3.Celdas.Items)
               item.SubItems[1].Text = (string)oDB.DBQryDato("SELECT sDescription FROM OEEConfigWorkcell WHERE lOEELineId=" + item.Text);
            foreach (ListViewItem item in ucListaCeldas4.Celdas.Items)
               item.SubItems[1].Text = (string)oDB.DBQryDato("SELECT sDescription FROM OEEConfigWorkcell WHERE lOEELineId=" + item.Text);

            Cursor.Current=Cursors.Default;
            MessageBox.Show("Conexión exitosa", "Prueba correcta", MessageBoxButtons.OK, MessageBoxIcon.Information);
         }
         else
         {
            Cursor.Current=Cursors.Default;
            MessageBox.Show("No se pudo conectar a la base de datos. \nLa pestaña 'Celdas' no se mostrará correctamente", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
         }
      }

   }
}