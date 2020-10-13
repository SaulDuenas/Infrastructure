namespace SrvControlPanel
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
            System.Windows.Forms.ToolStripContainer toolStripContainer1;
            System.Windows.Forms.TreeNode treeNode1 = new System.Windows.Forms.TreeNode("Mensajes a InViews");
            System.Windows.Forms.TreeNode treeNode2 = new System.Windows.Forms.TreeNode("Notificaciones a SIM");
            System.Windows.Forms.TreeNode treeNode3 = new System.Windows.Forms.TreeNode("Aplicación", new System.Windows.Forms.TreeNode[] {
            treeNode1,
            treeNode2});
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmMain));
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.panelStatus = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripEspacio = new System.Windows.Forms.ToolStripStatusLabel();
            this.progressBar = new System.Windows.Forms.ToolStripProgressBar();
            this.lblPorcAvance = new System.Windows.Forms.ToolStripStatusLabel();
            this.lblBtnCancelar = new System.Windows.Forms.ToolStripStatusLabel();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.tvServicios = new System.Windows.Forms.TreeView();
            this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.mnuCtxNombreServicio = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.mnuCtxPlay = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuCtxStop = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuCtxConfig = new System.Windows.Forms.ToolStripMenuItem();
            this.imlIcons = new System.Windows.Forms.ImageList(this.components);
            this.lvLog = new System.Windows.Forms.ListView();
            this.Tipo = new System.Windows.Forms.ColumnHeader();
            this.FechaHora = new System.Windows.Forms.ColumnHeader();
            this.Codigo = new System.Windows.Forms.ColumnHeader();
            this.Mensaje = new System.Windows.Forms.ColumnHeader();
            this.lvEstatusServicios = new System.Windows.Forms.ListView();
            this.Servicio = new System.Windows.Forms.ColumnHeader();
            this.Estatus = new System.Windows.Forms.ColumnHeader();
            this.label1 = new System.Windows.Forms.Label();
            this.toolStripPrincipal = new System.Windows.Forms.ToolStrip();
            this.btnStop = new System.Windows.Forms.ToolStripButton();
            this.btnPlay = new System.Windows.Forms.ToolStripButton();
            this.btnConfigurar = new System.Windows.Forms.ToolStripButton();
            this.toolStripSecundaria = new System.Windows.Forms.ToolStrip();
            this.btnLogDetalle = new System.Windows.Forms.ToolStripSplitButton();
            this.btnLogDebug = new System.Windows.Forms.ToolStripMenuItem();
            this.btnLogInfo = new System.Windows.Forms.ToolStripMenuItem();
            this.btnLogWarning = new System.Windows.Forms.ToolStripMenuItem();
            this.btnLogError = new System.Windows.Forms.ToolStripMenuItem();
            this.cmbDiasLog = new System.Windows.Forms.ToolStripComboBox();
            this.btnRefrescarLog = new System.Windows.Forms.ToolStripButton();
            this.btnAbrirFolderLogs = new System.Windows.Forms.ToolStripButton();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.archivoToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.salirToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuServicio = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuSrvPlay = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuSrvStop = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.mnuSrvConfigurar = new System.Windows.Forms.ToolStripMenuItem();
            this.herramientasToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuRefrescarLog = new System.Windows.Forms.ToolStripMenuItem();
            this.ayudaToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuAcercaDe = new System.Windows.Forms.ToolStripMenuItem();
            this.archivoToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.salirToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.servicioToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.herramientasToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.ayudaToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.acercaDeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripStatusLabel1 = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusLabel2 = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusLabel3 = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusLabel4 = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripButton4 = new System.Windows.Forms.ToolStripButton();
            this.timerEstatusServicios = new System.Windows.Forms.Timer(this.components);
            this.toolStripButton5 = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton1 = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton2 = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton3 = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton6 = new System.Windows.Forms.ToolStripButton();
            toolStripContainer1 = new System.Windows.Forms.ToolStripContainer();
            toolStripContainer1.BottomToolStripPanel.SuspendLayout();
            toolStripContainer1.ContentPanel.SuspendLayout();
            toolStripContainer1.TopToolStripPanel.SuspendLayout();
            toolStripContainer1.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.contextMenuStrip1.SuspendLayout();
            this.toolStripPrincipal.SuspendLayout();
            this.toolStripSecundaria.SuspendLayout();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // toolStripContainer1
            // 
            // 
            // toolStripContainer1.BottomToolStripPanel
            // 
            toolStripContainer1.BottomToolStripPanel.Controls.Add(this.statusStrip1);
            // 
            // toolStripContainer1.ContentPanel
            // 
            toolStripContainer1.ContentPanel.Controls.Add(this.splitContainer1);
            toolStripContainer1.ContentPanel.Size = new System.Drawing.Size(652, 239);
            toolStripContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            toolStripContainer1.Location = new System.Drawing.Point(0, 24);
            toolStripContainer1.Name = "toolStripContainer1";
            toolStripContainer1.Size = new System.Drawing.Size(652, 286);
            toolStripContainer1.TabIndex = 5;
            toolStripContainer1.Text = "toolStripContainer1";
            // 
            // toolStripContainer1.TopToolStripPanel
            // 
            toolStripContainer1.TopToolStripPanel.Controls.Add(this.toolStripPrincipal);
            toolStripContainer1.TopToolStripPanel.Controls.Add(this.toolStripSecundaria);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.statusStrip1.Dock = System.Windows.Forms.DockStyle.None;
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.panelStatus,
            this.toolStripEspacio,
            this.progressBar,
            this.lblPorcAvance,
            this.lblBtnCancelar});
            this.statusStrip1.Location = new System.Drawing.Point(0, 0);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(652, 22);
            this.statusStrip1.TabIndex = 1;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // panelStatus
            // 
            this.panelStatus.Name = "panelStatus";
            this.panelStatus.Size = new System.Drawing.Size(68, 17);
            this.panelStatus.Text = "panelStatus";
            // 
            // toolStripEspacio
            // 
            this.toolStripEspacio.Name = "toolStripEspacio";
            this.toolStripEspacio.Size = new System.Drawing.Size(569, 17);
            this.toolStripEspacio.Spring = true;
            // 
            // progressBar
            // 
            this.progressBar.BackColor = System.Drawing.SystemColors.Window;
            this.progressBar.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(0)))));
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(300, 18);
            this.progressBar.Value = 50;
            this.progressBar.Visible = false;
            // 
            // lblPorcAvance
            // 
            this.lblPorcAvance.Name = "lblPorcAvance";
            this.lblPorcAvance.Size = new System.Drawing.Size(29, 19);
            this.lblPorcAvance.Text = "10%";
            this.lblPorcAvance.Visible = false;
            // 
            // lblBtnCancelar
            // 
            this.lblBtnCancelar.BorderSides = ((System.Windows.Forms.ToolStripStatusLabelBorderSides)((((System.Windows.Forms.ToolStripStatusLabelBorderSides.Left | System.Windows.Forms.ToolStripStatusLabelBorderSides.Top)
                        | System.Windows.Forms.ToolStripStatusLabelBorderSides.Right)
                        | System.Windows.Forms.ToolStripStatusLabelBorderSides.Bottom)));
            this.lblBtnCancelar.BorderStyle = System.Windows.Forms.Border3DStyle.Raised;
            this.lblBtnCancelar.Name = "lblBtnCancelar";
            this.lblBtnCancelar.Size = new System.Drawing.Size(57, 19);
            this.lblBtnCancelar.Text = "Cancelar";
            this.lblBtnCancelar.Visible = false;
            this.lblBtnCancelar.Click += new System.EventHandler(this.lblBtnCancelar_Click);
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.FixedPanel = System.Windows.Forms.FixedPanel.Panel1;
            this.splitContainer1.Location = new System.Drawing.Point(0, 0);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.tvServicios);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.lvLog);
            this.splitContainer1.Panel2.Controls.Add(this.lvEstatusServicios);
            this.splitContainer1.Panel2.Controls.Add(this.label1);
            this.splitContainer1.Size = new System.Drawing.Size(652, 239);
            this.splitContainer1.SplitterDistance = 220;
            this.splitContainer1.TabIndex = 4;
            this.splitContainer1.TabStop = false;
            // 
            // tvServicios
            // 
            this.tvServicios.ContextMenuStrip = this.contextMenuStrip1;
            this.tvServicios.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tvServicios.HideSelection = false;
            this.tvServicios.ImageIndex = 0;
            this.tvServicios.ImageList = this.imlIcons;
            this.tvServicios.Indent = 20;
            this.tvServicios.Location = new System.Drawing.Point(0, 0);
            this.tvServicios.Name = "tvServicios";
            treeNode1.Name = "tvnInViewSvc";
            treeNode1.Text = "Mensajes a InViews";
            treeNode2.Name = "tvnSyncSIMSvc";
            treeNode2.Text = "Notificaciones a SIM";
            treeNode3.Name = "tvnAplicacion";
            treeNode3.Text = "Aplicación";
            this.tvServicios.Nodes.AddRange(new System.Windows.Forms.TreeNode[] {
            treeNode3});
            this.tvServicios.SelectedImageIndex = 0;
            this.tvServicios.Size = new System.Drawing.Size(220, 239);
            this.tvServicios.TabIndex = 0;
            this.tvServicios.AfterSelect += new System.Windows.Forms.TreeViewEventHandler(this.tvServicios_AfterSelect);
            this.tvServicios.NodeMouseClick += new System.Windows.Forms.TreeNodeMouseClickEventHandler(this.tvServicios_NodeMouseClick);
            // 
            // contextMenuStrip1
            // 
            this.contextMenuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuCtxNombreServicio,
            this.toolStripSeparator2,
            this.mnuCtxPlay,
            this.mnuCtxStop,
            this.mnuCtxConfig});
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new System.Drawing.Size(163, 98);
            this.contextMenuStrip1.Opening += new System.ComponentModel.CancelEventHandler(this.contextMenuStrip1_Opening);
            // 
            // mnuCtxNombreServicio
            // 
            this.mnuCtxNombreServicio.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.mnuCtxNombreServicio.Enabled = false;
            this.mnuCtxNombreServicio.Name = "mnuCtxNombreServicio";
            this.mnuCtxNombreServicio.Size = new System.Drawing.Size(162, 22);
            this.mnuCtxNombreServicio.Text = "Nombre Servicio";
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(159, 6);
            // 
            // mnuCtxPlay
            // 
            this.mnuCtxPlay.Image = global::SrvControlPanel.Properties.Resources.Play;
            this.mnuCtxPlay.Name = "mnuCtxPlay";
            this.mnuCtxPlay.Size = new System.Drawing.Size(162, 22);
            this.mnuCtxPlay.Text = "Iniciar";
            this.mnuCtxPlay.Click += new System.EventHandler(this.mnuCtxPlay_Click);
            // 
            // mnuCtxStop
            // 
            this.mnuCtxStop.Image = global::SrvControlPanel.Properties.Resources.Stop;
            this.mnuCtxStop.Name = "mnuCtxStop";
            this.mnuCtxStop.Size = new System.Drawing.Size(162, 22);
            this.mnuCtxStop.Text = "Detener";
            this.mnuCtxStop.Click += new System.EventHandler(this.mnuCtxStop_Click);
            // 
            // mnuCtxConfig
            // 
            this.mnuCtxConfig.Image = global::SrvControlPanel.Properties.Resources.Propiedades;
            this.mnuCtxConfig.Name = "mnuCtxConfig";
            this.mnuCtxConfig.Size = new System.Drawing.Size(162, 22);
            this.mnuCtxConfig.Text = "Configurar...";
            this.mnuCtxConfig.Click += new System.EventHandler(this.mnuCtxConfig_Click);
            // 
            // imlIcons
            // 
            this.imlIcons.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imlIcons.ImageStream")));
            this.imlIcons.TransparentColor = System.Drawing.Color.Transparent;
            this.imlIcons.Images.SetKeyName(0, "Rojo");
            this.imlIcons.Images.SetKeyName(1, "Amarillo");
            this.imlIcons.Images.SetKeyName(2, "Verde");
            this.imlIcons.Images.SetKeyName(3, "Warning");
            this.imlIcons.Images.SetKeyName(4, "DBG");
            this.imlIcons.Images.SetKeyName(5, "INF");
            this.imlIcons.Images.SetKeyName(6, "WRN");
            this.imlIcons.Images.SetKeyName(7, "ERR");
            this.imlIcons.Images.SetKeyName(8, "???");
            this.imlIcons.Images.SetKeyName(9, "Play.ico");
            this.imlIcons.Images.SetKeyName(10, "Play2.ico");
            this.imlIcons.Images.SetKeyName(11, "Stop.ico");
            this.imlIcons.Images.SetKeyName(12, "Stop2.ico");
            this.imlIcons.Images.SetKeyName(13, "EngraneXX");
            this.imlIcons.Images.SetKeyName(14, "Engrane");
            this.imlIcons.Images.SetKeyName(15, "engranes2.ico");
            this.imlIcons.Images.SetKeyName(16, "");
            this.imlIcons.Images.SetKeyName(17, "");
            this.imlIcons.Images.SetKeyName(18, "");
            this.imlIcons.Images.SetKeyName(19, "");
            this.imlIcons.Images.SetKeyName(20, "");
            this.imlIcons.Images.SetKeyName(21, "");
            this.imlIcons.Images.SetKeyName(22, "");
            this.imlIcons.Images.SetKeyName(23, "");
            this.imlIcons.Images.SetKeyName(24, "");
            this.imlIcons.Images.SetKeyName(25, "");
            this.imlIcons.Images.SetKeyName(26, "");
            this.imlIcons.Images.SetKeyName(27, "");
            this.imlIcons.Images.SetKeyName(28, "");
            this.imlIcons.Images.SetKeyName(29, "");
            this.imlIcons.Images.SetKeyName(30, "");
            this.imlIcons.Images.SetKeyName(31, "");
            this.imlIcons.Images.SetKeyName(32, "");
            this.imlIcons.Images.SetKeyName(33, "");
            this.imlIcons.Images.SetKeyName(34, "");
            this.imlIcons.Images.SetKeyName(35, "");
            this.imlIcons.Images.SetKeyName(36, "");
            this.imlIcons.Images.SetKeyName(37, "");
            this.imlIcons.Images.SetKeyName(38, "");
            // 
            // lvLog
            // 
            this.lvLog.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.Tipo,
            this.FechaHora,
            this.Codigo,
            this.Mensaje});
            this.lvLog.FullRowSelect = true;
            this.lvLog.Location = new System.Drawing.Point(32, 132);
            this.lvLog.Name = "lvLog";
            this.lvLog.Size = new System.Drawing.Size(278, 88);
            this.lvLog.SmallImageList = this.imlIcons;
            this.lvLog.TabIndex = 1;
            this.lvLog.UseCompatibleStateImageBehavior = false;
            this.lvLog.View = System.Windows.Forms.View.Details;
            this.lvLog.Visible = false;
            // 
            // Tipo
            // 
            this.Tipo.Text = "Tipo";
            // 
            // FechaHora
            // 
            this.FechaHora.Text = "Fecha - Hora";
            this.FechaHora.Width = 81;
            // 
            // Codigo
            // 
            this.Codigo.Text = "Código";
            this.Codigo.Width = 100;
            // 
            // Mensaje
            // 
            this.Mensaje.Text = "Mensaje";
            this.Mensaje.Width = 132;
            // 
            // lvEstatusServicios
            // 
            this.lvEstatusServicios.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.Servicio,
            this.Estatus});
            this.lvEstatusServicios.Location = new System.Drawing.Point(36, 56);
            this.lvEstatusServicios.Name = "lvEstatusServicios";
            this.lvEstatusServicios.Size = new System.Drawing.Size(285, 66);
            this.lvEstatusServicios.SmallImageList = this.imlIcons;
            this.lvEstatusServicios.TabIndex = 0;
            this.lvEstatusServicios.UseCompatibleStateImageBehavior = false;
            this.lvEstatusServicios.View = System.Windows.Forms.View.Details;
            this.lvEstatusServicios.Visible = false;
            // 
            // Servicio
            // 
            this.Servicio.Text = "Servicio";
            this.Servicio.Width = 90;
            // 
            // Estatus
            // 
            this.Estatus.Text = "Estatus";
            this.Estatus.Width = 94;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(24, 24);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(145, 25);
            this.label1.TabIndex = 2;
            this.label1.Text = "Procesando...";
            // 
            // toolStripPrincipal
            // 
            this.toolStripPrincipal.Dock = System.Windows.Forms.DockStyle.None;
            this.toolStripPrincipal.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.btnStop,
            this.btnPlay,
            this.btnConfigurar});
            this.toolStripPrincipal.Location = new System.Drawing.Point(3, 0);
            this.toolStripPrincipal.Name = "toolStripPrincipal";
            this.toolStripPrincipal.Size = new System.Drawing.Size(81, 25);
            this.toolStripPrincipal.TabIndex = 0;
            // 
            // btnStop
            // 
            this.btnStop.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnStop.Image = global::SrvControlPanel.Properties.Resources.Stop;
            this.btnStop.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnStop.Name = "btnStop";
            this.btnStop.Size = new System.Drawing.Size(23, 22);
            this.btnStop.Text = "Stop";
            this.btnStop.ToolTipText = "Detener";
            this.btnStop.Click += new System.EventHandler(this.btnStop_Click);
            // 
            // btnPlay
            // 
            this.btnPlay.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnPlay.Image = global::SrvControlPanel.Properties.Resources.Play;
            this.btnPlay.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnPlay.Name = "btnPlay";
            this.btnPlay.Size = new System.Drawing.Size(23, 22);
            this.btnPlay.Text = "Play";
            this.btnPlay.ToolTipText = "Iniciar";
            this.btnPlay.Click += new System.EventHandler(this.btnPlay_Click);
            // 
            // btnConfigurar
            // 
            this.btnConfigurar.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnConfigurar.Image = global::SrvControlPanel.Properties.Resources.Propiedades;
            this.btnConfigurar.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnConfigurar.Name = "btnConfigurar";
            this.btnConfigurar.Size = new System.Drawing.Size(23, 22);
            this.btnConfigurar.Text = "Configurar";
            this.btnConfigurar.Click += new System.EventHandler(this.btnConfigurar_Click);
            // 
            // toolStripSecundaria
            // 
            this.toolStripSecundaria.Dock = System.Windows.Forms.DockStyle.None;
            this.toolStripSecundaria.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.btnLogDetalle,
            this.cmbDiasLog,
            this.btnRefrescarLog,
            this.btnAbrirFolderLogs});
            this.toolStripSecundaria.Location = new System.Drawing.Point(84, 0);
            this.toolStripSecundaria.Name = "toolStripSecundaria";
            this.toolStripSecundaria.Size = new System.Drawing.Size(238, 25);
            this.toolStripSecundaria.TabIndex = 1;
            // 
            // btnLogDetalle
            // 
            this.btnLogDetalle.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.btnLogDebug,
            this.btnLogInfo,
            this.btnLogWarning,
            this.btnLogError});
            this.btnLogDetalle.Image = global::SrvControlPanel.Properties.Resources.Address_Books;
            this.btnLogDetalle.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnLogDetalle.Name = "btnLogDetalle";
            this.btnLogDetalle.Size = new System.Drawing.Size(98, 22);
            this.btnLogDetalle.Text = "Detalle Log";
            this.btnLogDetalle.ToolTipText = "Nivel de detalle de visualización de logs";
            this.btnLogDetalle.Click += new System.EventHandler(this.BotonesDetalleLog_Click);
            // 
            // btnLogDebug
            // 
            this.btnLogDebug.Image = global::SrvControlPanel.Properties.Resources.Debug2;
            this.btnLogDebug.Name = "btnLogDebug";
            this.btnLogDebug.Size = new System.Drawing.Size(152, 22);
            this.btnLogDebug.Tag = "";
            this.btnLogDebug.Text = "Depuración";
            this.btnLogDebug.Click += new System.EventHandler(this.BotonesDetalleLog_Click);
            // 
            // btnLogInfo
            // 
            this.btnLogInfo.Checked = true;
            this.btnLogInfo.CheckState = System.Windows.Forms.CheckState.Checked;
            this.btnLogInfo.Image = global::SrvControlPanel.Properties.Resources.Info;
            this.btnLogInfo.Name = "btnLogInfo";
            this.btnLogInfo.Size = new System.Drawing.Size(152, 22);
            this.btnLogInfo.Tag = "";
            this.btnLogInfo.Text = "Información";
            this.btnLogInfo.Click += new System.EventHandler(this.BotonesDetalleLog_Click);
            // 
            // btnLogWarning
            // 
            this.btnLogWarning.Checked = true;
            this.btnLogWarning.CheckState = System.Windows.Forms.CheckState.Checked;
            this.btnLogWarning.Image = global::SrvControlPanel.Properties.Resources.YellowBig;
            this.btnLogWarning.Name = "btnLogWarning";
            this.btnLogWarning.Size = new System.Drawing.Size(152, 22);
            this.btnLogWarning.Tag = "";
            this.btnLogWarning.Text = "Advertencias";
            this.btnLogWarning.Click += new System.EventHandler(this.BotonesDetalleLog_Click);
            // 
            // btnLogError
            // 
            this.btnLogError.Checked = true;
            this.btnLogError.CheckState = System.Windows.Forms.CheckState.Checked;
            this.btnLogError.Image = global::SrvControlPanel.Properties.Resources.Error;
            this.btnLogError.Name = "btnLogError";
            this.btnLogError.Size = new System.Drawing.Size(152, 22);
            this.btnLogError.Tag = "";
            this.btnLogError.Text = "Errores";
            this.btnLogError.Click += new System.EventHandler(this.BotonesDetalleLog_Click);
            // 
            // cmbDiasLog
            // 
            this.cmbDiasLog.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbDiasLog.Items.AddRange(new object[] {
            "Hoy",
            "Desde ayer",
            "Hace 3 días",
            "Hace 4 días"});
            this.cmbDiasLog.MaxDropDownItems = 4;
            this.cmbDiasLog.Name = "cmbDiasLog";
            this.cmbDiasLog.Size = new System.Drawing.Size(80, 25);
            this.cmbDiasLog.ToolTipText = "Días de visualización de logs";
            this.cmbDiasLog.SelectedIndexChanged += new System.EventHandler(this.cmbDiasLog_SelectedIndexChanged);
            // 
            // btnRefrescarLog
            // 
            this.btnRefrescarLog.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnRefrescarLog.Image = global::SrvControlPanel.Properties.Resources.REFRESH;
            this.btnRefrescarLog.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnRefrescarLog.Name = "btnRefrescarLog";
            this.btnRefrescarLog.Size = new System.Drawing.Size(23, 22);
            this.btnRefrescarLog.Text = "Refrescar Log";
            this.btnRefrescarLog.Click += new System.EventHandler(this.btnRefrescarLog_Click);
            // 
            // btnAbrirFolderLogs
            // 
            this.btnAbrirFolderLogs.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnAbrirFolderLogs.Image = global::SrvControlPanel.Properties.Resources.OpenFolder;
            this.btnAbrirFolderLogs.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnAbrirFolderLogs.Name = "btnAbrirFolderLogs";
            this.btnAbrirFolderLogs.Size = new System.Drawing.Size(23, 22);
            this.btnAbrirFolderLogs.Text = "Abrir Folder de Logs";
            this.btnAbrirFolderLogs.Click += new System.EventHandler(this.btnAbrirFolderLogs_Click);
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.archivoToolStripMenuItem1,
            this.mnuServicio,
            this.herramientasToolStripMenuItem1,
            this.ayudaToolStripMenuItem1});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(652, 24);
            this.menuStrip1.TabIndex = 0;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // archivoToolStripMenuItem1
            // 
            this.archivoToolStripMenuItem1.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.salirToolStripMenuItem1});
            this.archivoToolStripMenuItem1.Name = "archivoToolStripMenuItem1";
            this.archivoToolStripMenuItem1.Size = new System.Drawing.Size(60, 20);
            this.archivoToolStripMenuItem1.Text = "&Archivo";
            // 
            // salirToolStripMenuItem1
            // 
            this.salirToolStripMenuItem1.Name = "salirToolStripMenuItem1";
            this.salirToolStripMenuItem1.Size = new System.Drawing.Size(96, 22);
            this.salirToolStripMenuItem1.Text = "&Salir";
            this.salirToolStripMenuItem1.Click += new System.EventHandler(this.salirToolStripMenuItem1_Click);
            // 
            // mnuServicio
            // 
            this.mnuServicio.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuSrvPlay,
            this.mnuSrvStop,
            this.toolStripSeparator1,
            this.mnuSrvConfigurar});
            this.mnuServicio.Name = "mnuServicio";
            this.mnuServicio.Size = new System.Drawing.Size(60, 20);
            this.mnuServicio.Text = "Servicio";
            // 
            // mnuSrvPlay
            // 
            this.mnuSrvPlay.Image = global::SrvControlPanel.Properties.Resources.Play;
            this.mnuSrvPlay.Name = "mnuSrvPlay";
            this.mnuSrvPlay.Size = new System.Drawing.Size(140, 22);
            this.mnuSrvPlay.Text = "&Iniciar";
            this.mnuSrvPlay.Click += new System.EventHandler(this.mnuSrvPlay_Click);
            // 
            // mnuSrvStop
            // 
            this.mnuSrvStop.Image = global::SrvControlPanel.Properties.Resources.Stop;
            this.mnuSrvStop.Name = "mnuSrvStop";
            this.mnuSrvStop.Size = new System.Drawing.Size(140, 22);
            this.mnuSrvStop.Text = "&Detener";
            this.mnuSrvStop.Click += new System.EventHandler(this.mnuSrvStop_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(137, 6);
            // 
            // mnuSrvConfigurar
            // 
            this.mnuSrvConfigurar.Image = global::SrvControlPanel.Properties.Resources.Propiedades;
            this.mnuSrvConfigurar.Name = "mnuSrvConfigurar";
            this.mnuSrvConfigurar.Size = new System.Drawing.Size(140, 22);
            this.mnuSrvConfigurar.Text = "&Configurar...";
            this.mnuSrvConfigurar.Click += new System.EventHandler(this.mnuSrvConfigurar_Click);
            // 
            // herramientasToolStripMenuItem1
            // 
            this.herramientasToolStripMenuItem1.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuRefrescarLog});
            this.herramientasToolStripMenuItem1.Name = "herramientasToolStripMenuItem1";
            this.herramientasToolStripMenuItem1.Size = new System.Drawing.Size(90, 20);
            this.herramientasToolStripMenuItem1.Text = "&Herramientas";
            // 
            // mnuRefrescarLog
            // 
            this.mnuRefrescarLog.Image = global::SrvControlPanel.Properties.Resources.REFRESH;
            this.mnuRefrescarLog.Name = "mnuRefrescarLog";
            this.mnuRefrescarLog.ShortcutKeys = System.Windows.Forms.Keys.F5;
            this.mnuRefrescarLog.Size = new System.Drawing.Size(164, 22);
            this.mnuRefrescarLog.Text = "Refrescar Log";
            this.mnuRefrescarLog.Click += new System.EventHandler(this.mnuRefrescarLog_Click);
            // 
            // ayudaToolStripMenuItem1
            // 
            this.ayudaToolStripMenuItem1.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuAcercaDe});
            this.ayudaToolStripMenuItem1.Name = "ayudaToolStripMenuItem1";
            this.ayudaToolStripMenuItem1.Size = new System.Drawing.Size(53, 20);
            this.ayudaToolStripMenuItem1.Text = "Ayuda";
            // 
            // mnuAcercaDe
            // 
            this.mnuAcercaDe.Image = global::SrvControlPanel.Properties.Resources.Help;
            this.mnuAcercaDe.Name = "mnuAcercaDe";
            this.mnuAcercaDe.Size = new System.Drawing.Size(135, 22);
            this.mnuAcercaDe.Text = "Acerca de...";
            this.mnuAcercaDe.Click += new System.EventHandler(this.acercaDeToolStripMenuItem1_Click);
            // 
            // archivoToolStripMenuItem
            // 
            this.archivoToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.salirToolStripMenuItem});
            this.archivoToolStripMenuItem.Name = "archivoToolStripMenuItem";
            this.archivoToolStripMenuItem.Size = new System.Drawing.Size(55, 20);
            this.archivoToolStripMenuItem.Text = "&Archivo";
            // 
            // salirToolStripMenuItem
            // 
            this.salirToolStripMenuItem.Name = "salirToolStripMenuItem";
            this.salirToolStripMenuItem.Size = new System.Drawing.Size(96, 22);
            this.salirToolStripMenuItem.Text = "&Salir";
            // 
            // servicioToolStripMenuItem
            // 
            this.servicioToolStripMenuItem.Name = "servicioToolStripMenuItem";
            this.servicioToolStripMenuItem.Size = new System.Drawing.Size(56, 20);
            this.servicioToolStripMenuItem.Text = "&Servicio";
            // 
            // herramientasToolStripMenuItem
            // 
            this.herramientasToolStripMenuItem.Name = "herramientasToolStripMenuItem";
            this.herramientasToolStripMenuItem.Size = new System.Drawing.Size(83, 20);
            this.herramientasToolStripMenuItem.Text = "&Herramientas";
            // 
            // ayudaToolStripMenuItem
            // 
            this.ayudaToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.acercaDeToolStripMenuItem});
            this.ayudaToolStripMenuItem.Name = "ayudaToolStripMenuItem";
            this.ayudaToolStripMenuItem.Size = new System.Drawing.Size(50, 20);
            this.ayudaToolStripMenuItem.Text = "A&yuda";
            // 
            // acercaDeToolStripMenuItem
            // 
            this.acercaDeToolStripMenuItem.Name = "acercaDeToolStripMenuItem";
            this.acercaDeToolStripMenuItem.Size = new System.Drawing.Size(135, 22);
            this.acercaDeToolStripMenuItem.Text = "&Acerca de...";
            // 
            // toolStripStatusLabel1
            // 
            this.toolStripStatusLabel1.Name = "toolStripStatusLabel1";
            this.toolStripStatusLabel1.Size = new System.Drawing.Size(109, 17);
            this.toolStripStatusLabel1.Text = "toolStripStatusLabel1";
            // 
            // toolStripStatusLabel2
            // 
            this.toolStripStatusLabel2.Name = "toolStripStatusLabel2";
            this.toolStripStatusLabel2.Size = new System.Drawing.Size(109, 17);
            this.toolStripStatusLabel2.Text = "toolStripStatusLabel2";
            // 
            // toolStripStatusLabel3
            // 
            this.toolStripStatusLabel3.Name = "toolStripStatusLabel3";
            this.toolStripStatusLabel3.Size = new System.Drawing.Size(247, 17);
            this.toolStripStatusLabel3.Spring = true;
            this.toolStripStatusLabel3.Text = "toolStripStatusLabel3";
            // 
            // toolStripStatusLabel4
            // 
            this.toolStripStatusLabel4.Name = "toolStripStatusLabel4";
            this.toolStripStatusLabel4.Size = new System.Drawing.Size(109, 17);
            this.toolStripStatusLabel4.Text = "toolStripStatusLabel4";
            // 
            // toolStripButton4
            // 
            this.toolStripButton4.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton4.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton4.Name = "toolStripButton4";
            this.toolStripButton4.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton4.Text = "toolStripButton4";
            // 
            // timerEstatusServicios
            // 
            this.timerEstatusServicios.Tick += new System.EventHandler(this.timerEstatusServicios_Tick);
            // 
            // toolStripButton5
            // 
            this.toolStripButton5.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton5.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton5.Image")));
            this.toolStripButton5.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton5.Name = "toolStripButton5";
            this.toolStripButton5.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton5.Text = "toolStripButton5";
            // 
            // toolStripButton1
            // 
            this.toolStripButton1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton1.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton1.Image")));
            this.toolStripButton1.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton1.Name = "toolStripButton1";
            this.toolStripButton1.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton1.Text = "toolStripButton1";
            // 
            // toolStripButton2
            // 
            this.toolStripButton2.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton2.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton2.Image")));
            this.toolStripButton2.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton2.Name = "toolStripButton2";
            this.toolStripButton2.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton2.Text = "toolStripButton2";
            // 
            // toolStripButton3
            // 
            this.toolStripButton3.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton3.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton3.Image")));
            this.toolStripButton3.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton3.Name = "toolStripButton3";
            this.toolStripButton3.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton3.Text = "toolStripButton3";
            // 
            // toolStripButton6
            // 
            this.toolStripButton6.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton6.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton6.Image")));
            this.toolStripButton6.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton6.Name = "toolStripButton6";
            this.toolStripButton6.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton6.Text = "toolStripButton6";
            // 
            // frmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(652, 310);
            this.Controls.Add(toolStripContainer1);
            this.Controls.Add(this.menuStrip1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MinimumSize = new System.Drawing.Size(330, 250);
            this.Name = "frmMain";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Consola de Control de Servicios - SEY Yoli";
            toolStripContainer1.BottomToolStripPanel.ResumeLayout(false);
            toolStripContainer1.BottomToolStripPanel.PerformLayout();
            toolStripContainer1.ContentPanel.ResumeLayout(false);
            toolStripContainer1.TopToolStripPanel.ResumeLayout(false);
            toolStripContainer1.TopToolStripPanel.PerformLayout();
            toolStripContainer1.ResumeLayout(false);
            toolStripContainer1.PerformLayout();
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.Panel2.PerformLayout();
            this.splitContainer1.ResumeLayout(false);
            this.contextMenuStrip1.ResumeLayout(false);
            this.toolStripPrincipal.ResumeLayout(false);
            this.toolStripPrincipal.PerformLayout();
            this.toolStripSecundaria.ResumeLayout(false);
            this.toolStripSecundaria.PerformLayout();
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip1;
		 private System.Windows.Forms.ImageList imlIcons;
        private System.Windows.Forms.ToolStripButton toolStripButton1;
        private System.Windows.Forms.ToolStripButton toolStripButton2;
        private System.Windows.Forms.ToolStripButton toolStripButton3;
        private System.Windows.Forms.ToolStripButton toolStripButton4;
        private System.Windows.Forms.ToolStripButton toolStripButton5;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel1;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel2;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel3;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel4;
        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.TreeView tvServicios;
        private System.Windows.Forms.ListView lvEstatusServicios;
        private System.Windows.Forms.ColumnHeader Servicio;
        private System.Windows.Forms.ColumnHeader Estatus;
        private System.Windows.Forms.ToolStripMenuItem archivoToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem salirToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem servicioToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem herramientasToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem ayudaToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem acercaDeToolStripMenuItem;
        private System.Windows.Forms.ListView lvLog;
        private System.Windows.Forms.ColumnHeader FechaHora;
        private System.Windows.Forms.ColumnHeader Tipo;
        private System.Windows.Forms.ColumnHeader Mensaje;
        private System.Windows.Forms.ToolStripButton toolStripButton6;
        private System.Windows.Forms.ToolStrip toolStripPrincipal;
        private System.Windows.Forms.ToolStrip toolStripSecundaria;
        private System.Windows.Forms.ToolStripButton btnStop;
		 private System.Windows.Forms.ToolStripButton btnPlay;
        private System.Windows.Forms.ToolStripMenuItem archivoToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem salirToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem mnuServicio;
        private System.Windows.Forms.ToolStripMenuItem mnuSrvPlay;
        private System.Windows.Forms.ToolStripMenuItem mnuSrvStop;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripMenuItem mnuSrvConfigurar;
       private System.Windows.Forms.ToolStripMenuItem herramientasToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem ayudaToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem mnuAcercaDe;
        private System.Windows.Forms.ToolStripStatusLabel panelStatus;
		 private System.Windows.Forms.Timer timerEstatusServicios;
       private System.Windows.Forms.ToolStripButton btnConfigurar;
		 private System.Windows.Forms.ContextMenuStrip contextMenuStrip1;
		 private System.Windows.Forms.ToolStripMenuItem mnuCtxNombreServicio;
		 private System.Windows.Forms.ToolStripMenuItem mnuCtxPlay;
		 private System.Windows.Forms.ToolStripMenuItem mnuCtxStop;
		 private System.Windows.Forms.ToolStripMenuItem mnuCtxConfig;
		 private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
		 private System.Windows.Forms.ToolStripSplitButton btnLogDetalle;
		 private System.Windows.Forms.ToolStripMenuItem btnLogDebug;
		 private System.Windows.Forms.ToolStripMenuItem btnLogInfo;
		 private System.Windows.Forms.ToolStripMenuItem btnLogWarning;
		 private System.Windows.Forms.ToolStripMenuItem btnLogError;
		 private System.Windows.Forms.ToolStripComboBox cmbDiasLog;
		 private System.Windows.Forms.ColumnHeader Codigo;
       private System.Windows.Forms.ToolStripStatusLabel lblPorcAvance;
       private System.Windows.Forms.ToolStripProgressBar progressBar;
       private System.Windows.Forms.ToolStripStatusLabel toolStripEspacio;
       private System.Windows.Forms.ToolStripStatusLabel lblBtnCancelar;
       private System.Windows.Forms.Label label1;
       private System.Windows.Forms.ToolStripButton btnRefrescarLog;
       private System.Windows.Forms.ToolStripMenuItem mnuRefrescarLog;
       private System.Windows.Forms.ToolStripButton btnAbrirFolderLogs;

    }
}

