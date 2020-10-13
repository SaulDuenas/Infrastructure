using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace SrvControlPanel
{
   public partial class frmAvance : Form
   {
      bool mCancelar;

      public frmAvance()
      {
         InitializeComponent();
         mCancelar=false;
      }


      public void SetAvance(long mensajes, long porcentaje, out bool cancelar)
      {
         lblMensajes.Text=mensajes.ToString("###,###,###,###");
         progressBar1.Value=(int)porcentaje;
         lblPorcentaje.Text=porcentaje.ToString()+"%";
         cancelar=mCancelar;
         this.Refresh();
         System.Threading.Thread.Sleep(0);
      }

      private void btnDetener_Click(object sender, EventArgs e)
      {
         mCancelar=true;
      }
   }
}