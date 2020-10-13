using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Teseracto.OpcClient;
using LiftBoxApp.Datasets;
using LiftBoxApp.Datasets.LiftBoxDSTableAdapters;
using LiftBoxApp.Datasets.SapPPTableAdapters;


namespace LiftBoxApp
{
   public partial class frmMain : Form
   {
      TSR_OPC _opcClient;
      Grupo _gpoTriggers;
      Grupo _gpoDatos;
      bool _primerEvento;
      bool _reiniciarLinx;
      int _watchDogLinx;
      bool _depurado;

      public frmMain()
      {
         InitializeComponent();
         _opcClient = new TSR_OPC();
         _primerEvento = true;
         _reiniciarLinx = false;
         _watchDogLinx = 0;
         _depurado = false;
      }

      private void frmMain_Load(object sender, EventArgs e)
      {
         //Se conecta a RSLinx
         if (_opcClient.Conectar("RSLinx OPC Server"))
         {
            SetControlVisible(uxLinxErrorIcon,false);
            SetControlVisible(uxLinxOKIcon, true);
         }
         else
         {
            SetControlVisible(uxLinxErrorIcon, true);
            SetControlVisible(uxLinxOKIcon, false);
         }

         // crea dos grupos
         _gpoTriggers = _opcClient.CrearGrupo("Triggers", 250);
         _gpoDatos = _opcClient.CrearGrupo("Datos", 1000);

         //Lee los tags de la DB
         LiftBoxDS.TagsDataTable tagsDT = new LiftBoxDS.TagsDataTable();
         TagsTableAdapter tagsTA = new TagsTableAdapter();
         tagsTA.Fill(tagsDT);

         //Recorre la lista y mete los tags a sus grupos
         foreach (LiftBoxDS.TagsRow tag in tagsDT.Rows)
         {
            switch (tag.Grupo)
            {
               case "Triggers":
                  _gpoTriggers.AgregarTag(tag.Topico, tag.Nombre, tag.TagPath);
                  break;
               case "Datos":
                  _gpoDatos.AgregarTag(tag.Topico, tag.Nombre, tag.TagPath);
                  break;
               default:
                  break;
            }
         }

         //Establece los EventHandlers
         _gpoDatos.GrupoActualizado += new GrupoActualizadoDelegate(Datos_GrupoActualizado);
         _gpoTriggers.GrupoActualizado += new GrupoActualizadoDelegate(Triggers_GrupoActualizado);
         _opcClient.OpcServerTerminado += new TSR_OPC.OpcServerTerminadoDelegate(opcClient_OpcServerTerminado);

         //Activa los grupos
         _gpoDatos.Activo = true;
         _gpoTriggers.Activo = true;

         //Activa el timer
         timerTransfiereSAP.Enabled = true;
         timerTransfiereSAP.Start();

      }

      void opcClient_OpcServerTerminado(string motivo)
      {
         AddErrorToList("RSLinx se detuvo: " + motivo + ". Intentando abrirlo de nuevo...");
         _reiniciarLinx = true;

         SetControlVisible(uxLinxErrorIcon, true);
         SetControlVisible(uxLinxOKIcon, false);
      }

      void Triggers_GrupoActualizado(string nombreGrupo, List<DataPoint> datapoints)
      {

         foreach (DataPoint p in datapoints)
         {
            //Primero, refresca el control en pantalla
            RefrescaControl(p);
            if (!_primerEvento)
            {
               switch (p.Nombre)
               {
                  case "Activa":
                     if ((short)p.Valor == 1)
                     {
                        //Refresca tags del grupo Síncronamente
                        _gpoDatos.Leer();
                        //Inserta la muestra en la base de datos
                        InsertaMuestra();
                     }
                     break;
                  case "Segundo":
                     //Resetea Watchdog
                     _watchDogLinx = 0;
                     break;
                  default:
                     break;
               }
            }
            else
            {
               //Si es el primer evento, no hace nada, solo marca que ya ocurrió.
               _primerEvento = false;
            }
         }
      }

