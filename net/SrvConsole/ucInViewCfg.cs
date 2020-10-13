using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;

namespace SrvControlPanel
{
   public partial class ucInViewCfg : UserControl
   {
      #region Propiedades del control
      public string IPAddress
      {
         get { return txtIPAddress.Text; }
         set { txtIPAddress.Text = value; }
      }

      public string IPPort
      {
         get { return txtIPPort.Text; }
         set { txtIPPort.Text = value; }
      }

      public string DisplayAddress
      {
         get { return txtDisplayAddress.Text; }
         set { txtDisplayAddress.Text = value; }
      }

      public string Frecuencia
      {
         get { return txtFrecuencia.Text; }
         set { txtFrecuencia.Text = value; }
      }


      #endregion


      public ucInViewCfg()
      {
         InitializeComponent();
      }
    
   }
}
