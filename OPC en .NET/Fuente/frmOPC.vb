Public Class frmOPC
    Inherits System.Windows.Forms.Form
    Dim objOPC As New clOPC(Me)


#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

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
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents txtServidorOPC As System.Windows.Forms.TextBox
    Friend WithEvents btnSalir As System.Windows.Forms.Button
    Friend WithEvents txtGrupoOPC As System.Windows.Forms.TextBox
    Friend WithEvents txtNodoOPC As System.Windows.Forms.TextBox
    Friend WithEvents btnConectar As System.Windows.Forms.Button
    Friend WithEvents btnBuscarServidor As System.Windows.Forms.Button
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents txtNuevoValor As System.Windows.Forms.TextBox
    Friend WithEvents txtValorActual As System.Windows.Forms.TextBox
    Friend WithEvents txtVariable As System.Windows.Forms.TextBox
    Friend WithEvents txtUltimoRegistro As System.Windows.Forms.TextBox
    Friend WithEvents txtCalidad As System.Windows.Forms.TextBox
    Friend WithEvents btnEnviarValor As System.Windows.Forms.Button
    Friend WithEvents btnPropiedades As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.btnPropiedades = New System.Windows.Forms.Button()
        Me.btnEnviarValor = New System.Windows.Forms.Button()
        Me.Label11 = New System.Windows.Forms.Label()
        Me.txtCalidad = New System.Windows.Forms.TextBox()
        Me.Label10 = New System.Windows.Forms.Label()
        Me.txtUltimoRegistro = New System.Windows.Forms.TextBox()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.txtNuevoValor = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.txtNodoOPC = New System.Windows.Forms.TextBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.txtGrupoOPC = New System.Windows.Forms.TextBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.txtValorActual = New System.Windows.Forms.TextBox()
        Me.txtVariable = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.btnBuscarServidor = New System.Windows.Forms.Button()
        Me.txtServidorOPC = New System.Windows.Forms.TextBox()
        Me.btnSalir = New System.Windows.Forms.Button()
        Me.btnConectar = New System.Windows.Forms.Button()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.AddRange(New System.Windows.Forms.Control() {Me.btnPropiedades, Me.btnEnviarValor, Me.Label11, Me.txtCalidad, Me.Label10, Me.txtUltimoRegistro, Me.Label7, Me.txtNuevoValor, Me.Label6, Me.txtNodoOPC, Me.Label5, Me.Label3, Me.txtGrupoOPC, Me.Label2, Me.txtValorActual, Me.txtVariable, Me.Label1, Me.btnBuscarServidor, Me.txtServidorOPC})
        Me.GroupBox1.Location = New System.Drawing.Point(8, 8)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(520, 280)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        '
        'btnPropiedades
        '
        Me.btnPropiedades.Location = New System.Drawing.Point(368, 72)
        Me.btnPropiedades.Name = "btnPropiedades"
        Me.btnPropiedades.Size = New System.Drawing.Size(104, 24)
        Me.btnPropiedades.TabIndex = 36
        Me.btnPropiedades.Text = "&Propiedades"
        '
        'btnEnviarValor
        '
        Me.btnEnviarValor.Location = New System.Drawing.Point(208, 232)
        Me.btnEnviarValor.Name = "btnEnviarValor"
        Me.btnEnviarValor.Size = New System.Drawing.Size(72, 24)
        Me.btnEnviarValor.TabIndex = 35
        Me.btnEnviarValor.Text = "&Enviar"
        '
        'Label11
        '
        Me.Label11.Location = New System.Drawing.Point(184, 160)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(96, 23)
        Me.Label11.TabIndex = 34
        Me.Label11.Text = "Calidad del Dato"
        '
        'txtCalidad
        '
        Me.txtCalidad.Location = New System.Drawing.Point(184, 184)
        Me.txtCalidad.Name = "txtCalidad"
        Me.txtCalidad.Size = New System.Drawing.Size(96, 20)
        Me.txtCalidad.TabIndex = 33
        Me.txtCalidad.Text = ""
        '
        'Label10
        '
        Me.Label10.Location = New System.Drawing.Point(280, 160)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(88, 23)
        Me.Label10.TabIndex = 32
        Me.Label10.Text = "Ultima Registro"
        '
        'txtUltimoRegistro
        '
        Me.txtUltimoRegistro.Location = New System.Drawing.Point(280, 184)
        Me.txtUltimoRegistro.Name = "txtUltimoRegistro"
        Me.txtUltimoRegistro.Size = New System.Drawing.Size(216, 20)
        Me.txtUltimoRegistro.TabIndex = 31
        Me.txtUltimoRegistro.Text = ""
        '
        'Label7
        '
        Me.Label7.Location = New System.Drawing.Point(24, 232)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(72, 23)
        Me.Label7.TabIndex = 23
        Me.Label7.Text = "Nuevo Valor"
        '
        'txtNuevoValor
        '
        Me.txtNuevoValor.Location = New System.Drawing.Point(112, 232)
        Me.txtNuevoValor.Name = "txtNuevoValor"
        Me.txtNuevoValor.Size = New System.Drawing.Size(88, 20)
        Me.txtNuevoValor.TabIndex = 22
        Me.txtNuevoValor.Text = ""
        '
        'Label6
        '
        Me.Label6.Location = New System.Drawing.Point(112, 160)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(72, 23)
        Me.Label6.TabIndex = 21
        Me.Label6.Text = "Valor Actual"
        '
        'txtNodoOPC
        '
        Me.txtNodoOPC.Enabled = False
        Me.txtNodoOPC.Location = New System.Drawing.Point(112, 56)
        Me.txtNodoOPC.Name = "txtNodoOPC"
        Me.txtNodoOPC.Size = New System.Drawing.Size(224, 20)
        Me.txtNodoOPC.TabIndex = 20
        Me.txtNodoOPC.Text = ""
        '
        'Label5
        '
        Me.Label5.Location = New System.Drawing.Point(24, 56)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(64, 23)
        Me.Label5.TabIndex = 19
        Me.Label5.Text = "Nodo"
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(24, 80)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(64, 23)
        Me.Label3.TabIndex = 13
        Me.Label3.Text = "Grupo"
        '
        'txtGrupoOPC
        '
        Me.txtGrupoOPC.Location = New System.Drawing.Point(112, 80)
        Me.txtGrupoOPC.Name = "txtGrupoOPC"
        Me.txtGrupoOPC.Size = New System.Drawing.Size(224, 20)
        Me.txtGrupoOPC.TabIndex = 12
        Me.txtGrupoOPC.Text = ""
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(24, 128)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(64, 23)
        Me.Label2.TabIndex = 11
        Me.Label2.Text = "Variable"
        '
        'txtValorActual
        '
        Me.txtValorActual.Location = New System.Drawing.Point(112, 184)
        Me.txtValorActual.Name = "txtValorActual"
        Me.txtValorActual.Size = New System.Drawing.Size(72, 20)
        Me.txtValorActual.TabIndex = 9
        Me.txtValorActual.Text = ""
        '
        'txtVariable
        '
        Me.txtVariable.Location = New System.Drawing.Point(112, 128)
        Me.txtVariable.Name = "txtVariable"
        Me.txtVariable.Size = New System.Drawing.Size(384, 20)
        Me.txtVariable.TabIndex = 3
        Me.txtVariable.Text = ""
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(24, 32)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(88, 23)
        Me.Label1.TabIndex = 2
        Me.Label1.Text = "Servidor OPC"
        '
        'btnBuscarServidor
        '
        Me.btnBuscarServidor.Location = New System.Drawing.Point(368, 40)
        Me.btnBuscarServidor.Name = "btnBuscarServidor"
        Me.btnBuscarServidor.Size = New System.Drawing.Size(104, 24)
        Me.btnBuscarServidor.TabIndex = 1
        Me.btnBuscarServidor.Text = "&Buscar"
        '
        'txtServidorOPC
        '
        Me.txtServidorOPC.Enabled = False
        Me.txtServidorOPC.Location = New System.Drawing.Point(112, 32)
        Me.txtServidorOPC.Name = "txtServidorOPC"
        Me.txtServidorOPC.Size = New System.Drawing.Size(224, 20)
        Me.txtServidorOPC.TabIndex = 0
        Me.txtServidorOPC.Text = ""
        '
        'btnSalir
        '
        Me.btnSalir.Location = New System.Drawing.Point(440, 296)
        Me.btnSalir.Name = "btnSalir"
        Me.btnSalir.Size = New System.Drawing.Size(88, 24)
        Me.btnSalir.TabIndex = 2
        Me.btnSalir.Text = "&Salir"
        '
        'btnConectar
        '
        Me.btnConectar.Location = New System.Drawing.Point(336, 296)
        Me.btnConectar.Name = "btnConectar"
        Me.btnConectar.Size = New System.Drawing.Size(96, 24)
        Me.btnConectar.TabIndex = 3
        Me.btnConectar.Text = "Conectar"
        '
        'frmOPC
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(536, 325)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.btnConectar, Me.btnSalir, Me.GroupBox1})
        Me.Name = "frmOPC"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "frmOPC"
        Me.GroupBox1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region


    Private Sub btnSalir_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSalir.Click
        End
    End Sub

    Private Sub btnBuscarServidor_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBuscarServidor.Click
        'Presenta el Formulario que permite buscar los Servidores OPC
        'Instalados en algún PC
        Dim objfrmServidoresOPC As frmServidoresOPC
        objfrmServidoresOPC = New frmServidoresOPC(Me)
        objfrmServidoresOPC.ShowDialog()
    End Sub

    Private Sub btnConectar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConectar.Click
        'Se conecta o desconecta del Servidor OPC
        If btnConectar.Text = "Conectar" Then
            btnConectar.Text = "Desconectar"
            IniciarLectura()
        Else
            btnConectar.Text = "Conectar"
            TerminarLectura()
        End If
    End Sub

    Public Sub ActualizarLista(ByVal Servidor As String, ByVal Nodo As String, ByVal Grupo As String, ByVal NumItems As Integer, ByRef Valores As System.Array)
        'Metodo invocado desde un Objeto de Clase clOPC para actualizar los datos
        'cuando se presenta algún cambio en la Variable del PLC mapeada
        txtValorActual.Text = Valores(0, 0)
        txtCalidad.Text = Valores(0, 3)
        txtUltimoRegistro.Text = Valores(0, 2)
    End Sub

    Private Sub btnEnviarValor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEnviarValor.Click
        If txtNuevoValor.Text = "" Then
            System.Windows.Forms.MessageBox.Show("Digite el Valor a Enviar")
            Exit Sub
        End If

        If (MsgBox("Esta seguro de enviar valor al Dispositivo?", MsgBoxStyle.YesNo, "SIMPRO") = MsgBoxResult.Yes) Then
            Try
                'Instancia de clOPC
                Dim objOPC As New clOPC()
                Dim ValorActual As Double
                Dim FechaActual As Object
                Dim HoraActual As String

                'Fecha y Hora Actual
                FechaActual = Now.Today
                HoraActual = Now.ToShortTimeString

                'LLamado al metodo que envia el Valor al Dispositivo
                objOPC.EnviarValor(txtServidorOPC.Text, txtNodoOPC.Text, txtGrupoOPC.Text, txtVariable.Text, CDbl(txtNuevoValor.Text), ValorActual)
            Catch ex As System.Exception
                MsgBox("Debe Ingresar un Valor Valido", MsgBoxStyle.Exclamation, "Información")
            End Try
        End If
    End Sub

    Private Sub IniciarLectura()
        'Creación y configuración del Arreglo del Items
        'Como podrán ver, el ejemplo maneja un solo item
        Dim Items(1, 2) As String

        Items(0, 0) = Trim(txtVariable.Text)
        Items(0, 1) = 1
        Items(0, 2) = True

        'Creación de la Conexión con el Servidor OPC
        'El objeto objOPC se declaró en sección general
        'y es una instancia de una clase que facilita la conexion
        'al servidor OPC, la clase clOPC
        objOPC.CrearServidorGrupo(txtServidorOPC.Text, txtNodoOPC.Text, txtGrupoOPC.Text, Items, 1)
    End Sub

    Private Sub TerminarLectura()
        'Terminar la Conexión con el Servidor OPC
        If Not IsNothing(objOPC) Then
            objOPC.TerminarLectura()
            objOPC = Nothing
        End If
    End Sub

    Private Sub btnPropiedades_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPropiedades.Click
        'Llamado al Formulario que muestra las propiedades del Servidor OPC
        Dim objfrmPropiedadesOPC As New frmPropiedadesOPC(txtServidorOPC.Text, txtNodoOPC.Text)
        objfrmPropiedadesOPC.ShowDialog()
    End Sub
End Class
