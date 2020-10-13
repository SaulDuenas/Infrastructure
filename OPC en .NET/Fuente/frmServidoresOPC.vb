Public Class frmServidoresOPC
    Inherits System.Windows.Forms.Form
    Dim objfrmOPC As frmOPC

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal objform As frmOPC)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        objfrmOPC = objform
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
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents btnSeleccionar As System.Windows.Forms.Button
    Friend WithEvents txtNodo As System.Windows.Forms.TextBox
    Friend WithEvents btnConectar As System.Windows.Forms.Button
    Friend WithEvents lstServidores As System.Windows.Forms.ListBox
    Friend WithEvents btnSalir As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.btnConectar = New System.Windows.Forms.Button()
        Me.txtNodo = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.btnSeleccionar = New System.Windows.Forms.Button()
        Me.btnSalir = New System.Windows.Forms.Button()
        Me.lstServidores = New System.Windows.Forms.ListBox()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.AddRange(New System.Windows.Forms.Control() {Me.btnConectar, Me.txtNodo, Me.Label1})
        Me.GroupBox1.Location = New System.Drawing.Point(8, 0)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(248, 64)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        '
        'btnConectar
        '
        Me.btnConectar.Location = New System.Drawing.Point(176, 31)
        Me.btnConectar.Name = "btnConectar"
        Me.btnConectar.Size = New System.Drawing.Size(64, 24)
        Me.btnConectar.TabIndex = 3
        Me.btnConectar.Text = "Conectar"
        '
        'txtNodo
        '
        Me.txtNodo.Location = New System.Drawing.Point(8, 32)
        Me.txtNodo.Name = "txtNodo"
        Me.txtNodo.Size = New System.Drawing.Size(160, 20)
        Me.txtNodo.TabIndex = 1
        Me.txtNodo.Text = ""
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(7, 13)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(48, 16)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Nodo"
        '
        'btnSeleccionar
        '
        Me.btnSeleccionar.Location = New System.Drawing.Point(264, 6)
        Me.btnSeleccionar.Name = "btnSeleccionar"
        Me.btnSeleccionar.Size = New System.Drawing.Size(88, 24)
        Me.btnSeleccionar.TabIndex = 1
        Me.btnSeleccionar.Text = "Seleccionar"
        '
        'btnSalir
        '
        Me.btnSalir.Location = New System.Drawing.Point(264, 38)
        Me.btnSalir.Name = "btnSalir"
        Me.btnSalir.Size = New System.Drawing.Size(88, 24)
        Me.btnSalir.TabIndex = 2
        Me.btnSalir.Text = "&Salir"
        '
        'lstServidores
        '
        Me.lstServidores.Location = New System.Drawing.Point(8, 73)
        Me.lstServidores.Name = "lstServidores"
        Me.lstServidores.Size = New System.Drawing.Size(344, 121)
        Me.lstServidores.TabIndex = 3
        '
        'frmServidoresOPC
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(360, 205)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.lstServidores, Me.btnSalir, Me.btnSeleccionar, Me.GroupBox1})
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmServidoresOPC"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Servidores OPC Disponibles"
        Me.GroupBox1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub btnConectar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConectar.Click
        Conectar()
    End Sub

    Private Sub btnSeleccionar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSeleccionar.Click
        If txtNodo.Text = "" Then
            MsgBox("Debe indicar un Nodo(Nombre de Equipo con Servidor OPC)", MsgBoxStyle.Critical, "ERROR")
            Exit Sub
        End If
        If lstServidores.SelectedItem = "" Then
            MsgBox("Debe seleccionar un Servidor OPC", MsgBoxStyle.Critical, "ERROR")
            Exit Sub
        End If

        objfrmOPC.txtServidorOPC.Text = lstServidores.SelectedItem
        objfrmOPC.txtNodoOPC.Text = txtNodo.Text
    End Sub
    Sub Conectar()
        'Arreglo para los Servidores OPC encontrados
        Dim arregloOPCServer As Object
        Dim i As Integer
        'Instancia de la Clase OPCServer en la automatizacion OPC
        'El proyecto debe tener una referencia a la libreria(COM)
        'OPCAutomation. Regularmente este libreria se instala
        'con la instalcion de un servidor OPC.
        Dim objOPCServer As New OPCAutomation.OPCServerClass()

        'Limpiar la lista de Servidores
        lstServidores.Items.Clear()

        Try
            'El metodo GetOPCServer de OPCServer nos devuelve el arreglo
            'de servidores OPC que se encuentren en el nodo, esto ultimo
            'es parametro del metodo
            arregloOPCServer = objOPCServer.GetOPCServers(txtNodo.Text)

            'Se recorre el arreglo de servidores y se agregan en la lista
            For i = LBound(arregloOPCServer) To UBound(arregloOPCServer)
                lstServidores.Items.Add(arregloOPCServer(i))
            Next i
        Catch ex As System.Exception
            MsgBox("No fué posible obtener Servidores OPC en el Nodo especificado", MsgBoxStyle.Critical, "ERROR")
        End Try

    End Sub
    Private Sub frmServidoresOPC_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Por defecto se asume que el cliente se conectará
        'a un servidor OPC local. Para lo cual podemos usar
        'usar el objeto Environment
        txtNodo.Text = Environment.MachineName
        'Llamamos al metodo que nos permite realizar la conexion OPC
        'para obtener los Servidores OPC locales
        Conectar()
    End Sub
    Private Sub btnSalir_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSalir.Click
        Me.Close()
    End Sub
    Private Sub txtNodo_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtNodo.TextChanged
        lstServidores.Items.Clear()
    End Sub
End Class
