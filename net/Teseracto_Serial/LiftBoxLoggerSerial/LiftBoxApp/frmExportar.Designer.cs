namespace LiftBoxApp
{
   partial class frmExportar
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
         this.label1 = new System.Windows.Forms.Label();
         this.label2 = new System.Windows.Forms.Label();
         this.uxRegistrosSinEnviar = new System.Windows.Forms.TextBox();
         this.label3 = new System.Windows.Forms.Label();
         this.btnExportar = new System.Windows.Forms.Button();
         this.btnCancelar = new System.Windows.Forms.Button();
         this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
         this.SuspendLayout();
         // 
         // label1
         // 
         this.label1.Location = new System.Drawing.Point(10, 9);
         this.label1.Name = "label1";
         this.label1.Size = new System.Drawing.Size(262, 84);
         this.label1.TabIndex = 3;
         this.label1.Text = "Esta funcion exporta a un archivo de texto los registros aún no enviados a SAP. \r" +
    "\n\r\nUna vez que se exportan a un archivo de texto, el sistema ya no intentará env" +
    "iarlos de manera automática.";
         // 
         // label2
         // 
         this.label2.AutoSize = true;
         this.label2.Location = new System.Drawing.Point(10, 109);
         this.label2.Name = "label2";
         this.label2.Size = new System.Drawing.Size(102, 13);
         this.label2.TabIndex = 4;
         this.label2.Text = "Registros sin enviar:";
         // 
         // uxRegistrosSinEnviar
         // 
         this.uxRegistrosSinEnviar.Location = new System.Drawing.Point(118, 106);
         this.uxRegistrosSinEnviar.Name = "uxRegistrosSinEnviar";
         this.uxRegistrosSinEnviar.ReadOnly = true;
         this.uxRegistrosSinEnviar.Size = new System.Drawing.Size(52, 20);
         this.uxRegistrosSinEnviar.TabIndex = 2;
         this.uxRegistrosSinEnviar.TabStop = false;
         this.uxRegistrosSinEnviar.Text = "999";
         // 
         // label3
         // 
         this.label3.Location = new System.Drawing.Point(10, 141);
         this.label3.Name = "label3";
         this.label3.Size = new System.Drawing.Size(262, 35);
         this.label3.TabIndex = 5;
         this.label3.Text = "¿Desea exportar los registros aún no enviados a SAP a un archivo de texto?";
         // 
         // btnExportar
         // 
         this.btnExportar.Location = new System.Drawing.Point(82, 179);
         this.btnExportar.Name = "btnExportar";
         this.btnExportar.Size = new System.Drawing.Size(88, 35);
         this.btnExportar.TabIndex = 1;
         this.btnExportar.Text = "Exportar...";
         this.btnExportar.UseVisualStyleBackColor = true;
         this.btnExportar.Click += new System.EventHandler(this.btnExportar_Click);
         // 
         // btnCancelar
         // 
         this.btnCancelar.Location = new System.Drawing.Point(184, 179);
         this.btnCancelar.Name = "btnCancelar";
         this.btnCancelar.Size = new System.Drawing.Size(88, 35);
         this.btnCancelar.TabIndex = 0;
         this.btnCancelar.Text = "Cancelar";
         this.btnCancelar.UseVisualStyleBackColor = true;
         this.btnCancelar.Click += new System.EventHandler(this.btnCancelar_Click);
         // 
         // frmExportar
         // 
         this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
         this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
         this.ClientSize = new System.Drawing.Size(284, 227);
         this.Controls.Add(this.btnCancelar);
         this.Controls.Add(this.btnExportar);
         this.Controls.Add(this.label3);
         this.Controls.Add(this.uxRegistrosSinEnviar);
         this.Controls.Add(this.label2);
         this.Controls.Add(this.label1);
         this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
         this.Name = "frmExportar";
         this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
         this.Text = "Exportar archivo de texto";
         this.Load += new System.EventHandler(this.frmExportar_Load);
         this.ResumeLayout(false);
         this.PerformLayout();

      }

      #endregion

      private System.Windows.Forms.Label label1;
      private System.Windows.Forms.Label label2;
      private System.Windows.Forms.TextBox uxRegistrosSinEnviar;
      private System.Windows.Forms.Label label3;
      private System.Windows.Forms.Button btnExportar;
      private System.Windows.Forms.Button btnCancelar;
      private System.Windows.Forms.SaveFileDialog saveFileDialog1;
   }
}