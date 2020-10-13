namespace SrvControlPanel
{
    partial class frmCfgSyncSIMSvc
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
           this.txtFrecuencia = new System.Windows.Forms.NumericUpDown();
           this.label12 = new System.Windows.Forms.Label();
           this.optWarning = new System.Windows.Forms.RadioButton();
           this.optError = new System.Windows.Forms.RadioButton();
           this.optInfo = new System.Windows.Forms.RadioButton();
           this.optDebug = new System.Windows.Forms.RadioButton();
           this.label4 = new System.Windows.Forms.Label();
           this.tabDBSEY = new System.Windows.Forms.TabPage();
           this.btnProbar = new System.Windows.Forms.Button();
           this.label7 = new System.Windows.Forms.Label();
           this.txtPWD_Origen = new System.Windows.Forms.TextBox();
           this.label6 = new System.Windows.Forms.Label();
           this.txtUID_Origen = new System.Windows.Forms.TextBox();
           this.label5 = new System.Windows.Forms.Label();
           this.txtDB_Origen = new System.Windows.Forms.TextBox();
           this.label3 = new System.Windows.Forms.Label();
           this.txtSVR_Origen = new System.Windows.Forms.TextBox();
           this.tabDBOracle = new System.Windows.Forms.TabPage();
           this.btnProbar2 = new System.Windows.Forms.Button();
           this.label8 = new System.Windows.Forms.Label();
           this.txtPWD_Oracle = new System.Windows.Forms.TextBox();
           this.label9 = new System.Windows.Forms.Label();
           this.txtUID_Oracle = new System.Windows.Forms.TextBox();
           this.label11 = new System.Windows.Forms.Label();
           this.txtSVR_Oracle = new System.Windows.Forms.TextBox();
           this.btnCancelar = new System.Windows.Forms.Button();
           this.btnAceptar = new System.Windows.Forms.Button();
           this.tabControl1.SuspendLayout();
           this.tabGeneral.SuspendLayout();
           ((System.ComponentModel.ISupportInitialize)(this.txtDiasLog)).BeginInit();
           ((System.ComponentModel.ISupportInitialize)(this.txtFrecuencia)).BeginInit();
           this.tabDBSEY.SuspendLayout();
           this.tabDBOracle.SuspendLayout();
           this.SuspendLayout();
           // 
           // tabControl1
           // 
           this.tabControl1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
           this.tabControl1.Controls.Add(this.tabGeneral);
           this.tabControl1.Controls.Add(this.tabDBSEY);
           this.tabControl1.Controls.Add(this.tabDBOracle);
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
           this.tabGeneral.Controls.Add(this.txtFrecuencia);
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
           this.label1.Location = new System.Drawing.Point(164, 174);
           this.label1.Name = "label1";
           this.label1.Size = new System.Drawing.Size(28, 13);
           this.label1.TabIndex = 13;
           this.label1.Text = "días";
           // 
           // txtDiasLog
           // 
           this.txtDiasLog.Location = new System.Drawing.Point(117, 172);
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
           this.label2.Location = new System.Drawing.Point(21, 174);
           this.label2.Name = "label2";
           this.label2.Size = new System.Drawing.Size(95, 13);
           this.label2.TabIndex = 11;
           this.label2.Text = "Mantener logs por:";
           // 
           // label13
           // 
           this.label13.AutoSize = true;
           this.label13.Location = new System.Drawing.Point(205, 20);
           this.label13.Name = "label13";
           this.label13.Size = new System.Drawing.Size(56, 13);
           this.label13.TabIndex = 10;
           this.label13.Text = "segundos.";
           // 
           // txtFrecuencia
           // 
           this.txtFrecuencia.Location = new System.Drawing.Point(158, 18);
           this.txtFrecuencia.Name = "txtFrecuencia";
           this.txtFrecuencia.Size = new System.Drawing.Size(44, 20);
           this.txtFrecuencia.TabIndex = 9;
           this.txtFrecuencia.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
           // 
           // label12
           // 
           this.label12.AutoSize = true;
           this.label12.Location = new System.Drawing.Point(8, 20);
           this.label12.Name = "label12";
           this.label12.Size = new System.Drawing.Size(141, 13);
           this.label12.TabIndex = 8;
           this.label12.Text = "Revisar notificaciones cada:";
           // 
           // optWarning
           // 
           this.optWarning.AutoSize = true;
           this.optWarning.Location = new System.Drawing.Point(24, 120);
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
           this.optError.Location = new System.Drawing.Point(24, 143);
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
           this.optInfo.Location = new System.Drawing.Point(24, 97);
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
           this.optDebug.Location = new System.Drawing.Point(24, 74);
           this.optDebug.Name = "optDebug";
           this.optDebug.Size = new System.Drawing.Size(254, 17);
           this.optDebug.TabIndex = 4;
           this.optDebug.Text = "Depuración, errores, advertencias e información.";
           this.optDebug.UseVisualStyleBackColor = true;
           // 
           // label4
           // 
           this.label4.AutoSize = true;
           this.label4.Location = new System.Drawing.Point(8, 55);
           this.label4.Name = "label4";
           this.label4.Size = new System.Drawing.Size(140, 13);
           this.label4.TabIndex = 3;
           this.label4.Text = "Eventos a reportar en el log:";
           // 
           // tabDBSEY
           // 
           this.tabDBSEY.Controls.Add(this.btnProbar);
           this.tabDBSEY.Controls.Add(this.label7);
           this.tabDBSEY.Controls.Add(this.txtPWD_Origen);
           this.tabDBSEY.Controls.Add(this.label6);
           this.tabDBSEY.Controls.Add(this.txtUID_Origen);
           this.tabDBSEY.Controls.Add(this.label5);
           this.tabDBSEY.Controls.Add(this.txtDB_Origen);
           this.tabDBSEY.Controls.Add(this.label3);
           this.tabDBSEY.Controls.Add(this.txtSVR_Origen);
           this.tabDBSEY.Location = new System.Drawing.Point(4, 22);
           this.tabDBSEY.Name = "tabDBSEY";
           this.tabDBSEY.Padding = new System.Windows.Forms.Padding(3);
           this.tabDBSEY.Size = new System.Drawing.Size(355, 223);
           this.tabDBSEY.TabIndex = 0;
           this.tabDBSEY.Text = "Conexión DB";
           this.tabDBSEY.UseVisualStyleBackColor = true;
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
           // tabDBOracle
           // 
           this.tabDBOracle.Controls.Add(this.btnProbar2);
           this.tabDBOracle.Controls.Add(this.label8);
           this.tabDBOracle.Controls.Add(this.txtPWD_Oracle);
           this.tabDBOracle.Controls.Add(this.label9);
           this.tabDBOracle.Controls.Add(this.txtUID_Oracle);
           this.tabDBOracle.Controls.Add(this.label11);
           this.tabDBOracle.Controls.Add(this.txtSVR_Oracle);
           this.tabDBOracle.Location = new System.Drawing.Point(4, 22);
           this.tabDBOracle.Name = "tabDBOracle";
           this.tabDBOracle.Padding = new System.Windows.Forms.Padding(3);
           this.tabDBOracle.Size = new System.Drawing.Size(355, 223);
           this.tabDBOracle.TabIndex = 3;
           this.tabDBOracle.Text = "Conexión SIM (Oracle)";
           this.tabDBOracle.UseVisualStyleBackColor = true;
           // 
           // btnProbar2
           // 
           this.btnProbar2.Location = new System.Drawing.Point(137, 115);
           this.btnProbar2.Name = "btnProbar2";
           this.btnProbar2.Size = new System.Drawing.Size(69, 22);
           this.btnProbar2.TabIndex = 17;
           this.btnProbar2.Text = "Probar";
           this.btnProbar2.UseVisualStyleBackColor = true;
           this.btnProbar2.Click += new System.EventHandler(this.btnProbar2_Click);
           // 
           // label8
           // 
           this.label8.AutoSize = true;
           this.label8.Location = new System.Drawing.Point(67, 78);
           this.label8.Name = "label8";
           this.label8.Size = new System.Drawing.Size(64, 13);
           this.label8.TabIndex = 15;
           this.label8.Text = "Contraseña:";
           // 
           // txtPWD_Oracle
           // 
           this.txtPWD_Oracle.Location = new System.Drawing.Point(137, 75);
           this.txtPWD_Oracle.Name = "txtPWD_Oracle";
           this.txtPWD_Oracle.PasswordChar = '*';
           this.txtPWD_Oracle.Size = new System.Drawing.Size(136, 20);
           this.txtPWD_Oracle.TabIndex = 16;
           // 
           // label9
           // 
           this.label9.AutoSize = true;
           this.label9.Location = new System.Drawing.Point(85, 52);
           this.label9.Name = "label9";
           this.label9.Size = new System.Drawing.Size(46, 13);
           this.label9.TabIndex = 13;
           this.label9.Text = "Usuario:";
           // 
           // txtUID_Oracle
           // 
           this.txtUID_Oracle.Location = new System.Drawing.Point(137, 49);
           this.txtUID_Oracle.Name = "txtUID_Oracle";
           this.txtUID_Oracle.Size = new System.Drawing.Size(136, 20);
           this.txtUID_Oracle.TabIndex = 14;
           // 
           // label11
           // 
           this.label11.AutoSize = true;
           this.label11.Location = new System.Drawing.Point(20, 26);
           this.label11.Name = "label11";
           this.label11.Size = new System.Drawing.Size(111, 13);
           this.label11.TabIndex = 9;
           this.label11.Text = "Servidor (TNS Name):";
           // 
           // txtSVR_Oracle
           // 
           this.txtSVR_Oracle.Location = new System.Drawing.Point(137, 23);
           this.txtSVR_Oracle.Name = "txtSVR_Oracle";
           this.txtSVR_Oracle.Size = new System.Drawing.Size(136, 20);
           this.txtSVR_Oracle.TabIndex = 10;
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
           // frmCfgSyncSIMSvc
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
           this.Name = "frmCfgSyncSIMSvc";
           this.ShowInTaskbar = false;
           this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
           this.Text = "Configuración del Servicio";
           this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.frmConfigurar_FormClosed);
           this.tabControl1.ResumeLayout(false);
           this.tabGeneral.ResumeLayout(false);
           this.tabGeneral.PerformLayout();
           ((System.ComponentModel.ISupportInitialize)(this.txtDiasLog)).EndInit();
           ((System.ComponentModel.ISupportInitialize)(this.txtFrecuencia)).EndInit();
           this.tabDBSEY.ResumeLayout(false);
           this.tabDBSEY.PerformLayout();
           this.tabDBOracle.ResumeLayout(false);
           this.tabDBOracle.PerformLayout();
           this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabDBSEY;
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
       private System.Windows.Forms.NumericUpDown txtFrecuencia;
       private System.Windows.Forms.Label label12;
       private System.Windows.Forms.Button btnProbar;
       private System.Windows.Forms.Label label1;
       private System.Windows.Forms.NumericUpDown txtDiasLog;
       private System.Windows.Forms.Label label2;
       private System.Windows.Forms.TabPage tabDBOracle;
       private System.Windows.Forms.Button btnProbar2;
       private System.Windows.Forms.Label label8;
       private System.Windows.Forms.TextBox txtPWD_Oracle;
       private System.Windows.Forms.Label label9;
       private System.Windows.Forms.TextBox txtUID_Oracle;
       private System.Windows.Forms.Label label11;
       private System.Windows.Forms.TextBox txtSVR_Oracle;
    }
}