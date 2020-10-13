namespace LiftBoxApp
{
   partial class frmMain
   {
      /// <summary>
      /// Required designer variable.
      /// </summary>
      private System.ComponentModel.IContainer components = null;

      /// <summary>
      /// Clean up any resources being used.
      /// </summary>
      /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
      protected override void Dispose(bool disposing)
      {
         if (disposing && (components != null))
         {
            components.Dispose();
         }
         base.Dispose(disposing);
      }

      #region Windows Form Designer generated code

      /// <summary>
      /// Required method for Designer support - do not modify
      /// the contents of this method with the code editor.
      /// </summary>
      private void InitializeComponent()
      {
         this.components = new System.ComponentModel.Container();
         System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmMain));
         this.label1 = new System.Windows.Forms.Label();
         this.groupBox1 = new System.Windows.Forms.GroupBox();
         this.uxTipo = new System.Windows.Forms.TextBox();
         this.uxLote = new System.Windows.Forms.TextBox();
         this.uxProducto = new System.Windows.Forms.TextBox();
         this.label5 = new System.Windows.Forms.Label();
         this.label4 = new System.Windows.Forms.Label();
         this.label3 = new System.Windows.Forms.Label();
         this.groupBox2 = new System.Windows.Forms.GroupBox();
         this.uxMasaNetaLbs = new System.Windows.Forms.TextBox();
         this.uxMasaNeta = new System.Windows.Forms.TextBox();
         this.uxLustre = new System.Windows.Forms.TextBox();
         this.uxMSDS = new System.Windows.Forms.TextBox();
         this.uxMasaBrutaLbs = new System.Windows.Forms.TextBox();
         this.uxMasaBruta = new System.Windows.Forms.TextBox();
         this.uxLongitud = new System.Windows.Forms.TextBox();
         this.uxCorte = new System.Windows.Forms.TextBox();
         this.label11 = new System.Windows.Forms.Label();
         this.label10 = new System.Windows.Forms.Label();
         this.uxDPF = new System.Windows.Forms.TextBox();
         this.label12 = new System.Windows.Forms.Label();
         this.uxDTex = new System.Windows.Forms.TextBox();
         this.label13 = new System.Windows.Forms.Label();
         this.label9 = new System.Windows.Forms.Label();
         this.label14 = new System.Windows.Forms.Label();
         this.label6 = new System.Windows.Forms.Label();
         this.label15 = new System.Windows.Forms.Label();
         this.label7 = new System.Windows.Forms.Label();
         this.label8 = new System.Windows.Forms.Label();
         this.groupBox4 = new System.Windows.Forms.GroupBox();
         this.uxBala = new System.Windows.Forms.TextBox();
         this.label17 = new System.Windows.Forms.Label();
         this.toolStripContainer1 = new System.Windows.Forms.ToolStripContainer();
         this.uxLinxErrorIcon = new System.Windows.Forms.PictureBox();
         this.btnLimpiar = new System.Windows.Forms.Button();
         this.uxErrorList = new System.Windows.Forms.ListBox();
         this.menuStrip1 = new System.Windows.Forms.MenuStrip();
         this.toolStripMenuItem2 = new System.Windows.Forms.ToolStripMenuItem();
         this.toolStripMenuItem4 = new System.Windows.Forms.ToolStripMenuItem();
         this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
         this.toolStripMenuItem5 = new System.Windows.Forms.ToolStripMenuItem();
         this.timerTransfiereSAP = new System.Windows.Forms.Timer(this.components);
         this.timerReconectaLinx = new System.Windows.Forms.Timer(this.components);
         this.holaToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
         this.uxLinxOKIcon = new System.Windows.Forms.PictureBox();
         this.uxBufferIcon = new System.Windows.Forms.PictureBox();
         this.uxToolTip = new System.Windows.Forms.ToolTip(this.components);
         this.timerDepura = new System.Windows.Forms.Timer(this.components);
         this.groupBox1.SuspendLayout();
         this.groupBox2.SuspendLayout();
         this.groupBox4.SuspendLayout();
         this.toolStripContainer1.ContentPanel.SuspendLayout();
         this.toolStripContainer1.TopToolStripPanel.SuspendLayout();
         this.toolStripContainer1.SuspendLayout();
         ((System.ComponentModel.ISupportInitialize)(this.uxLinxErrorIcon)).BeginInit();
         this.menuStrip1.SuspendLayout();
         ((System.ComponentModel.ISupportInitialize)(this.uxLinxOKIcon)).BeginInit();
         ((System.ComponentModel.ISupportInitialize)(this.uxBufferIcon)).BeginInit();
         this.SuspendLayout();
         // 
         // label1
         // 
         this.label1.AutoSize = true;
         this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 20.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label1.Location = new System.Drawing.Point(6, 13);
         this.label1.Name = "label1";
         this.label1.Size = new System.Drawing.Size(597, 31);
         this.label1.TabIndex = 0;
         this.label1.Text = "Adquisición y Registro de Producción LiftBox";
         // 
         // groupBox1
         // 
         this.groupBox1.Controls.Add(this.uxTipo);
         this.groupBox1.Controls.Add(this.uxLote);
         this.groupBox1.Controls.Add(this.uxProducto);
         this.groupBox1.Controls.Add(this.label5);
         this.groupBox1.Controls.Add(this.label4);
         this.groupBox1.Controls.Add(this.label3);
         this.groupBox1.Location = new System.Drawing.Point(12, 59);
         this.groupBox1.Name = "groupBox1";
         this.groupBox1.Size = new System.Drawing.Size(599, 72);
         this.groupBox1.TabIndex = 1;
         this.groupBox1.TabStop = false;
         this.groupBox1.Text = "Datos Generales";
         // 
         // uxTipo
         // 
         this.uxTipo.BackColor = System.Drawing.SystemColors.Window;
         this.uxTipo.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxTipo.Location = new System.Drawing.Point(393, 39);
         this.uxTipo.Name = "uxTipo";
         this.uxTipo.ReadOnly = true;
         this.uxTipo.Size = new System.Drawing.Size(131, 29);
         this.uxTipo.TabIndex = 5;
         this.uxTipo.Text = "ABCDEFGH";
         // 
         // uxLote
         // 
         this.uxLote.BackColor = System.Drawing.SystemColors.Window;
         this.uxLote.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxLote.Location = new System.Drawing.Point(207, 39);
         this.uxLote.Name = "uxLote";
         this.uxLote.ReadOnly = true;
         this.uxLote.Size = new System.Drawing.Size(162, 29);
         this.uxLote.TabIndex = 3;
         this.uxLote.Text = "ABCDEFGH";
         // 
         // uxProducto
         // 
         this.uxProducto.BackColor = System.Drawing.SystemColors.Window;
         this.uxProducto.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxProducto.Location = new System.Drawing.Point(23, 39);
         this.uxProducto.Name = "uxProducto";
         this.uxProducto.ReadOnly = true;
         this.uxProducto.Size = new System.Drawing.Size(149, 29);
         this.uxProducto.TabIndex = 1;
         this.uxProducto.Text = "ABCDEFGH";
         // 
         // label5
         // 
         this.label5.AutoSize = true;
         this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label5.Location = new System.Drawing.Point(390, 23);
         this.label5.Name = "label5";
         this.label5.Size = new System.Drawing.Size(36, 16);
         this.label5.TabIndex = 4;
         this.label5.Text = "Tipo";
         // 
         // label4
         // 
         this.label4.AutoSize = true;
         this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label4.Location = new System.Drawing.Point(204, 23);
         this.label4.Name = "label4";
         this.label4.Size = new System.Drawing.Size(34, 16);
         this.label4.TabIndex = 2;
         this.label4.Text = "Lote";
         // 
         // label3
         // 
         this.label3.AutoSize = true;
         this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label3.Location = new System.Drawing.Point(20, 23);
         this.label3.Name = "label3";
         this.label3.Size = new System.Drawing.Size(62, 16);
         this.label3.TabIndex = 0;
         this.label3.Text = "Producto";
         // 
         // groupBox2
         // 
         this.groupBox2.Controls.Add(this.uxMasaNetaLbs);
         this.groupBox2.Controls.Add(this.uxMasaNeta);
         this.groupBox2.Controls.Add(this.uxLustre);
         this.groupBox2.Controls.Add(this.uxMSDS);
         this.groupBox2.Controls.Add(this.uxMasaBrutaLbs);
         this.groupBox2.Controls.Add(this.uxMasaBruta);
         this.groupBox2.Controls.Add(this.uxLongitud);
         this.groupBox2.Controls.Add(this.uxCorte);
         this.groupBox2.Controls.Add(this.label11);
         this.groupBox2.Controls.Add(this.label10);
         this.groupBox2.Controls.Add(this.uxDPF);
         this.groupBox2.Controls.Add(this.label12);
         this.groupBox2.Controls.Add(this.uxDTex);
         this.groupBox2.Controls.Add(this.label13);
         this.groupBox2.Controls.Add(this.label9);
         this.groupBox2.Controls.Add(this.label14);
         this.groupBox2.Controls.Add(this.label6);
         this.groupBox2.Controls.Add(this.label15);
         this.groupBox2.Controls.Add(this.label7);
         this.groupBox2.Controls.Add(this.label8);
         this.groupBox2.Location = new System.Drawing.Point(12, 137);
         this.groupBox2.Name = "groupBox2";
         this.groupBox2.Size = new System.Drawing.Size(599, 143);
         this.groupBox2.TabIndex = 2;
         this.groupBox2.TabStop = false;
         this.groupBox2.Text = "Detalles";
         // 
         // uxMasaNetaLbs
         // 
         this.uxMasaNetaLbs.BackColor = System.Drawing.SystemColors.Window;
         this.uxMasaNetaLbs.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxMasaNetaLbs.Location = new System.Drawing.Point(482, 97);
         this.uxMasaNetaLbs.Name = "uxMasaNetaLbs";
         this.uxMasaNetaLbs.ReadOnly = true;
         this.uxMasaNetaLbs.Size = new System.Drawing.Size(100, 29);
         this.uxMasaNetaLbs.TabIndex = 19;
         this.uxMasaNetaLbs.Text = "ABCDEFGH";
         // 
         // uxMasaNeta
         // 
         this.uxMasaNeta.BackColor = System.Drawing.SystemColors.Window;
         this.uxMasaNeta.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxMasaNeta.Location = new System.Drawing.Point(482, 39);
         this.uxMasaNeta.Name = "uxMasaNeta";
         this.uxMasaNeta.ReadOnly = true;
         this.uxMasaNeta.Size = new System.Drawing.Size(100, 29);
         this.uxMasaNeta.TabIndex = 9;
         this.uxMasaNeta.Text = "ABCDEFGH";
         // 
         // uxLustre
         // 
         this.uxLustre.BackColor = System.Drawing.SystemColors.Window;
         this.uxLustre.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxLustre.Location = new System.Drawing.Point(247, 97);
         this.uxLustre.Name = "uxLustre";
         this.uxLustre.ReadOnly = true;
         this.uxLustre.Size = new System.Drawing.Size(100, 29);
         this.uxLustre.TabIndex = 15;
         this.uxLustre.Text = "ABCDEFGH";
         // 
         // uxMSDS
         // 
         this.uxMSDS.BackColor = System.Drawing.SystemColors.Window;
         this.uxMSDS.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxMSDS.Location = new System.Drawing.Point(247, 39);
         this.uxMSDS.Name = "uxMSDS";
         this.uxMSDS.ReadOnly = true;
         this.uxMSDS.Size = new System.Drawing.Size(100, 29);
         this.uxMSDS.TabIndex = 5;
         this.uxMSDS.Text = "ABCDEFGH";
         // 
         // uxMasaBrutaLbs
         // 
         this.uxMasaBrutaLbs.BackColor = System.Drawing.SystemColors.Window;
         this.uxMasaBrutaLbs.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxMasaBrutaLbs.Location = new System.Drawing.Point(364, 97);
         this.uxMasaBrutaLbs.Name = "uxMasaBrutaLbs";
         this.uxMasaBrutaLbs.ReadOnly = true;
         this.uxMasaBrutaLbs.Size = new System.Drawing.Size(100, 29);
         this.uxMasaBrutaLbs.TabIndex = 17;
         this.uxMasaBrutaLbs.Text = "ABCDEFGH";
         // 
         // uxMasaBruta
         // 
         this.uxMasaBruta.BackColor = System.Drawing.SystemColors.Window;
         this.uxMasaBruta.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxMasaBruta.Location = new System.Drawing.Point(364, 39);
         this.uxMasaBruta.Name = "uxMasaBruta";
         this.uxMasaBruta.ReadOnly = true;
         this.uxMasaBruta.Size = new System.Drawing.Size(100, 29);
         this.uxMasaBruta.TabIndex = 7;
         this.uxMasaBruta.Text = "ABCDEFGH";
         // 
         // uxLongitud
         // 
         this.uxLongitud.BackColor = System.Drawing.SystemColors.Window;
         this.uxLongitud.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxLongitud.Location = new System.Drawing.Point(138, 97);
         this.uxLongitud.Name = "uxLongitud";
         this.uxLongitud.ReadOnly = true;
         this.uxLongitud.Size = new System.Drawing.Size(100, 29);
         this.uxLongitud.TabIndex = 13;
         this.uxLongitud.Text = "ABCDEFGH";
         // 
         // uxCorte
         // 
         this.uxCorte.BackColor = System.Drawing.SystemColors.Window;
         this.uxCorte.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxCorte.Location = new System.Drawing.Point(138, 39);
         this.uxCorte.Name = "uxCorte";
         this.uxCorte.ReadOnly = true;
         this.uxCorte.Size = new System.Drawing.Size(100, 29);
         this.uxCorte.TabIndex = 3;
         this.uxCorte.Text = "ABCDEFGH";
         // 
         // label11
         // 
         this.label11.AutoSize = true;
         this.label11.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label11.Location = new System.Drawing.Point(479, 81);
         this.label11.Name = "label11";
         this.label11.Size = new System.Drawing.Size(100, 16);
         this.label11.TabIndex = 18;
         this.label11.Text = "Masa Neta (Lb)";
         // 
         // label10
         // 
         this.label10.AutoSize = true;
         this.label10.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label10.Location = new System.Drawing.Point(480, 23);
         this.label10.Name = "label10";
         this.label10.Size = new System.Drawing.Size(101, 16);
         this.label10.TabIndex = 8;
         this.label10.Text = "Masa Neta (Kg)";
         // 
         // uxDPF
         // 
         this.uxDPF.BackColor = System.Drawing.SystemColors.Window;
         this.uxDPF.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxDPF.Location = new System.Drawing.Point(23, 97);
         this.uxDPF.Name = "uxDPF";
         this.uxDPF.ReadOnly = true;
         this.uxDPF.Size = new System.Drawing.Size(100, 29);
         this.uxDPF.TabIndex = 11;
         this.uxDPF.Text = "ABCDEFGH";
         // 
         // label12
         // 
         this.label12.AutoSize = true;
         this.label12.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label12.Location = new System.Drawing.Point(362, 81);
         this.label12.Name = "label12";
         this.label12.Size = new System.Drawing.Size(102, 16);
         this.label12.TabIndex = 16;
         this.label12.Text = "Masa Bruta (Lb)";
         // 
         // uxDTex
         // 
         this.uxDTex.BackColor = System.Drawing.SystemColors.Window;
         this.uxDTex.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxDTex.Location = new System.Drawing.Point(23, 39);
         this.uxDTex.Name = "uxDTex";
         this.uxDTex.ReadOnly = true;
         this.uxDTex.Size = new System.Drawing.Size(100, 29);
         this.uxDTex.TabIndex = 1;
         this.uxDTex.Text = "ABCDEFGH";
         // 
         // label13
         // 
         this.label13.AutoSize = true;
         this.label13.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label13.Location = new System.Drawing.Point(244, 81);
         this.label13.Name = "label13";
         this.label13.Size = new System.Drawing.Size(44, 16);
         this.label13.TabIndex = 14;
         this.label13.Text = "Lustre";
         // 
         // label9
         // 
         this.label9.AutoSize = true;
         this.label9.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label9.Location = new System.Drawing.Point(361, 23);
         this.label9.Name = "label9";
         this.label9.Size = new System.Drawing.Size(103, 16);
         this.label9.TabIndex = 6;
         this.label9.Text = "Masa Bruta (Kg)";
         // 
         // label14
         // 
         this.label14.AutoSize = true;
         this.label14.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label14.Location = new System.Drawing.Point(135, 81);
         this.label14.Name = "label14";
         this.label14.Size = new System.Drawing.Size(80, 16);
         this.label14.TabIndex = 12;
         this.label14.Text = "Longitud (in)";
         // 
         // label6
         // 
         this.label6.AutoSize = true;
         this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label6.Location = new System.Drawing.Point(244, 23);
         this.label6.Name = "label6";
         this.label6.Size = new System.Drawing.Size(56, 16);
         this.label6.TabIndex = 4;
         this.label6.Text = "M.S.D.S";
         // 
         // label15
         // 
         this.label15.AutoSize = true;
         this.label15.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label15.Location = new System.Drawing.Point(20, 81);
         this.label15.Name = "label15";
         this.label15.Size = new System.Drawing.Size(41, 16);
         this.label15.TabIndex = 10;
         this.label15.Text = "D.P.F";
         // 
         // label7
         // 
         this.label7.AutoSize = true;
         this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label7.Location = new System.Drawing.Point(135, 23);
         this.label7.Name = "label7";
         this.label7.Size = new System.Drawing.Size(73, 16);
         this.label7.TabIndex = 2;
         this.label7.Text = "Corte (mm)";
         // 
         // label8
         // 
         this.label8.AutoSize = true;
         this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label8.Location = new System.Drawing.Point(20, 23);
         this.label8.Name = "label8";
         this.label8.Size = new System.Drawing.Size(42, 16);
         this.label8.TabIndex = 0;
         this.label8.Text = "dTEX";
         // 
         // groupBox4
         // 
         this.groupBox4.Controls.Add(this.uxBala);
         this.groupBox4.Controls.Add(this.label17);
         this.groupBox4.Location = new System.Drawing.Point(12, 286);
         this.groupBox4.Name = "groupBox4";
         this.groupBox4.Size = new System.Drawing.Size(426, 72);
         this.groupBox4.TabIndex = 3;
         this.groupBox4.TabStop = false;
         // 
         // uxBala
         // 
         this.uxBala.BackColor = System.Drawing.SystemColors.Window;
         this.uxBala.Font = new System.Drawing.Font("Microsoft Sans Serif", 21.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxBala.Location = new System.Drawing.Point(69, 19);
         this.uxBala.Name = "uxBala";
         this.uxBala.ReadOnly = true;
         this.uxBala.Size = new System.Drawing.Size(351, 40);
         this.uxBala.TabIndex = 1;
         this.uxBala.Text = "ABCDEFGH";
         // 
         // label17
         // 
         this.label17.AutoSize = true;
         this.label17.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.label17.Location = new System.Drawing.Point(17, 32);
         this.label17.Name = "label17";
         this.label17.Size = new System.Drawing.Size(39, 16);
         this.label17.TabIndex = 0;
         this.label17.Text = "Bala:";
         // 
         // toolStripContainer1
         // 
         this.toolStripContainer1.BottomToolStripPanelVisible = false;
         // 
         // toolStripContainer1.ContentPanel
         // 
         this.toolStripContainer1.ContentPanel.Controls.Add(this.uxBufferIcon);
         this.toolStripContainer1.ContentPanel.Controls.Add(this.uxLinxOKIcon);
         this.toolStripContainer1.ContentPanel.Controls.Add(this.uxLinxErrorIcon);
         this.toolStripContainer1.ContentPanel.Controls.Add(this.btnLimpiar);
         this.toolStripContainer1.ContentPanel.Controls.Add(this.uxErrorList);
         this.toolStripContainer1.ContentPanel.Controls.Add(this.label1);
         this.toolStripContainer1.ContentPanel.Controls.Add(this.groupBox1);
         this.toolStripContainer1.ContentPanel.Controls.Add(this.groupBox2);
         this.toolStripContainer1.ContentPanel.Controls.Add(this.groupBox4);
         this.toolStripContainer1.ContentPanel.Size = new System.Drawing.Size(622, 431);
         this.toolStripContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
         this.toolStripContainer1.LeftToolStripPanelVisible = false;
         this.toolStripContainer1.Location = new System.Drawing.Point(0, 0);
         this.toolStripContainer1.Name = "toolStripContainer1";
         this.toolStripContainer1.RightToolStripPanelVisible = false;
         this.toolStripContainer1.Size = new System.Drawing.Size(622, 455);
         this.toolStripContainer1.TabIndex = 7;
         this.toolStripContainer1.Text = "toolStripContainer1";
         // 
         // toolStripContainer1.TopToolStripPanel
         // 
         this.toolStripContainer1.TopToolStripPanel.Controls.Add(this.menuStrip1);
         // 
         // uxLinxErrorIcon
         // 
         this.uxLinxErrorIcon.Image = ((System.Drawing.Image)(resources.GetObject("uxLinxErrorIcon.Image")));
         this.uxLinxErrorIcon.InitialImage = null;
         this.uxLinxErrorIcon.Location = new System.Drawing.Point(461, 286);
         this.uxLinxErrorIcon.Name = "uxLinxErrorIcon";
         this.uxLinxErrorIcon.Size = new System.Drawing.Size(72, 72);
         this.uxLinxErrorIcon.TabIndex = 11;
         this.uxLinxErrorIcon.TabStop = false;
         this.uxToolTip.SetToolTip(this.uxLinxErrorIcon, "Se ha perdido la comunicación con RSLinx o con el PLC");
         // 
         // btnLimpiar
         // 
         this.btnLimpiar.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
         this.btnLimpiar.Location = new System.Drawing.Point(552, 373);
         this.btnLimpiar.Name = "btnLimpiar";
         this.btnLimpiar.Size = new System.Drawing.Size(59, 31);
         this.btnLimpiar.TabIndex = 10;
         this.btnLimpiar.Text = "Limpiar";
         this.btnLimpiar.UseVisualStyleBackColor = true;
         this.btnLimpiar.Click += new System.EventHandler(this.btnLimpiar_Click);
         // 
         // uxErrorList
         // 
         this.uxErrorList.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
         this.uxErrorList.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
         this.uxErrorList.ForeColor = System.Drawing.Color.Red;
         this.uxErrorList.FormattingEnabled = true;
         this.uxErrorList.Location = new System.Drawing.Point(12, 364);
         this.uxErrorList.Name = "uxErrorList";
         this.uxErrorList.Size = new System.Drawing.Size(533, 43);
         this.uxErrorList.TabIndex = 8;
         this.uxErrorList.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.uxErrorList_MouseDoubleClick);
         // 
         // menuStrip1
         // 
         this.menuStrip1.Dock = System.Windows.Forms.DockStyle.None;
         this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem2});
         this.menuStrip1.Location = new System.Drawing.Point(0, 0);
         this.menuStrip1.Name = "menuStrip1";
         this.menuStrip1.Size = new System.Drawing.Size(622, 24);
         this.menuStrip1.TabIndex = 0;
         this.menuStrip1.Text = "menuStrip1";
         // 
         // toolStripMenuItem2
         // 
         this.toolStripMenuItem2.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem4,
            this.toolStripSeparator1,
            this.toolStripMenuItem5});
         this.toolStripMenuItem2.Name = "toolStripMenuItem2";
         this.toolStripMenuItem2.Size = new System.Drawing.Size(60, 20);
         this.toolStripMenuItem2.Text = "Archivo";
         // 
         // toolStripMenuItem4
         // 
         this.toolStripMenuItem4.Name = "toolStripMenuItem4";
         this.toolStripMenuItem4.Size = new System.Drawing.Size(217, 22);
         this.toolStripMenuItem4.Text = "Exportar registros";
         this.toolStripMenuItem4.Click += new System.EventHandler(this.exportarRegistrosToolStripMenuItem_Click);
         // 
         // toolStripSeparator1
         // 
         this.toolStripSeparator1.Name = "toolStripSeparator1";
         this.toolStripSeparator1.Size = new System.Drawing.Size(214, 6);
         // 
         // toolStripMenuItem5
         // 
         this.toolStripMenuItem5.Name = "toolStripMenuItem5";
         this.toolStripMenuItem5.Size = new System.Drawing.Size(217, 22);
         this.toolStripMenuItem5.Text = "Salir y terminar adquisición";
         this.toolStripMenuItem5.Click += new System.EventHandler(this.salirYTerminarAdquisiciónToolStripMenuItem_Click);
         // 
         // timerTransfiereSAP
         // 
         this.timerTransfiereSAP.Interval = 3000;
         this.timerTransfiereSAP.Tick += new System.EventHandler(this.timerTransfiereSAP_Tick);
         // 
         // timerReconectaLinx
         // 
         this.timerReconectaLinx.Enabled = true;
         this.timerReconectaLinx.Interval = 5000;
         this.timerReconectaLinx.Tick += new System.EventHandler(this.timerReconectaLinx_Tick);
         // 
         // holaToolStripMenuItem
         // 
         this.holaToolStripMenuItem.Name = "holaToolStripMenuItem";
         this.holaToolStripMenuItem.Size = new System.Drawing.Size(44, 20);
         this.holaToolStripMenuItem.Text = "Hola";
         // 
         // uxLinxOKIcon
         // 
         this.uxLinxOKIcon.Image = ((System.Drawing.Image)(resources.GetObject("uxLinxOKIcon.Image")));
         this.uxLinxOKIcon.InitialImage = null;
         this.uxLinxOKIcon.Location = new System.Drawing.Point(461, 286);
         this.uxLinxOKIcon.Name = "uxLinxOKIcon";
         this.uxLinxOKIcon.Size = new System.Drawing.Size(72, 72);
         this.uxLinxOKIcon.TabIndex = 12;
         this.uxLinxOKIcon.TabStop = false;
         this.uxToolTip.SetToolTip(this.uxLinxOKIcon, "Comunicación con RSLinx funcionando correctamente.");
         this.uxLinxOKIcon.Visible = false;
         // 
         // uxBufferIcon
         // 
         this.uxBufferIcon.Image = ((System.Drawing.Image)(resources.GetObject("uxBufferIcon.Image")));
         this.uxBufferIcon.InitialImage = null;
         this.uxBufferIcon.Location = new System.Drawing.Point(539, 286);
         this.uxBufferIcon.Name = "uxBufferIcon";
         this.uxBufferIcon.Size = new System.Drawing.Size(72, 72);
         this.uxBufferIcon.TabIndex = 12;
         this.uxBufferIcon.TabStop = false;
         this.uxToolTip.SetToolTip(this.uxBufferIcon, "Hay registros sin transferir a SAP");
         this.uxBufferIcon.Visible = false;
         // 
         // uxToolTip
         // 
         this.uxToolTip.IsBalloon = true;
         // 
         // timerDepura
         // 
         this.timerDepura.Interval = 30000;
         this.timerDepura.Tick += new System.EventHandler(this.timerDepura_Tick);
         // 
         // frmMain
         // 
         this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
         this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
         this.ClientSize = new System.Drawing.Size(622, 455);
         this.Controls.Add(this.toolStripContainer1);
         this.MainMenuStrip = this.menuStrip1;
         this.Name = "frmMain";
         this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
         this.Text = "LiftBox Logger";
         this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.frmMain_FormClosing);
         this.Load += new System.EventHandler(this.frmMain_Load);
         this.groupBox1.ResumeLayout(false);
         this.groupBox1.PerformLayout();
         this.groupBox2.ResumeLayout(false);
         this.groupBox2.PerformLayout();
         this.groupBox4.ResumeLayout(false);
         this.groupBox4.PerformLayout();
         this.toolStripContainer1.ContentPanel.ResumeLayout(false);
         this.toolStripContainer1.ContentPanel.PerformLayout();
         this.toolStripContainer1.TopToolStripPanel.ResumeLayout(false);
         this.toolStripContainer1.TopToolStripPanel.PerformLayout();
         this.toolStripContainer1.ResumeLayout(false);
         this.toolStripContainer1.PerformLayout();
         ((System.ComponentModel.ISupportInitialize)(this.uxLinxErrorIcon)).EndInit();
         this.menuStrip1.ResumeLayout(false);
         this.menuStrip1.PerformLayout();
         ((System.ComponentModel.ISupportInitialize)(this.uxLinxOKIcon)).EndInit();
         ((System.ComponentModel.ISupportInitialize)(this.uxBufferIcon)).EndInit();
         this.ResumeLayout(false);

      }

      #endregion

      private System.Windows.Forms.Label label1;
      private System.Windows.Forms.GroupBox groupBox1;
      private System.Windows.Forms.TextBox uxTipo;
      private System.Windows.Forms.TextBox uxLote;
      private System.Windows.Forms.TextBox uxProducto;
      private System.Windows.Forms.Label label5;
      private System.Windows.Forms.Label label4;
      private System.Windows.Forms.Label label3;
      private System.Windows.Forms.GroupBox groupBox2;
      private System.Windows.Forms.TextBox uxMasaNeta;
      private System.Windows.Forms.TextBox uxMSDS;
      private System.Windows.Forms.TextBox uxMasaBruta;
      private System.Windows.Forms.TextBox uxCorte;
      private System.Windows.Forms.Label label10;
      private System.Windows.Forms.TextBox uxDTex;
      private System.Windows.Forms.Label label9;
      private System.Windows.Forms.Label label6;
      private System.Windows.Forms.Label label7;
      private System.Windows.Forms.Label label8;
      private System.Windows.Forms.TextBox uxMasaNetaLbs;
      private System.Windows.Forms.TextBox uxLustre;
      private System.Windows.Forms.TextBox uxMasaBrutaLbs;
      private System.Windows.Forms.TextBox uxLongitud;
      private System.Windows.Forms.Label label11;
      private System.Windows.Forms.TextBox uxDPF;
      private System.Windows.Forms.Label label12;
      private System.Windows.Forms.Label label13;
      private System.Windows.Forms.Label label14;
      private System.Windows.Forms.Label label15;
      private System.Windows.Forms.GroupBox groupBox4;
      private System.Windows.Forms.TextBox uxBala;
      private System.Windows.Forms.Label label17;
      private System.Windows.Forms.ToolStripMenuItem archivoToolStripMenuItem;
      private System.Windows.Forms.ToolStripMenuItem exportarRegistrosToolStripMenuItem;
      private System.Windows.Forms.ToolStripSeparator toolStripMenuItem1;
      private System.Windows.Forms.ToolStripMenuItem salirYTerminarAdquisiciónToolStripMenuItem;
      private System.Windows.Forms.ToolStripContainer toolStripContainer1;
      private System.Windows.Forms.ListBox uxErrorList;
      private System.Windows.Forms.Timer timerTransfiereSAP;
      private System.Windows.Forms.Timer timerReconectaLinx;
      private System.Windows.Forms.PictureBox uxLinxErrorIcon;
      private System.Windows.Forms.Button btnLimpiar;
      private System.Windows.Forms.MenuStrip menuStrip1;
      private System.Windows.Forms.ToolStripMenuItem holaToolStripMenuItem;
      private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem2;
      private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem4;
      private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
      private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem5;
      private System.Windows.Forms.PictureBox uxBufferIcon;
      private System.Windows.Forms.PictureBox uxLinxOKIcon;
      private System.Windows.Forms.ToolTip uxToolTip;
      private System.Windows.Forms.Timer timerDepura;
   }
}

