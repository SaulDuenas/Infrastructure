namespace SrvControlPanel
{
    partial class frmAcercade
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
           System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmAcercade));
           this.lblVersion = new System.Windows.Forms.Label();
           this.cmdAceptar = new System.Windows.Forms.Button();
           this.SuspendLayout();
           // 
           // lblVersion
           // 
           this.lblVersion.AutoSize = true;
           this.lblVersion.BackColor = System.Drawing.Color.Transparent;
           this.lblVersion.Location = new System.Drawing.Point(118, 195);
           this.lblVersion.Name = "lblVersion";
           this.lblVersion.Size = new System.Drawing.Size(45, 13);
           this.lblVersion.TabIndex = 1;
           this.lblVersion.Text = "Versión:";
           // 
           // cmdAceptar
           // 
           this.cmdAceptar.Location = new System.Drawing.Point(210, 249);
           this.cmdAceptar.Name = "cmdAceptar";
           this.cmdAceptar.Size = new System.Drawing.Size(75, 23);
           this.cmdAceptar.TabIndex = 5;
           this.cmdAceptar.Text = "&Aceptar";
           this.cmdAceptar.UseVisualStyleBackColor = true;
           this.cmdAceptar.Click += new System.EventHandler(this.cmdAceptar_Click);
           // 
           // frmAcercade
           // 
           this.AcceptButton = this.cmdAceptar;
           this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
           this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
           this.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("$this.BackgroundImage")));
           this.ClientSize = new System.Drawing.Size(494, 284);
           this.Controls.Add(this.cmdAceptar);
           this.Controls.Add(this.lblVersion);
           this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
           this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
           this.MaximizeBox = false;
           this.MinimizeBox = false;
           this.Name = "frmAcercade";
           this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
           this.Text = "Acerca de SEY - Consola de Control de Servicios";
           this.ResumeLayout(false);
           this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblVersion;
        private System.Windows.Forms.Button cmdAceptar;
    }
}