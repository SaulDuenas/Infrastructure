namespace SrvControlPanel
{
   partial class frmSelCelda
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
          System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmSelCelda));
          System.Windows.Forms.ListViewItem listViewItem1 = new System.Windows.Forms.ListViewItem(new string[] {
            "1000001",
            "Celda de Trabajo 1"}, "Celda");
          System.Windows.Forms.ListViewItem listViewItem2 = new System.Windows.Forms.ListViewItem(new string[] {
            "1000002",
            "Celda de Trabajo 2"}, "Celda");
          System.Windows.Forms.ListViewItem listViewItem3 = new System.Windows.Forms.ListViewItem(new string[] {
            "1000003",
            "Celda de Trabajo 3"}, "Celda");
          System.Windows.Forms.ListViewItem listViewItem4 = new System.Windows.Forms.ListViewItem(new string[] {
            "1000004",
            "Celda de Trabajo 4"}, "Celda");
          System.Windows.Forms.ListViewItem listViewItem5 = new System.Windows.Forms.ListViewItem(new string[] {
            "1000005",
            "Celda de Trabajo 5"}, "Celda");
          System.Windows.Forms.ListViewItem listViewItem6 = new System.Windows.Forms.ListViewItem(new string[] {
            "1000006",
            "Celda de Trabajo 6"}, "Celda");
          System.Windows.Forms.ListViewItem listViewItem7 = new System.Windows.Forms.ListViewItem(new string[] {
            "1000007",
            "Celda de Trabajo 7"}, "Celda");
          System.Windows.Forms.ListViewItem listViewItem8 = new System.Windows.Forms.ListViewItem(new string[] {
            "1000008",
            "Celda de Trabajo 8"}, "Celda");
          this.imlIcons = new System.Windows.Forms.ImageList(this.components);
          this.lvCeldas = new System.Windows.Forms.ListView();
          this.colCelda = new System.Windows.Forms.ColumnHeader();
          this.colNombre = new System.Windows.Forms.ColumnHeader();
          this.btnAceptar = new System.Windows.Forms.Button();
          this.btnCancelar = new System.Windows.Forms.Button();
          this.SuspendLayout();
          // 
          // imlIcons
          // 
          this.imlIcons.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imlIcons.ImageStream")));
          this.imlIcons.TransparentColor = System.Drawing.Color.Transparent;
          this.imlIcons.Images.SetKeyName(0, "Celda");
          // 
          // lvCeldas
          // 
          this.lvCeldas.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                      | System.Windows.Forms.AnchorStyles.Left)
                      | System.Windows.Forms.AnchorStyles.Right)));
          this.lvCeldas.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.colCelda,
            this.colNombre});
          this.lvCeldas.Items.AddRange(new System.Windows.Forms.ListViewItem[] {
            listViewItem1,
            listViewItem2,
            listViewItem3,
            listViewItem4,
            listViewItem5,
            listViewItem6,
            listViewItem7,
            listViewItem8});
          this.lvCeldas.LargeImageList = this.imlIcons;
          this.lvCeldas.Location = new System.Drawing.Point(12, 12);
          this.lvCeldas.Name = "lvCeldas";
          this.lvCeldas.Size = new System.Drawing.Size(268, 221);
          this.lvCeldas.SmallImageList = this.imlIcons;
          this.lvCeldas.TabIndex = 4;
          this.lvCeldas.UseCompatibleStateImageBehavior = false;
          this.lvCeldas.View = System.Windows.Forms.View.Details;
          // 
          // colCelda
          // 
          this.colCelda.Text = "Celda";
          this.colCelda.Width = 76;
          // 
          // colNombre
          // 
          this.colNombre.Text = "Nombre";
          this.colNombre.Width = 182;
          // 
          // btnAceptar
          // 
          this.btnAceptar.Location = new System.Drawing.Point(102, 239);
          this.btnAceptar.Name = "btnAceptar";
          this.btnAceptar.Size = new System.Drawing.Size(86, 25);
          this.btnAceptar.TabIndex = 5;
          this.btnAceptar.Text = "&Aceptar";
          this.btnAceptar.UseVisualStyleBackColor = true;
          this.btnAceptar.Click += new System.EventHandler(this.btnAceptar_Click);
          // 
          // btnCancelar
          // 
          this.btnCancelar.DialogResult = System.Windows.Forms.DialogResult.Cancel;
          this.btnCancelar.Location = new System.Drawing.Point(194, 239);
          this.btnCancelar.Name = "btnCancelar";
          this.btnCancelar.Size = new System.Drawing.Size(86, 25);
          this.btnCancelar.TabIndex = 6;
          this.btnCancelar.Text = "&Cancelar";
          this.btnCancelar.UseVisualStyleBackColor = true;
          this.btnCancelar.Click += new System.EventHandler(this.btnCancelar_Click);
          // 
          // frmSelCelda
          // 
          this.AcceptButton = this.btnAceptar;
          this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
          this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
          this.CancelButton = this.btnCancelar;
          this.ClientSize = new System.Drawing.Size(292, 271);
          this.Controls.Add(this.btnCancelar);
          this.Controls.Add(this.btnAceptar);
          this.Controls.Add(this.lvCeldas);
          this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
          this.Name = "frmSelCelda";
          this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
          this.Text = "Seleccionar Celda de Trabajo";
          this.Load += new System.EventHandler(this.frmSelCelda_Load);
          this.ResumeLayout(false);

      }

      #endregion

      private System.Windows.Forms.ImageList imlIcons;
      private System.Windows.Forms.ListView lvCeldas;
      private System.Windows.Forms.ColumnHeader colCelda;
      private System.Windows.Forms.ColumnHeader colNombre;
      private System.Windows.Forms.Button btnAceptar;
      private System.Windows.Forms.Button btnCancelar;
   }
}