      private void InsertaMuestra()
      {
         ProduccionTableAdapter ProdTA = new ProduccionTableAdapter();
         try
         {
            string bala = ValorOpcToString(_gpoDatos.DataPoints.First(x => x.Nombre == "Bala").Valor);
            int linea = int.Parse(bala.Substring(2, 1));
            ProdTA.InsertBala(bala,
                              DateTime.Now,
                              double.Parse(ValorOpcToString(_gpoDatos.DataPoints.First(x => x.Nombre == "MasaBruta").Valor)),
                              double.Parse(ValorOpcToString(_gpoDatos.DataPoints.First(x => x.Nombre == "MasaNeta").Valor)),
                              "1", linea,
                              int.Parse(ValorOpcToString(_gpoDatos.DataPoints.First(x => x.Nombre == "Lote").Valor)).ToString(),
                              1, 0);
            SetControlVisible(uxBufferIcon, true);

         }
         catch (Exception ex)
         {
            AddErrorToList("No se pudo registrar la bala. " + ex.Message);
         }
      }

      void Datos_GrupoActualizado(string nombreGrupo, List<DataPoint> datapoints)
      {
         if (nombreGrupo == "Datos")
         {
            foreach (DataPoint p in datapoints)
            {
               RefrescaControl(p);
            }
         }
      }

      private void RefrescaControl(DataPoint p)
      {
         //Refresca controles en pantalla
         Control[] ctls = this.Controls.Find("ux" + p.Nombre, true);
         if (ctls.Length > 0)
            SetControlText(ctls[0], p.Valor);
      }


      //Poner texto en controles de manera Thread-Safe.
      delegate void SetTextDelegate(Control ctl, object valor);
      private void SetControlText(Control ctl, object valor)
      {
         if (ctl.InvokeRequired)
         {
            SetTextDelegate d = new SetTextDelegate(SetControlText);
            this.Invoke(d, new object[] { ctl, valor });
         }
         else
         {
            ctl.Text = ValorOpcToString(valor);
         }
      }

      private string ValorOpcToString(object valor)
      {
         string texto = "";
         if (valor.GetType().IsArray)
         {
            char c;
            short[] arreglo = (short[])valor;
            for (int i = 0; i < arreglo.Length; i++)
            {
               c = (char)((arreglo[i] & 0xFF00) >> 8);
               texto += char.IsControl(c) ? "" : c.ToString();
               c = (char)(arreglo[i] & 0x00FF);
               texto += char.IsControl(c) ? "" : c.ToString();
            }
         }
         else
         {
            texto = valor.ToString();
         }
         return texto;
      }



