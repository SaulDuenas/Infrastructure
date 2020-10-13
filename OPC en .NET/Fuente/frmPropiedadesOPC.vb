Public Class frmPropiedadesOPC
    Inherits System.Windows.Forms.Form
    Dim vServidor As String
    Dim vNodo As String
    Public Property Servidor() As String
        Get
            Return vServidor
        End Get
        Set(ByVal Value As String)
            vServidor = Value
        End Set
    End Property
    Public Property Nodo() As String
        Get
            Return vNodo
        End Get
        Set(ByVal Value As String)
            vNodo = Value
        End Set
    End Property
#Region " Windows Form Designer generated code "

    Public Sub New(ByVal pServidor As String, ByVal pNodo As String)
        MyBase.New()

        Me.Servidor = pServidor
        Me.Nodo = pNodo

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents lblNombreServidor As System.Windows.Forms.Label
    Friend WithEvents lblVendedor As System.Windows.Forms.Label
    Friend WithEvents lblTiempoInicio As System.Windows.Forms.Label
    Friend WithEvents lblEstadoServidor As System.Windows.Forms.Label
    Friend WithEvents lblVersion As System.Windows.Forms.Label
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents Label14 As System.Windows.Forms.Label
    Friend WithEvents Label16 As System.Windows.Forms.Label
    Friend WithEvents Label17 As System.Windows.Forms.Label
    Friend WithEvents Label18 As System.Windows.Forms.Label
    Friend WithEvents btnSalir As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.Label12 = New System.Windows.Forms.Label()
        Me.Label14 = New System.Windows.Forms.Label()
        Me.Label16 = New System.Windows.Forms.Label()
        Me.Label17 = New System.Windows.Forms.Label()
        Me.Label18 = New System.Windows.Forms.Label()
        Me.lblVersion = New System.Windows.Forms.Label()
        Me.lblEstadoServidor = New System.Windows.Forms.Label()
        Me.lblTiempoInicio = New System.Windows.Forms.Label()
        Me.lblVendedor = New System.Windows.Forms.Label()
        Me.lblNombreServidor = New System.Windows.Forms.Label()
        Me.btnSalir = New System.Windows.Forms.Button()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.AddRange(New System.Windows.Forms.Control() {Me.Label12, Me.Label14, Me.Label16, Me.Label17, Me.Label18, Me.lblVersion, Me.lblEstadoServidor, Me.lblTiempoInicio, Me.lblVendedor, Me.lblNombreServidor})
        Me.GroupBox1.Location = New System.Drawing.Point(8, 0)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(480, 192)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        '
        'Label12
        '
        Me.Label12.Location = New System.Drawing.Point(32, 168)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(128, 16)
        Me.Label12.TabIndex = 16
        Me.Label12.Text = "Version "
        '
        'Label14
        '
        Me.Label14.Location = New System.Drawing.Point(32, 96)
        Me.Label14.Name = "Label14"
        Me.Label14.Size = New System.Drawing.Size(120, 16)
        Me.Label14.TabIndex = 14
        Me.Label14.Text = "Estado del Servidor:"
        '
        'Label16
        '
        Me.Label16.Location = New System.Drawing.Point(32, 72)
        Me.Label16.Name = "Label16"
        Me.Label16.Size = New System.Drawing.Size(128, 16)
        Me.Label16.TabIndex = 12
        Me.Label16.Text = "Tiempo de Inicio:"
        '
        'Label17
        '
        Me.Label17.Location = New System.Drawing.Point(32, 48)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(128, 16)
        Me.Label17.TabIndex = 11
        Me.Label17.Text = "Vendedor:"
        '
        'Label18
        '
        Me.Label18.Location = New System.Drawing.Point(32, 24)
        Me.Label18.Name = "Label18"
        Me.Label18.Size = New System.Drawing.Size(128, 16)
        Me.Label18.TabIndex = 10
        Me.Label18.Text = "Nombre del Servidor:"
        '
        'lblVersion
        '
        Me.lblVersion.Location = New System.Drawing.Point(184, 168)
        Me.lblVersion.Name = "lblVersion"
        Me.lblVersion.Size = New System.Drawing.Size(288, 16)
        Me.lblVersion.TabIndex = 7
        Me.lblVersion.Text = "."
        '
        'lblEstadoServidor
        '
        Me.lblEstadoServidor.Location = New System.Drawing.Point(184, 96)
        Me.lblEstadoServidor.Name = "lblEstadoServidor"
        Me.lblEstadoServidor.Size = New System.Drawing.Size(288, 16)
        Me.lblEstadoServidor.TabIndex = 5
        Me.lblEstadoServidor.Text = "."
        '
        'lblTiempoInicio
        '
        Me.lblTiempoInicio.Location = New System.Drawing.Point(184, 72)
        Me.lblTiempoInicio.Name = "lblTiempoInicio"
        Me.lblTiempoInicio.Size = New System.Drawing.Size(288, 16)
        Me.lblTiempoInicio.TabIndex = 3
        Me.lblTiempoInicio.Text = "."
        '
        'lblVendedor
        '
        Me.lblVendedor.Location = New System.Drawing.Point(184, 48)
        Me.lblVendedor.Name = "lblVendedor"
        Me.lblVendedor.Size = New System.Drawing.Size(288, 16)
        Me.lblVendedor.TabIndex = 2
        Me.lblVendedor.Text = "."
        '
        'lblNombreServidor
        '
        Me.lblNombreServidor.Location = New System.Drawing.Point(184, 24)
        Me.lblNombreServidor.Name = "lblNombreServidor"
        Me.lblNombreServidor.Size = New System.Drawing.Size(288, 16)
        Me.lblNombreServidor.TabIndex = 1
        Me.lblNombreServidor.Text = "."
        '
        'btnSalir
        '
        Me.btnSalir.Location = New System.Drawing.Point(384, 200)
        Me.btnSalir.Name = "btnSalir"
        Me.btnSalir.Size = New System.Drawing.Size(104, 24)
        Me.btnSalir.TabIndex = 1
        Me.btnSalir.Text = "&Salir"
        '
        'frmPropiedadesOPC
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(496, 229)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.btnSalir, Me.GroupBox1})
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmPropiedadesOPC"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Propiedades del Servidor OPC"
        Me.GroupBox1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region
    Private Sub btnSalir_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSalir.Click
        Me.Close()
    End Sub
    Private Sub frmPropiedadesOPC_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Crea una instancia OPCServer
        Dim objOPCServer As New OPCAutomation.OPCServerClass()

        Try
            'Se conecta al Servidor
            objOPCServer.Connect(Me.Servidor, Me.Nodo)
            'Se conecta al Servidor con el código del Servidor y Nodo            Me.lblNombreServidor.Text = objOPCServer.ServerName
            Me.lblVendedor.Text = objOPCServer.VendorInfo
            Me.lblTiempoInicio.Text = objOPCServer.StartTime
            Me.lblVersion.Text = objOPCServer.MajorVersion & "." & objOPCServer.MinorVersion
            Me.lblEstadoServidor.Text = objOPCServer.ServerState
        Catch ex As System.Exception
            MsgBox("No se encontró disponible el Servidor OPC", MsgBoxStyle.Critical, "ERROR")
        End Try
    End Sub
End Class
