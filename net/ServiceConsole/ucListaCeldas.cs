using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using Teseracto.Data;

namespace SrvControlPanel
{
   public partial class ucListaCeldas : UserControl
   {
      private TSR_DB moDB;

      #region Propiedades del control
      public ListView Celdas
      {
         get { return lvCeldas; }
      }
      public TSR_DB oDB
      {
         set { moDB=value; }
      }
      #endregion


      public ucListaCeldas()
      {
         InitializeComponent();
      }


      private void btnAgregar_Click(object sender, EventArgs e)
      {
         ListViewItem newItem;
         string CeldasExistentes="";

         //Obtiene la lista de las celdas existentes
         foreach (ListViewItem item in lvCeldas.Items)
            CeldasExistentes+=","+item.Text;
         if (CeldasExistentes!="") CeldasExistentes=CeldasExistentes.Substring(1);

         Cursor.Current=Cursors.WaitCursor;
         if (moDB.DBConectar())
         {
            frmSelCelda frm = new frmSelCelda(moDB);
            foreach (ListViewItem item in frm.AgregaCeldas(CeldasExistentes))
            {
               newItem=lvCeldas.Items.Add(item.Text, item.ImageKey);
               newItem.SubItems.Add(item.SubItems[1]);
            }
            frm = null;
            moDB.DBDesconectar();
            Cursor.Current=Cursors.Default;
         }
         else
         {
            MessageBox.Show("No se pudo conectar a la base de datos. \nRevise los datos de conexión a base de datos e intente de nuevo", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            Cursor.Current=Cursors.Default;
         }
      }

      private void btnQuitar_Click(object sender, EventArgs e)
      {
         foreach (ListViewItem listItem in lvCeldas.SelectedItems)
            lvCeldas.Items.Remove(listItem);
      }

   }
}
