using System;
using System.IO.Ports;
using System.Threading;
using System.Windows.Forms;
using LiftBoxApp.Datasets;
using LiftBoxApp.Datasets.LiftBoxDSTableAdapters;
using LiftBoxApp.Datasets.SapPPTableAdapters;


namespace LiftBoxApp
{
   public partial class frmMain : Form
   {
      SerialPort _port;
      bool _depurado;
      bool _seguirEscuchando;
      Thread _readThread;

      public frmMain()
      {
         InitializeComponent();
         _seguirEscuchando = false;
         _depurado = false;
         _readThread = new Thread(EscuchaPuerto);
      }

      private void frmMain_Load(object sender, EventArgs e)
      {
         //Se conecta a RSLinx
         if (AbrePuertoSerial())
         {
            SetControlVisible(uxLinxErrorIcon,false);
            SetControlVisible(uxLinxOKIcon, true);
         }
         else
         {
            SetControlVisible(uxLinxErrorIcon, true);
            SetControlVisible(uxLinxOKIcon, false);
         }

 
         //Activa el timer
         timerTransfiereSAP.Enabled = true;
         timerTransfiereSAP.Start();

      }

      private void ProcesaMensaje(string mensaje)
      {
         //Separa el mensaje en variables
         string[] variables=mensaje.Split(new char[] {','}, StringSplitOptions.None);
         if (variables.Length == 9)
         {
            string bala = variables[0];
            string fechaProduccion = variables[1];
            string masaBruta = variables[2];
            string masaNeta = variables[3];
            string horaProduccion = variables[4];
            string cveEstadoBala = variables[5];
            string numLinea = variables[6];
            string cveLote = variables[7];
            string cvePlantaOrigen = variables[8];

            //Primero Refresca Controles en pantalla
            SetControlText(uxBala, bala);
            SetControlText(uxFecha, fechaProduccion);
            SetControlText(uxMasaBruta, masaBruta);
            SetControlText(uxMasaNeta, masaNeta);
            SetControlText(uxHora, horaProduccion);
            SetControlText(uxCveEdoBala, cveEstadoBala);
            SetControlText(uxLinea, numLinea);
            SetControlText(uxLote, cveLote);
            SetControlText(uxPlanta, cvePlantaOrigen); 

            //Inserta Muestra en DB
            ProduccionTableAdapter ProdTA = new ProduccionTableAdapter();
            DateTime fechaHoraProd;
            if (!DateTime.TryParseExact(fechaProduccion + " " + horaProduccion, "dd-MMM-yy HH:mm:ss"
                                       , new System.Globalization.CultureInfo("es-MX")
                                       , System.Globalization.DateTimeStyles.AssumeLocal
                                       , out fechaHoraProd))
            {
               fechaHoraProd = DateTime.Now;
            }

            try
            {
               ProdTA.InsertBala(bala,
                                 fechaHoraProd,
                                 double.Parse(masaBruta),
                                 double.Parse(masaNeta),
                                 cveEstadoBala,
                                 int.Parse(numLinea),
                                 cveLote,
                                 int.Parse(cvePlantaOrigen),
                                 0);
               SetControlVisible(uxBufferIcon, true);

            }
            catch (Exception ex)
            {
               AddErrorToList("No se pudo registrar la bala. " + ex.Message);
            }
         }
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

      private string LimpiaString(string str)
      {
         string ret = "";
         char[] arry=str.ToCharArray();

         for (int i = 0; i < arry.Length; i++)
         {
            if (!Char.IsControl(arry[i]))
               ret += arry[i];
         }
         return ret;
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

            if (uxErrorList.Items.Count >= 100)
               uxErrorList.Items.RemoveAt(99);
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




      private bool AbrePuertoSerial()
      {
         bool ok = false;
         _port = new SerialPort(Properties.Settings.Default.PuertoCom, 9600, Parity.None, 8, StopBits.One);
         _port.Handshake = Handshake.None;
         _port.NewLine = ""+(char)16; // Char(16) o 0x10 es DLE (Data Link Escape) y es el que viene al final de
                                      // cada mensaje que manda el PLC5
         _port.ReadTimeout = 500;

         if (!_port.IsOpen)
         {
            try
            {
               _port.Open();
               ok = true;
            }
            catch (Exception ex)
            {
              AddErrorToList("Error al abrir el puerto: " + ex.Message);
            }
         }
         else
         {
            AddErrorToList("El Puerto ya está abierto!");
         }

         if (ok)
         {
            _seguirEscuchando = true;
            _readThread.Start();
         }


         return ok;
      }

      private void EscuchaPuerto()
      {
         string mensaje = "";
         while (_seguirEscuchando)
         {
            //Ya llegó algo?
            if (_port.BytesToRead > 0)
            {
               try
               {
                  mensaje = _port.ReadLine();
               }
               catch (TimeoutException ex)
               {
                  mensaje = "";
               }
               catch (Exception ex)
               {
                  AddErrorToList(ex.Message);
                  mensaje = "";
               }
               //mensaje = mensaje.Substring(1); //descarta el primer carácter (Chr(2)= STX-Start Of Text)
               mensaje = LimpiaString(mensaje);
               if (mensaje != "")
               {
                  //AddErrorToList(mensaje);
                  ProcesaMensaje(mensaje);
                  mensaje="";
               }
            }
            Thread.Sleep(100);
         }
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
            _seguirEscuchando = false;
            if (_readThread.IsAlive)
               _readThread.Join();
            if (_port.IsOpen) _port.Close();
            _port.Dispose();
         }
      }
   }
}
