using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using Teseracto.Data;


namespace SrvControlPanel
{
   public partial class frmSelCelda : Form
   {
      private TSR_DB oDB;
      private bool mOK;

      public frmSelCelda(TSR_DB poDB)
      {
         InitializeComponent();
         oDB=poDB;
         mOK=false;
      }

      public ListView.SelectedListViewItemCollection AgregaCeldas(string CeldasExistentes)
      {
         string lsQry;
         SqlDataReader drCeldas;
         ListViewItem listItem;
          try
          {
              /* Llena el listview */
              //Arma el query
              lsQry = "SELECT lOEELineId,sDescription" +
                    "  FROM SEY_Metrics.dbo.OEEConfigWorkcell" +
                    " WHERE nType=12";
              if (CeldasExistentes != "")
                  lsQry += " AND lOEELineId NOT IN (" + CeldasExistentes + ")";
              lsQry += " ORDER BY sDescription";

              //Ejecuta el Query
              SqlCommand loCmd = new SqlCommand(lsQry, oDB.oCnn);
              drCeldas = loCmd.ExecuteReader();

              //llena el listview
              lvCeldas.Items.Clear();
              while (drCeldas.Read())
              {
                  listItem = lvCeldas.Items.Add(drCeldas["lOEELineId"].ToString(), "Celda");
                  listItem.SubItems.Add((string)drCeldas["sDescription"]);
              }
              drCeldas.Close();


              //Muestra el formulario
              this.ShowDialog();

          }
           catch( Exception e)
          {
              MessageBox.Show("Error al tratar de obtener las celdas:  " + e.Message , Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error );             
          }

         //Regresa las celdas seleccionadas
         return lvCeldas.SelectedItems;
      }

      private void btnAceptar_Click(object sender, EventArgs e)
      {
         mOK=true;
         this.Hide();
      }

      private void btnCancelar_Click(object sender, EventArgs e)
      {
         //limpia la seleccion para devolver conjunto vacío
         lvCeldas.Items.Clear();
         lvCeldas.Refresh();
         mOK=false;
         this.Hide();
      }

       private void frmSelCelda_Load(object sender, EventArgs e)
       {

       }
   }
}