      //Poner texto en controles de manera Thread-Safe.
      delegate void AddErrorToListDelegate(string texto);
      private void AddErrorToList(string texto)
      {
         if (uxErrorList.InvokeRequired)
         {
            AddErrorToListDelegate d = new AddErrorToListDelegate(AddErrorToList);
            this.Invoke(d, new object[] { texto });
         }
         else
         {
            if (uxErrorList.Items.Count == 0)
               uxErrorList.Items.Add(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss  ") + texto);
            else
               uxErrorList.Items.Insert(0, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss  ") + texto);

            if (uxErrorList.Items.Count >= 10)
               uxErrorList.Items.RemoveAt(9);
         }
      }


      //Modificar visibilidad thread-safe
      delegate void SetControlVisibleDelegate(Control ctl, bool visible);
      private void SetControlVisible(Control ctl, bool visible)
      {
         if (ctl.InvokeRequired)
         {
            SetControlVisibleDelegate d = new SetControlVisibleDelegate(SetControlVisible);
            this.Invoke(d, new object[] { ctl, visible });
         }
         else
         {
            ctl.Visible = visible;
         }
      }


      //Transfiere a SAP
      private void timerTransfiereSAP_Tick(object sender, EventArgs e)
      {
         bool ok = true;
         ProduccionTableAdapter prodTA = new ProduccionTableAdapter();
         BalaTableAdapter balaTA = new BalaTableAdapter();

         //Obtiene todos los registros no enviados
         LiftBoxDS.ProduccionDataTable ProdDT = prodTA.GetDataByEnviado(0);

         //Los recorre uno a uno
         foreach (LiftBoxDS.ProduccionRow row in ProdDT.Rows)
         {
            try
            {
               //lo envía a Sap
               balaTA.InsertaBala(double.Parse(row.NumBala), row.FechaHora.Date, row.MasaBruta, row.MasaNeta,
                                  DateTime.Parse("2001-01-01").Add(row.FechaHora.TimeOfDay),
                                  decimal.Parse(row.CveEstadoBala), row.NumLinea, row.CveLote, row.CvePlantaOrigen);
               ok = true;
            }
            catch (Exception ex)
            {
               ok = false;
               AddErrorToList("No se pudo enviar la bala " + row.NumBala + ". " + ex.Message);
               if (ex.Message.StartsWith("Violation of PRIMARY KEY constraint"))
                  prodTA.SetEnviado(3, row.Folio); //lo marca como descartado (Enviado=3)
            }

            if (ok)
            {
               //lo marca como enviado
               prodTA.SetEnviado(1, row.Folio);
            }

         }
         //Muestra u oculta el icono del buffer
         SetControlVisible(uxBufferIcon, prodTA.BalasPorEnviar() > 0);
      }

      private void uxErrorList_MouseDoubleClick(object sender, MouseEventArgs e)
      {
         MessageBox.Show(uxErrorList.SelectedItem.ToString(), "Detalle del error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
      }

      private void frmMain_FormClosing(object sender, FormClosingEventArgs e)
      {
         if (e.CloseReason == CloseReason.UserClosing)
         {
            e.Cancel = true;
            System.Media.SystemSounds.Beep.Play();
         }
         else
         {
            timerTransfiereSAP.Enabled = false;
            _gpoTriggers.Activo = false;
            _gpoDatos.Activo = false;
            _gpoTriggers.GrupoActualizado -= Triggers_GrupoActualizado;
            _gpoDatos.GrupoActualizado -= Datos_GrupoActualizado;
         }
      }

      private void salirYTerminarAdquisiciónToolStripMenuItem_Click(object sender, EventArgs e)
      {
         DialogResult res = MessageBox.Show("Si cierra esta aplicación se dejará de registrar la producción.\n\n" +
                                            "¿Esta seguro que desea salir y terminar la aplicación?", "Confirmar salida",
                                            MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation);
         if (res == DialogResult.Yes)
         {
            Application.Exit();
         }
      }

      private void exportarRegistrosToolStripMenuItem_Click(object sender, EventArgs e)
      {
         frmExportar frm = new frmExportar();
         frm.ShowDialog();
      }

      private void timerReconectaLinx_Tick(object sender, EventArgs e)
      {
         if (_reiniciarLinx)
         {
            _primerEvento = true;
            if (_opcClient.Reconectar())
            {
               _reiniciarLinx = false;
               AddErrorToList("Reconectado a RSLinx!");
               SetControlVisible(uxLinxErrorIcon, false);
               SetControlVisible(uxLinxOKIcon, true);
            }
            else
            {
               AddErrorToList("No se pudo reconectar a RSLinx. Por favor verifique que se está ejecutando");
               SetControlVisible(uxLinxErrorIcon, true);
               SetControlVisible(uxLinxOKIcon, false);
            }
         }

         //incrementa watchdog
         _watchDogLinx = _watchDogLinx + timerReconectaLinx.Interval;
         if (_watchDogLinx >= 40000)
         {
            _reiniciarLinx = true;
            _watchDogLinx = 0;
         }
      }

      private void btnLimpiar_Click(object sender, EventArgs e)
      {
         uxErrorList.Items.Clear();
      }

      private void timerDepura_Tick(object sender, EventArgs e)
      {
         DateTime now=DateTime.Now;
         if (now.Hour == 6 && now.Minute == 0 && !_depurado)
         {
            ProduccionTableAdapter TA = new ProduccionTableAdapter();
            try
            {
               TA.Depura();
               _depurado = true;
            }
            catch (Exception ex)
            {
               AddErrorToList("No se pudo hacer la depuración a la base de datos. " + ex.Message);
            }
         }
         else
         {
            _depurado = false;
         }
      }

   }
}
