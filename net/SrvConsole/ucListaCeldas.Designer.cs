namespace SrvControlPanel
{
   partial class ucListaCeldas
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
         this.components = new System.ComponentModel.Container();
         System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ucListaCeldas));
         System.Windows.Forms.ListViewItem listViewItem1 = new System.Windows.Forms.ListViewItem(new string[] {
            "1000001",
            "Celda de Trabajo 1"}, "Celda");
         System.Windows.Forms.ListViewItem listViewItem2 = new System.Windows.Forms.ListViewItem(new string[] {
            "1000002",
            "Celda de Trabajo 2"}, "Celda");
         this.btnQuitar = new System.Windows.Forms.Button();
         this.imlIcons = new System.Windows.Forms.ImageList(this.components);
         this.btnAgregar = new System.Windows.Forms.Button();
         this.lvCeldas = new System.Windows.Forms.ListView();
         this.colCelda = new System.Windows.Forms.ColumnHeader();
         this.colNombre = new System.Windows.Forms.ColumnHeader();
         this.SuspendLayout();
         // 
         // btnQuitar
         // 
         this.btnQuitar.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
         this.btnQuitar.Location = new System.Drawing.Point(242, 97);
         this.btnQuitar.Name = "btnQuitar";
         this.btnQuitar.Size = new System.Drawing.Size(55, 23);
         this.btnQuitar.TabIndex = 5;
         this.btnQuitar.Text = "Quitar";
         this.btnQuitar.UseVisualStyleBackColor = true;
         this.btnQuitar.Click += new System.EventHandler(this.btnQuitar_Click);
         // 
         // imlIcons
         // 
         this.imlIcons.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imlIcons.ImageStream")));
         this.imlIcons.TransparentColor = System.Drawing.Color.Transparent;
         this.imlIcons.Images.SetKeyName(0, "Celda");
         // 
         // btnAgregar
         // 
         this.btnAgregar.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
         this.btnAgregar.Location = new System.Drawing.Point(181, 97);
         this.btnAgregar.Name = "btnAgregar";
         this.btnAgregar.Size = new System.Drawing.Size(55, 23);
         this.btnAgregar.TabIndex = 4;
         this.btnAgregar.Text = "Agregar";
         this.btnAgregar.UseVisualStyleBackColor = true;
         this.btnAgregar.Click += new System.EventHandler(this.btnAgregar_Click);
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
            listViewItem2});
         this.lvCeldas.LargeImageList = this.imlIcons;
         this.lvCeldas.Location = new System.Drawing.Point(0, 0);
         this.lvCeldas.Name = "lvCeldas";
         this.lvCeldas.Size = new System.Drawing.Size(297, 91);
         this.lvCeldas.SmallImageList = this.imlIcons;
         this.lvCeldas.TabIndex = 3;
         this.lvCeldas.UseCompatibleStateImageBehavior = false;
         this.lvCeldas.View = System.Windows.Forms.View.Details;
         // 
         // colCelda
         // 
         this.colCelda.Text = "Celda";
         this.colCelda.Width = 80;
         // 
         // colNombre
         // 
         this.colNombre.Text = "Nombre";
         this.colNombre.Width = 208;
         // 
         // ucListaCeldas
         // 
         this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
         this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
         this.Controls.Add(this.btnQuitar);
         this.Controls.Add(this.btnAgregar);
         this.Controls.Add(this.lvCeldas);
         this.Name = "ucListaCeldas";
         this.Size = new System.Drawing.Size(298, 121);
         this.ResumeLayout(false);

      }

      #endregion

      private System.Windows.Forms.Button btnQuitar;
      private System.Windows.Forms.ImageList imlIcons;
      private System.Windows.Forms.Button btnAgregar;
      private System.Windows.Forms.ListView lvCeldas;
      private System.Windows.Forms.ColumnHeader colCelda;
      private System.Windows.Forms.ColumnHeader colNombre;
   }
}
