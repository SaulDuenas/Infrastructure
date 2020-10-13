namespace SrvControlPanel
{
    partial class frmSplash
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
           System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmSplash));
           this.lblVersion = new System.Windows.Forms.Label();
           this.SuspendLayout();
           // 
           // lblVersion
           // 
           this.lblVersion.AutoSize = true;
           this.lblVersion.BackColor = System.Drawing.Color.Transparent;
           this.lblVersion.Font = new System.Drawing.Font("Lucida Sans Unicode", 14F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
           this.lblVersion.ForeColor = System.Drawing.Color.Black;
           this.lblVersion.Location = new System.Drawing.Point(152, 240);
           this.lblVersion.Name = "lblVersion";
           this.lblVersion.Size = new System.Drawing.Size(159, 23);
           this.lblVersion.TabIndex = 0;
           this.lblVersion.Text = "Versión: 0.0.0.0";
           this.lblVersion.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
           // 
           // frmSplash
           // 
           this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
           this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
           this.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("$this.BackgroundImage")));
           this.ClientSize = new System.Drawing.Size(537, 286);
           this.Controls.Add(this.lblVersion);
           this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
           this.Name = "frmSplash";
           this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
           this.Text = "Splash";
           this.ResumeLayout(false);
           this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblVersion;
    }
}