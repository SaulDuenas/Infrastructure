namespace SrvControlPanel
{
   partial class frmAvance
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
         this.progressBar1 = new System.Windows.Forms.ProgressBar();
         this.btnDetener = new System.Windows.Forms.Button();
         this.label1 = new System.Windows.Forms.Label();
         this.label2 = new System.Windows.Forms.Label();
         this.lblPorcentaje = new System.Windows.Forms.Label();
         this.lblMensajes = new System.Windows.Forms.Label();
         this.SuspendLayout();
         // 
         // progressBar1
         // 
         this.progressBar1.BackColor = System.Drawing.SystemColors.Window;
         this.progressBar1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(0)))));
         this.progressBar1.Location = new System.Drawing.Point(12, 36);
         this.progressBar1.Name = "progressBar1";
         this.progressBar1.Size = new System.Drawing.Size(296, 14);
         this.progressBar1.TabIndex = 0;
         // 
         // btnDetener
         // 
         this.btnDetener.Location = new System.Drawing.Point(93, 62);
         this.btnDetener.Name = "btnDetener";
         this.btnDetener.Size = new System.Drawing.Size(135, 27);
         this.btnDetener.TabIndex = 1;
         this.btnDetener.Text = "Detener";
         this.btnDetener.UseVisualStyleBackColor = true;
         this.btnDetener.Click += new System.EventHandler(this.btnDetener_Click);
         // 
         // label1
         // 
         this.label1.AutoSize = true;
         this.label1.Location = new System.Drawing.Point(8, 9);
         this.label1.Name = "label1";
         this.label1.Size = new System.Drawing.Size(87, 13);
         this.label1.TabIndex = 2;
         this.label1.Text = "Mensajes leídos:";
         // 
         // label2
         // 
         this.label2.AutoSize = true;
         this.label2.Location = new System.Drawing.Point(224, 9);
         this.label2.Name = "label2";
         this.label2.Size = new System.Drawing.Size(47, 13);
         this.label2.TabIndex = 2;
         this.label2.Text = "Avance:";
         // 
         // lblPorcentaje
         // 
         this.lblPorcentaje.AutoSize = true;
         this.lblPorcentaje.Location = new System.Drawing.Point(280, 9);
         this.lblPorcentaje.Name = "lblPorcentaje";
         this.lblPorcentaje.Size = new System.Drawing.Size(27, 13);
         this.lblPorcentaje.TabIndex = 2;
         this.lblPorcentaje.Text = "10%";
         // 
         // lblMensajes
         // 
         this.lblMensajes.AutoSize = true;
         this.lblMensajes.Location = new System.Drawing.Point(96, 9);
         this.lblMensajes.Name = "lblMensajes";
         this.lblMensajes.Size = new System.Drawing.Size(37, 13);
         this.lblMensajes.TabIndex = 2;
         this.lblMensajes.Text = "00000";
         // 
         // frmAvance
         // 
         this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
         this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
         this.ClientSize = new System.Drawing.Size(317, 98);
         this.Controls.Add(this.lblMensajes);
         this.Controls.Add(this.lblPorcentaje);
         this.Controls.Add(this.label2);
         this.Controls.Add(this.label1);
         this.Controls.Add(this.btnDetener);
         this.Controls.Add(this.progressBar1);
         this.Name = "frmAvance";
         this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
         this.Text = "Refrescando Log";
         this.ResumeLayout(false);
         this.PerformLayout();

      }

      #endregion

      private System.Windows.Forms.ProgressBar progressBar1;
      private System.Windows.Forms.Button btnDetener;
      private System.Windows.Forms.Label label1;
      private System.Windows.Forms.Label label2;
      private System.Windows.Forms.Label lblPorcentaje;
      private System.Windows.Forms.Label lblMensajes;
   }
}