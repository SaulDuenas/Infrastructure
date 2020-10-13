namespace SrvControlPanel
{
    partial class frmCfgInViewSvc
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
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabGeneral = new System.Windows.Forms.TabPage();
            this.label1 = new System.Windows.Forms.Label();
            this.txtDiasLog = new System.Windows.Forms.NumericUpDown();
            this.label2 = new System.Windows.Forms.Label();
            this.label13 = new System.Windows.Forms.Label();
            this.txtIntervaloAnalisis = new System.Windows.Forms.NumericUpDown();
            this.label12 = new System.Windows.Forms.Label();
            this.optWarning = new System.Windows.Forms.RadioButton();
            this.optError = new System.Windows.Forms.RadioButton();
            this.optInfo = new System.Windows.Forms.RadioButton();
            this.optDebug = new System.Windows.Forms.RadioButton();
            this.label4 = new System.Windows.Forms.Label();
            this.tabDBLPS = new System.Windows.Forms.TabPage();
            this.btnProbar = new System.Windows.Forms.Button();
            this.label7 = new System.Windows.Forms.Label();
            this.txtPWD_Origen = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.txtUID_Origen = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.txtDB_Origen = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.txtSVR_Origen = new System.Windows.Forms.TextBox();
            this.tabInViews = new System.Windows.Forms.TabPage();
            this.tabCfgInView4 = new System.Windows.Forms.TabControl();
            this.tabCfgInView1 = new System.Windows.Forms.TabPage();
            this.ucInViewCfg1 = new SrvControlPanel.ucInViewCfg();
            this.tabCfgInView2 = new System.Windows.Forms.TabPage();
            this.ucInViewCfg2 = new SrvControlPanel.ucInViewCfg();
            this.tabPage3 = new System.Windows.Forms.TabPage();
            this.ucInViewCfg3 = new SrvControlPanel.ucInViewCfg();
            this.tabPage4 = new System.Windows.Forms.TabPage();
            this.ucInViewCfg4 = new SrvControlPanel.ucInViewCfg();
            this.tabCeldas = new System.Windows.Forms.TabPage();
            this.tabControl2 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.ucListaCeldas1 = new SrvControlPanel.ucListaCeldas();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.ucListaCeldas2 = new SrvControlPanel.ucListaCeldas();
            this.tabPage5 = new System.Windows.Forms.TabPage();
            this.ucListaCeldas3 = new SrvControlPanel.ucListaCeldas();
            this.tabPage6 = new System.Windows.Forms.TabPage();
            this.ucListaCeldas4 = new SrvControlPanel.ucListaCeldas();
            this.btnCancelar = new System.Windows.Forms.Button();
            this.btnAceptar = new System.Windows.Forms.Button();
            this.tabControl1.SuspendLayout();
            this.tabGeneral.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.txtDiasLog)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtIntervaloAnalisis)).BeginInit();
            this.tabDBLPS.SuspendLayout();
            this.tabInViews.SuspendLayout();
            this.tabCfgInView4.SuspendLayout();
            this.tabCfgInView1.SuspendLayout();
            this.tabCfgInView2.SuspendLayout();
            this.tabPage3.SuspendLayout();
            this.tabPage4.SuspendLayout();
            this.tabCeldas.SuspendLayout();
            this.tabControl2.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.tabPage5.SuspendLayout();
            this.tabPage6.SuspendLayout();
            this.SuspendLayout();
            // 
            // tabControl1
            // 
            this.tabControl1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.tabControl1.Controls.Add(this.tabGeneral);
            this.tabControl1.Controls.Add(this.tabDBLPS);
            this.tabControl1.Controls.Add(this.tabInViews);
            this.tabControl1.Controls.Add(this.tabCeldas);
            this.tabControl1.Location = new System.Drawing.Point(4, 4);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(363, 249);
            this.tabControl1.TabIndex = 0;
            // 
            // tabGeneral
            // 
            this.tabGeneral.Controls.Add(this.label1);
            this.tabGeneral.Controls.Add(this.txtDiasLog);
            this.tabGeneral.Controls.Add(this.label2);
            this.tabGeneral.Controls.Add(this.label13);
            this.tabGeneral.Controls.Add(this.txtIntervaloAnalisis);
            this.tabGeneral.Controls.Add(this.label12);
            this.tabGeneral.Controls.Add(this.optWarning);
            this.tabGeneral.Controls.Add(this.optError);
            this.tabGeneral.Controls.Add(this.optInfo);
            this.tabGeneral.Controls.Add(this.optDebug);
            this.tabGeneral.Controls.Add(this.label4);
            this.tabGeneral.Location = new System.Drawing.Point(4, 22);
            this.tabGeneral.Name = "tabGeneral";
            this.tabGeneral.Padding = new System.Windows.Forms.Padding(3);
            this.tabGeneral.Size = new System.Drawing.Size(355, 223);
            this.tabGeneral.TabIndex = 2;
            this.tabGeneral.Text = "General";
            this.tabGeneral.UseVisualStyleBackColor = true;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(164, 145);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(28, 13);
            this.label1.TabIndex = 13;
            this.label1.Text = "días";
            // 
            // txtDiasLog
            // 
            this.txtDiasLog.Location = new System.Drawing.Point(117, 143);
            this.txtDiasLog.Minimum = new decimal(new int[] {
            2,
            0,
            0,
            0});
            this.txtDiasLog.Name = "txtDiasLog";
            this.txtDiasLog.Size = new System.Drawing.Size(44, 20);
            this.txtDiasLog.TabIndex = 12;
            this.txtDiasLog.Value = new decimal(new int[] {
            7,
            0,
            0,
            0});
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(21, 145);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(95, 13);
            this.label2.TabIndex = 11;
            this.label2.Text = "Mantener logs por:";
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(167, 5);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(125, 13);
            this.label13.TabIndex = 10;
            this.label13.Text = "horas.    (0= turno actual)";
            this.label13.Visible = false;
            // 
            // txtIntervaloAnalisis
            // 
            this.txtIntervaloAnalisis.Location = new System.Drawing.Point(120, 3);
            this.txtIntervaloAnalisis.Name = "txtIntervaloAnalisis";
            this.txtIntervaloAnalisis.Size = new System.Drawing.Size(44, 20);
            this.txtIntervaloAnalisis.TabIndex = 9;
            this.txtIntervaloAnalisis.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.txtIntervaloAnalisis.Visible = false;
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Location = new System.Drawing.Point(11, 5);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(103, 13);
            this.label12.TabIndex = 8;
            this.label12.Text = "Intervalo de análisis:";
            this.label12.Visible = false;
            // 
            // optWarning
            // 
            this.optWarning.AutoSize = true;
            this.optWarning.Location = new System.Drawing.Point(24, 91);
            this.optWarning.Name = "optWarning";
            this.optWarning.Size = new System.Drawing.Size(133, 17);
            this.optWarning.TabIndex = 6;
            this.optWarning.TabStop = true;
            this.optWarning.Text = "Errores y advertencias.";
            this.optWarning.UseVisualStyleBackColor = true;
            // 
            // optError
            // 
            this.optError.AutoSize = true;
            this.optError.Location = new System.Drawing.Point(24, 114);
            this.optError.Name = "optError";
            this.optError.Size = new System.Drawing.Size(119, 17);
            this.optError.TabIndex = 7;
            this.optError.Text = "Errores únicamente.";
            this.optError.UseVisualStyleBackColor = true;
            // 
            // optInfo
            // 
            this.optInfo.AutoSize = true;
            this.optInfo.Checked = true;
            this.optInfo.Location = new System.Drawing.Point(24, 68);
            this.optInfo.Name = "optInfo";
            this.optInfo.Size = new System.Drawing.Size(265, 17);
            this.optInfo.TabIndex = 5;
            this.optInfo.TabStop = true;
            this.optInfo.Text = "Errores, advertencias e información (recomendado)";
            this.optInfo.UseVisualStyleBackColor = true;
            // 
            // optDebug
            // 
            this.optDebug.AutoSize = true;
            this.optDebug.Location = new System.Drawing.Point(24, 45);
            this.optDebug.Name = "optDebug";
            this.optDebug.Size = new System.Drawing.Size(254, 17);
            this.optDebug.TabIndex = 4;
            this.optDebug.Text = "Depuración, errores, advertencias e información.";
            this.optDebug.UseVisualStyleBackColor = true;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(8, 26);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(140, 13);
            this.label4.TabIndex = 3;
            this.label4.Text = "Eventos a reportar en el log:";
            // 
            // tabDBLPS
            // 
            this.tabDBLPS.Controls.Add(this.btnProbar);
            this.tabDBLPS.Controls.Add(this.label7);
            this.tabDBLPS.Controls.Add(this.txtPWD_Origen);
            this.tabDBLPS.Controls.Add(this.label6);
            this.tabDBLPS.Controls.Add(this.txtUID_Origen);
            this.tabDBLPS.Controls.Add(this.label5);
            this.tabDBLPS.Controls.Add(this.txtDB_Origen);
            this.tabDBLPS.Controls.Add(this.label3);
            this.tabDBLPS.Controls.Add(this.txtSVR_Origen);
            this.tabDBLPS.Location = new System.Drawing.Point(4, 22);
            this.tabDBLPS.Name = "tabDBLPS";
            this.tabDBLPS.Padding = new System.Windows.Forms.Padding(3);
            this.tabDBLPS.Size = new System.Drawing.Size(355, 223);
            this.tabDBLPS.TabIndex = 0;
            this.tabDBLPS.Text = "Conexión DB";
            this.tabDBLPS.UseVisualStyleBackColor = true;
            // 
            // btnProbar
            // 
            this.btnProbar.Location = new System.Drawing.Point(94, 140);
            this.btnProbar.Name = "btnProbar";
            this.btnProbar.Size = new System.Drawing.Size(69, 22);
            this.btnProbar.TabIndex = 8;
            this.btnProbar.Text = "Probar";
            this.btnProbar.UseVisualStyleBackColor = true;
            this.btnProbar.Click += new System.EventHandler(this.btnProbar_Click);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(24, 105);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(64, 13);
            this.label7.TabIndex = 6;
            this.label7.Text = "Contraseña:";
            // 
            // txtPWD_Origen
            // 
            this.txtPWD_Origen.Location = new System.Drawing.Point(94, 102);
            this.txtPWD_Origen.Name = "txtPWD_Origen";
            this.txtPWD_Origen.PasswordChar = '*';
            this.txtPWD_Origen.Size = new System.Drawing.Size(136, 20);
            this.txtPWD_Origen.TabIndex = 7;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(42, 79);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(46, 13);
            this.label6.TabIndex = 4;
            this.label6.Text = "Usuario:";
            // 
            // txtUID_Origen
            // 
            this.txtUID_Origen.Location = new System.Drawing.Point(94, 76);
            this.txtUID_Origen.Name = "txtUID_Origen";
            this.txtUID_Origen.Size = new System.Drawing.Size(136, 20);
            this.txtUID_Origen.TabIndex = 5;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(10, 52);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(78, 13);
            this.label5.TabIndex = 2;
            this.label5.Text = "Base de datos:";
            // 
            // txtDB_Origen
            // 
            this.txtDB_Origen.Location = new System.Drawing.Point(94, 49);
            this.txtDB_Origen.Name = "txtDB_Origen";
            this.txtDB_Origen.Size = new System.Drawing.Size(136, 20);
            this.txtDB_Origen.TabIndex = 3;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(39, 25);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(49, 13);
            this.label3.TabIndex = 0;
            this.label3.Text = "Servidor:";
            // 
            // txtSVR_Origen
            // 
            this.txtSVR_Origen.Location = new System.Drawing.Point(94, 22);
            this.txtSVR_Origen.Name = "txtSVR_Origen";
            this.txtSVR_Origen.Size = new System.Drawing.Size(136, 20);
            this.txtSVR_Origen.TabIndex = 1;
            // 
            // tabInViews
            // 
            this.tabInViews.Controls.Add(this.tabCfgInView4);
            this.tabInViews.Location = new System.Drawing.Point(4, 22);
            this.tabInViews.Name = "tabInViews";
            this.tabInViews.Padding = new System.Windows.Forms.Padding(3);
            this.tabInViews.Size = new System.Drawing.Size(355, 223);
            this.tabInViews.TabIndex = 1;
            this.tabInViews.Text = "InViews";
            this.tabInViews.UseVisualStyleBackColor = true;
            // 
            // tabCfgInView4
            // 
            this.tabCfgInView4.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.tabCfgInView4.Controls.Add(this.tabCfgInView1);
            this.tabCfgInView4.Controls.Add(this.tabCfgInView2);
            this.tabCfgInView4.Controls.Add(this.tabPage3);
            this.tabCfgInView4.Controls.Add(this.tabPage4);
            this.tabCfgInView4.Location = new System.Drawing.Point(6, 6);
            this.tabCfgInView4.Name = "tabCfgInView4";
            this.tabCfgInView4.SelectedIndex = 0;
            this.tabCfgInView4.Size = new System.Drawing.Size(343, 211);
            this.tabCfgInView4.TabIndex = 4;
            // 
            // tabCfgInView1
            // 
            this.tabCfgInView1.Controls.Add(this.ucInViewCfg1);
            this.tabCfgInView1.Location = new System.Drawing.Point(4, 22);
            this.tabCfgInView1.Name = "tabCfgInView1";
            this.tabCfgInView1.Padding = new System.Windows.Forms.Padding(3);
            this.tabCfgInView1.Size = new System.Drawing.Size(335, 185);
            this.tabCfgInView1.TabIndex = 0;
            this.tabCfgInView1.Text = "InView 1";
            this.tabCfgInView1.UseVisualStyleBackColor = true;
            // 
            // ucInViewCfg1
            // 
            this.ucInViewCfg1.DisplayAddress = "";
            this.ucInViewCfg1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ucInViewCfg1.Frecuencia = "1";
            this.ucInViewCfg1.IPAddress = "";
            this.ucInViewCfg1.IPPort = "";
            this.ucInViewCfg1.Location = new System.Drawing.Point(3, 3);
            this.ucInViewCfg1.Name = "ucInViewCfg1";
            this.ucInViewCfg1.Size = new System.Drawing.Size(329, 179);
            this.ucInViewCfg1.TabIndex = 0;
            // 
            // tabCfgInView2
            // 
            this.tabCfgInView2.Controls.Add(this.ucInViewCfg2);
            this.tabCfgInView2.Location = new System.Drawing.Point(4, 22);
            this.tabCfgInView2.Name = "tabCfgInView2";
            this.tabCfgInView2.Padding = new System.Windows.Forms.Padding(3);
            this.tabCfgInView2.Size = new System.Drawing.Size(335, 185);
            this.tabCfgInView2.TabIndex = 1;
            this.tabCfgInView2.Text = "InView 2";
            this.tabCfgInView2.UseVisualStyleBackColor = true;
            // 
            // ucInViewCfg2
            // 
            this.ucInViewCfg2.DisplayAddress = "";
            this.ucInViewCfg2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ucInViewCfg2.Frecuencia = "1";
            this.ucInViewCfg2.IPAddress = "";
            this.ucInViewCfg2.IPPort = "";
            this.ucInViewCfg2.Location = new System.Drawing.Point(3, 3);
            this.ucInViewCfg2.Name = "ucInViewCfg2";
            this.ucInViewCfg2.Size = new System.Drawing.Size(329, 179);
            this.ucInViewCfg2.TabIndex = 8;
            // 
            // tabPage3
            // 
            this.tabPage3.Controls.Add(this.ucInViewCfg3);
            this.tabPage3.Location = new System.Drawing.Point(4, 22);
            this.tabPage3.Name = "tabPage3";
            this.tabPage3.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage3.Size = new System.Drawing.Size(335, 185);
            this.tabPage3.TabIndex = 2;
            this.tabPage3.Text = "InView 3";
            this.tabPage3.UseVisualStyleBackColor = true;
            // 
            // ucInViewCfg3
            // 
            this.ucInViewCfg3.DisplayAddress = "";
            this.ucInViewCfg3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ucInViewCfg3.Frecuencia = "1";
            this.ucInViewCfg3.IPAddress = "";
            this.ucInViewCfg3.IPPort = "";
            this.ucInViewCfg3.Location = new System.Drawing.Point(3, 3);
            this.ucInViewCfg3.Name = "ucInViewCfg3";
            this.ucInViewCfg3.Size = new System.Drawing.Size(329, 179);
            this.ucInViewCfg3.TabIndex = 9;
            // 
            // tabPage4
            // 
            this.tabPage4.Controls.Add(this.ucInViewCfg4);
            this.tabPage4.Location = new System.Drawing.Point(4, 22);
            this.tabPage4.Name = "tabPage4";
            this.tabPage4.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage4.Size = new System.Drawing.Size(335, 185);
            this.tabPage4.TabIndex = 3;
            this.tabPage4.Text = "InView 4";
            this.tabPage4.UseVisualStyleBackColor = true;
            // 
            // ucInViewCfg4
            // 
            this.ucInViewCfg4.DisplayAddress = "";
            this.ucInViewCfg4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ucInViewCfg4.Frecuencia = "1";
            this.ucInViewCfg4.IPAddress = "";
            this.ucInViewCfg4.IPPort = "";
            this.ucInViewCfg4.Location = new System.Drawing.Point(3, 3);
            this.ucInViewCfg4.Name = "ucInViewCfg4";
            this.ucInViewCfg4.Size = new System.Drawing.Size(329, 179);
            this.ucInViewCfg4.TabIndex = 9;
            // 
            // tabCeldas
            // 
            this.tabCeldas.Controls.Add(this.tabControl2);
            this.tabCeldas.Location = new System.Drawing.Point(4, 22);
            this.tabCeldas.Name = "tabCeldas";
            this.tabCeldas.Padding = new System.Windows.Forms.Padding(3);
            this.tabCeldas.Size = new System.Drawing.Size(355, 223);
            this.tabCeldas.TabIndex = 3;
            this.tabCeldas.Text = "Celdas";
            this.tabCeldas.UseVisualStyleBackColor = true;
            // 
            // tabControl2
            // 
            this.tabControl2.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.tabControl2.Controls.Add(this.tabPage1);
            this.tabControl2.Controls.Add(this.tabPage2);
            this.tabControl2.Controls.Add(this.tabPage5);
            this.tabControl2.Controls.Add(this.tabPage6);
            this.tabControl2.Location = new System.Drawing.Point(6, 6);
            this.tabControl2.Name = "tabControl2";
            this.tabControl2.SelectedIndex = 0;
            this.tabControl2.Size = new System.Drawing.Size(343, 211);
            this.tabControl2.TabIndex = 5;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.ucListaCeldas1);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(335, 185);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "InView 1";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // ucListaCeldas1
            // 
            this.ucListaCeldas1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ucListaCeldas1.Location = new System.Drawing.Point(3, 3);
            this.ucListaCeldas1.Name = "ucListaCeldas1";
            this.ucListaCeldas1.Size = new System.Drawing.Size(329, 179);
            this.ucListaCeldas1.TabIndex = 0;
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.ucListaCeldas2);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(335, 185);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "InView 2";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // ucListaCeldas2
            // 
            this.ucListaCeldas2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ucListaCeldas2.Location = new System.Drawing.Point(3, 3);
            this.ucListaCeldas2.Name = "ucListaCeldas2";
            this.ucListaCeldas2.Size = new System.Drawing.Size(329, 179);
            this.ucListaCeldas2.TabIndex = 0;
            // 
            // tabPage5
            // 
            this.tabPage5.Controls.Add(this.ucListaCeldas3);
            this.tabPage5.Location = new System.Drawing.Point(4, 22);
            this.tabPage5.Name = "tabPage5";
            this.tabPage5.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage5.Size = new System.Drawing.Size(335, 185);
            this.tabPage5.TabIndex = 2;
            this.tabPage5.Text = "InView 3";
            this.tabPage5.UseVisualStyleBackColor = true;
            // 
            // ucListaCeldas3
            // 
            this.ucListaCeldas3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ucListaCeldas3.Location = new System.Drawing.Point(3, 3);
            this.ucListaCeldas3.Name = "ucListaCeldas3";
            this.ucListaCeldas3.Size = new System.Drawing.Size(329, 179);
            this.ucListaCeldas3.TabIndex = 1;
            // 
            // tabPage6
            // 
            this.tabPage6.Controls.Add(this.ucListaCeldas4);
            this.tabPage6.Location = new System.Drawing.Point(4, 22);
            this.tabPage6.Name = "tabPage6";
            this.tabPage6.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage6.Size = new System.Drawing.Size(335, 185);
            this.tabPage6.TabIndex = 3;
            this.tabPage6.Text = "InView 4";
            this.tabPage6.UseVisualStyleBackColor = true;
            // 
            // ucListaCeldas4
            // 
            this.ucListaCeldas4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ucListaCeldas4.Location = new System.Drawing.Point(3, 3);
            this.ucListaCeldas4.Name = "ucListaCeldas4";
            this.ucListaCeldas4.Size = new System.Drawing.Size(329, 179);
            this.ucListaCeldas4.TabIndex = 1;
            // 
            // btnCancelar
            // 
            this.btnCancelar.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnCancelar.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancelar.Location = new System.Drawing.Point(275, 263);
            this.btnCancelar.Name = "btnCancelar";
            this.btnCancelar.Size = new System.Drawing.Size(89, 24);
            this.btnCancelar.TabIndex = 3;
            this.btnCancelar.Text = "&Cancelar";
            this.btnCancelar.UseVisualStyleBackColor = true;
            this.btnCancelar.Click += new System.EventHandler(this.btnCancelar_Click);
            // 
            // btnAceptar
            // 
            this.btnAceptar.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnAceptar.Location = new System.Drawing.Point(180, 263);
            this.btnAceptar.Name = "btnAceptar";
            this.btnAceptar.Size = new System.Drawing.Size(89, 24);
            this.btnAceptar.TabIndex = 1;
            this.btnAceptar.Text = "&Aceptar";
            this.btnAceptar.UseVisualStyleBackColor = true;
            this.btnAceptar.Click += new System.EventHandler(this.btnAceptar_Click);
            // 
            // frmCfgInViewSvc
            // 
            this.AcceptButton = this.btnAceptar;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.btnCancelar;
            this.ClientSize = new System.Drawing.Size(372, 293);
            this.ControlBox = false;
            this.Controls.Add(this.btnAceptar);
            this.Controls.Add(this.btnCancelar);
            this.Controls.Add(this.tabControl1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmCfgInViewSvc";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Configuración del Servicio";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.frmConfigurar_FormClosed);
            this.tabControl1.ResumeLayout(false);
            this.tabGeneral.ResumeLayout(false);
            this.tabGeneral.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.txtDiasLog)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtIntervaloAnalisis)).EndInit();
            this.tabDBLPS.ResumeLayout(false);
            this.tabDBLPS.PerformLayout();
            this.tabInViews.ResumeLayout(false);
            this.tabCfgInView4.ResumeLayout(false);
            this.tabCfgInView1.ResumeLayout(false);
            this.tabCfgInView2.ResumeLayout(false);
            this.tabPage3.ResumeLayout(false);
            this.tabPage4.ResumeLayout(false);
            this.tabCeldas.ResumeLayout(false);
            this.tabControl2.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage2.ResumeLayout(false);
            this.tabPage5.ResumeLayout(false);
            this.tabPage6.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabDBLPS;
        private System.Windows.Forms.TabPage tabInViews;
		 private System.Windows.Forms.Button btnCancelar;
       private System.Windows.Forms.Button btnAceptar;
        private System.Windows.Forms.TabPage tabGeneral;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtSVR_Origen;
        private System.Windows.Forms.RadioButton optError;
        private System.Windows.Forms.RadioButton optInfo;
        private System.Windows.Forms.RadioButton optDebug;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox txtPWD_Origen;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox txtUID_Origen;
        private System.Windows.Forms.Label label5;
       private System.Windows.Forms.TextBox txtDB_Origen;
		 private System.Windows.Forms.RadioButton optWarning;
       private System.Windows.Forms.Label label13;
       private System.Windows.Forms.NumericUpDown txtIntervaloAnalisis;
       private System.Windows.Forms.Label label12;
       private System.Windows.Forms.TabControl tabCfgInView4;
        private System.Windows.Forms.TabPage tabCfgInView1;
        private System.Windows.Forms.TabPage tabCfgInView2;
       private System.Windows.Forms.TabPage tabCeldas;
       private System.Windows.Forms.TabControl tabControl2;
       private System.Windows.Forms.TabPage tabPage1;
       private System.Windows.Forms.TabPage tabPage2;
       private ucListaCeldas ucListaCeldas1;
       private ucListaCeldas ucListaCeldas2;
       private System.Windows.Forms.Button btnProbar;
       private System.Windows.Forms.Label label1;
       private System.Windows.Forms.NumericUpDown txtDiasLog;
       private System.Windows.Forms.Label label2;
        private ucInViewCfg ucInViewCfg1;
        private System.Windows.Forms.TabPage tabPage3;
        private System.Windows.Forms.TabPage tabPage4;
        private ucInViewCfg ucInViewCfg2;
        private ucInViewCfg ucInViewCfg3;
        private ucInViewCfg ucInViewCfg4;
        private System.Windows.Forms.TabPage tabPage5;
        private ucListaCeldas ucListaCeldas3;
        private System.Windows.Forms.TabPage tabPage6;
        private ucListaCeldas ucListaCeldas4;
    }
}