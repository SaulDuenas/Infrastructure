namespace SrvControlPanel
{
   partial class ucInViewCfg
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

      #region Component Designer generated code

      /// <summary> 
      /// Required method for Designer support - do not modify 
      /// the contents of this method with the code editor.
      /// </summary>
      private void InitializeComponent()
      {
          this.label1 = new System.Windows.Forms.Label();
          this.label2 = new System.Windows.Forms.Label();
          this.label3 = new System.Windows.Forms.Label();
          this.txtIPPort = new System.Windows.Forms.TextBox();
          this.txtDisplayAddress = new System.Windows.Forms.TextBox();
          this.txtIPAddress = new System.Windows.Forms.TextBox();
          this.label5 = new System.Windows.Forms.Label();
          this.label6 = new System.Windows.Forms.Label();
          this.txtFrecuencia = new System.Windows.Forms.NumericUpDown();
          ((System.ComponentModel.ISupportInitialize)(this.txtFrecuencia)).BeginInit();
          this.SuspendLayout();
          // 
          // label1
          // 
          this.label1.AutoSize = true;
          this.label1.Location = new System.Drawing.Point(5, 17);
          this.label1.Name = "label1";
          this.label1.Size = new System.Drawing.Size(68, 13);
          this.label1.TabIndex = 0;
          this.label1.Text = "Dirección IP:";
          this.label1.TextAlign = System.Drawing.ContentAlignment.TopRight;
          // 
          // label2
          // 
          this.label2.AutoSize = true;
          this.label2.Location = new System.Drawing.Point(183, 17);
          this.label2.Name = "label2";
          this.label2.Size = new System.Drawing.Size(41, 13);
          this.label2.TabIndex = 2;
          this.label2.Text = "Puerto:\r\n";
          this.label2.TextAlign = System.Drawing.ContentAlignment.TopRight;
          // 
          // label3
          // 
          this.label3.AutoSize = true;
          this.label3.Location = new System.Drawing.Point(5, 49);
          this.label3.Name = "label3";
          this.label3.Size = new System.Drawing.Size(84, 13);
          this.label3.TabIndex = 4;
          this.label3.Text = "Dirección Serial:";
          this.label3.TextAlign = System.Drawing.ContentAlignment.TopRight;
          // 
          // txtIPPort
          // 
          this.txtIPPort.Location = new System.Drawing.Point(225, 14);
          this.txtIPPort.Name = "txtIPPort";
          this.txtIPPort.Size = new System.Drawing.Size(45, 20);
          this.txtIPPort.TabIndex = 3;
          // 
          // txtDisplayAddress
          // 
          this.txtDisplayAddress.Location = new System.Drawing.Point(95, 46);
          this.txtDisplayAddress.Name = "txtDisplayAddress";
          this.txtDisplayAddress.Size = new System.Drawing.Size(45, 20);
          this.txtDisplayAddress.TabIndex = 5;
          // 
          // txtIPAddress
          // 
          this.txtIPAddress.Location = new System.Drawing.Point(79, 14);
          this.txtIPAddress.Name = "txtIPAddress";
          this.txtIPAddress.Size = new System.Drawing.Size(97, 20);
          this.txtIPAddress.TabIndex = 1;
          // 
          // label5
          // 
          this.label5.AutoSize = true;
          this.label5.Location = new System.Drawing.Point(143, 82);
          this.label5.Name = "label5";
          this.label5.Size = new System.Drawing.Size(53, 13);
          this.label5.TabIndex = 8;
          this.label5.Text = "segundos";
          // 
          // label6
          // 
          this.label6.AutoSize = true;
          this.label6.Location = new System.Drawing.Point(5, 81);
          this.label6.Name = "label6";
          this.label6.Size = new System.Drawing.Size(80, 13);
          this.label6.TabIndex = 6;
          this.label6.Text = "Refrescar cada";
          // 
          // txtFrecuencia
          // 
          this.txtFrecuencia.Location = new System.Drawing.Point(96, 78);
          this.txtFrecuencia.Name = "txtFrecuencia";
          this.txtFrecuencia.Size = new System.Drawing.Size(44, 20);
          this.txtFrecuencia.TabIndex = 7;
          this.txtFrecuencia.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
          // 
          // ucInViewCfg
          // 
          this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
          this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
          this.Controls.Add(this.label5);
          this.Controls.Add(this.label6);
          this.Controls.Add(this.txtFrecuencia);
          this.Controls.Add(this.txtIPAddress);
          this.Controls.Add(this.txtDisplayAddress);
          this.Controls.Add(this.txtIPPort);
          this.Controls.Add(this.label3);
          this.Controls.Add(this.label2);
          this.Controls.Add(this.label1);
          this.Name = "ucInViewCfg";
          this.Size = new System.Drawing.Size(279, 139);
          ((System.ComponentModel.ISupportInitialize)(this.txtFrecuencia)).EndInit();
          this.ResumeLayout(false);
          this.PerformLayout();

      }

      #endregion

      private System.Windows.Forms.Label label1;
      private System.Windows.Forms.Label label2;
      private System.Windows.Forms.Label label3;
      private System.Windows.Forms.TextBox txtIPPort;
      private System.Windows.Forms.TextBox txtDisplayAddress;
      private System.Windows.Forms.TextBox txtIPAddress;
      private System.Windows.Forms.Label label5;
      private System.Windows.Forms.Label label6;
      private System.Windows.Forms.NumericUpDown txtFrecuencia;
   }
}
