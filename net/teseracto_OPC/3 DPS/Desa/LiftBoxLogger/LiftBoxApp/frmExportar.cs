using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using LiftBoxApp.Datasets;
using LiftBoxApp.Datasets.LiftBoxDSTableAdapters;

namespace LiftBoxApp
{
   public partial class frmExportar : Form
   {
      public frmExportar()
      {
         InitializeComponent();
      }

      private void btnCancelar_Click(object sender, EventArgs e)
      {
         this.Close();
      }

      private void frmExportar_Load(object sender, EventArgs e)
      {
         int cuantos=0;
         ProduccionTableAdapter prodTA = new ProduccionTableAdapter();
         cuantos=(int)prodTA.BalasPorEnviar();
         uxRegistrosSinEnviar.Text = cuantos.ToString("###,##0");
      }

      private void btnExportar_Click(object sender, EventArgs e)
      {
         saveFileDialog1.DefaultExt = ".txt";
         saveFileDialog1.FileName = "Balas-" + DateTime.Now.ToString("yyMMdd-HHmm")+".txt";
         saveFileDialog1.OverwritePrompt = true;
         DialogResult res=saveFileDialog1.ShowDialog();
         if (res == DialogResult.OK)
         {
            ExportaArchivo(saveFileDialog1.FileName);
         }

         res = MessageBox.Show("¿Desea ver el archivo generado?", "Exportación terminada!",MessageBoxButtons.YesNo,MessageBoxIcon.Information);
         if (res==DialogResult.Yes)
            System.Diagnostics.Process.Start("explorer.exe", "/select,\"" + saveFileDialog1.FileName + "\"");
         this.Close();
      }

      private void ExportaArchivo(string fileName)
      {
         ProduccionTableAdapter prodTA = new ProduccionTableAdapter();
         LiftBoxDS.ProduccionDataTable prodDT;

         Stream str = File.Open(fileName, FileMode.Create, FileAccess.Write);
         StreamWriter sw = new StreamWriter(str);

         prodDT = prodTA.GetDataByEnviado(0);
         foreach (LiftBoxDS.ProduccionRow row in prodDT.Rows)
         {
            sw.WriteLine("{0},{1},{2},{3},{4},{5},{6},{7},{8}",
                         row.NumBala,
                         row.FechaHora.ToString("dd-MM-yy"),
                         row.MasaBruta,
                         row.MasaNeta,
                         row.FechaHora.ToString("HH:mm:ss"),
                         row.CveEstadoBala, 
                         row.NumLinea,
                         row.CveLote,
                         row.CvePlantaOrigen);
            //lo marca como exportado (Enviado=2)
            prodTA.SetEnviado(2, row.Folio);
         }

         sw.Flush();
         str.Flush();
         sw.Close();
         str.Close();
      }
   }
}
