using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;

using Teseracto.IniFiles;
using Teseracto.Data;
using Oracle.DataAccess.Client;
using Oracle.DataAccess.Types;



namespace SrvControlPanel
{
   public partial class frmCfgSyncSIMSvc : Form
   {
      private string IniFileName;
      private RadioButton[] optNivelLog=new RadioButton[4];
      private TSR_INI oIni;
      private TSR_DB oDB;
      private TSR_ORA DBOra;
      private const int KEY=8;
      private bool Conectado=false;
      private string numInviews;

      public frmCfgSyncSIMSvc(string pSrvExeName, string pSrvDescripcion)
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
         DBOra= new TSR_ORA();


         //Inicializa controles
         InicializaControles();
      }

      private void InicializaControles()
      {
         int nivelLog;

         //Verifica si el archivo existe
         if (!File.Exists(IniFileName))
         {
            MessageBox.Show("No de encontró el archivo INI correspondiente. \nSe cargarán los valores predeterminados", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
         }

         /* Lee parámetros del archivo INI */
         //Intervalo de Análisis
         txtFrecuencia.Value = int.Parse(oIni.ObtenValor("Parametros", "Frecuencia", "5"));
         //Nivel de detalle de log
         nivelLog=int.Parse(oIni.ObtenValor("Parametros", "DetalleLog", "2"));
         optNivelLog[nivelLog].Checked=true;
         //Días de Log
         txtDiasLog.Value= int.Parse(oIni.ObtenValor("Parametros", "DiasLog", "7"));

         //DB Primaria
         txtSVR_Origen.Text = oIni.ObtenValor("ConexionDB", "Server", "");
         txtDB_Origen.Text = oIni.ObtenValor("ConexionDB", "DataBase", "");
         txtUID_Origen.Text = oIni.ObtenValor("ConexionDB", "User", "");
         txtPWD_Origen.Text = oIni.Desencripta(oIni.ObtenValor("ConexionDB", "Password", ""), KEY);

         //DB Secundaria
         txtSVR_Oracle.Text = oIni.ObtenValor("ConexionDB_2", "Server", "");
         //txtDB_Oracle.Text = oIni.ObtenValor("ConexionDB_2", "DataBase", "");
         txtUID_Oracle.Text = oIni.ObtenValor("ConexionDB_2", "User", "");
         txtPWD_Oracle.Text = oIni.Desencripta(oIni.ObtenValor("ConexionDB_2", "Password", ""), KEY);

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
            lbOk = true;

         if (!lbOk) tabControl1.SelectTab(1);

         //Escribe los valores en el archivo INI y cierra la ventana.
         if (lbOk)
         {
            //Frecuencia
            oIni.EscribeValor("Parametros", "Frecuencia", txtFrecuencia.Value.ToString());

            //Nivel de detalle de log
            for (i = 0; i < 4; i++)
               if (optNivelLog[i].Checked)
                  oIni.EscribeValor("Parametros", "DetalleLog", i.ToString());

            //Dias de Log
            oIni.EscribeValor("Parametros", "DiasLog", txtDiasLog.Value.ToString());

            //DB Primaria
            oIni.EscribeValor("ConexionDB", "Server", txtSVR_Origen.Text);
            oIni.EscribeValor("ConexionDB", "DataBase", txtDB_Origen.Text);
            oIni.EscribeValor("ConexionDB", "User", txtUID_Origen.Text);
            oIni.EscribeValor("ConexionDB", "Password", oIni.Encripta(txtPWD_Origen.Text, KEY));

            //DB Secundaria
            oIni.EscribeValor("ConexionDB_2", "Server", txtSVR_Oracle.Text);
            //oIni.EscribeValor("ConexionDB_2", "DataBase", txtDB_Oracle.Text);
            oIni.EscribeValor("ConexionDB_2", "User", txtUID_Oracle.Text);
            oIni.EscribeValor("ConexionDB_2", "Password", oIni.Encripta(txtPWD_Oracle.Text, KEY));


            this.Close();
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
            Cursor.Current=Cursors.Default;
            MessageBox.Show("Conexión exitosa", "Prueba correcta", 
                            MessageBoxButtons.OK, MessageBoxIcon.Information);
         }
         else
         {
            Cursor.Current=Cursors.Default;
            MessageBox.Show("No se pudo conectar a la base de datos. \n"+
                            "Revise los parámetros de conexión.\n\n"+
                            oDB.sError, "Advertencia", 
                            MessageBoxButtons.OK, MessageBoxIcon.Warning);
         }
      }


      private void btnProbar2_Click(object sender, EventArgs e)
      {
         //Establece parámetros de conexión
         DBOra.DBIniParam(txtSVR_Oracle.Text, txtUID_Oracle.Text, txtPWD_Oracle.Text);

         //intenta conectarse
         Cursor.Current=Cursors.WaitCursor;
         if (DBOra.DBConectar())
         {
            DBOra.DBDesconectar();
            Cursor.Current=Cursors.Default;
            MessageBox.Show("Conexión exitosa", "Prueba correcta", MessageBoxButtons.OK, MessageBoxIcon.Information);
         }
         else
         {
            Cursor.Current=Cursors.Default;
            MessageBox.Show("No se pudo conectar a la base de datos. \n"+
                            "Revise los parámetros de conexión.\n\n"+
                            DBOra.sError, "Advertencia",
                            MessageBoxButtons.OK, MessageBoxIcon.Warning);
         }
      }

   }
}