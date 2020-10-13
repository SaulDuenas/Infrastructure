Imports System.Runtime.InteropServices
Imports OPC.Automation

Public Class clOPC
    Protected vServidor As String
    Protected vNodo As String
    Protected vGrupo As String
    Dim objServidor As OPCServerClass
    Dim objGrupos As OPCGroupsClass
    Dim WithEvents objGrupo As OPCGroupClass
    Dim objItems As OPCItems
    Dim objItem(99) As OPCItem
    Private FormularioAplicar As Object

    Sub New()
        'Requerido para Reflexión.
    End Sub

    'Almacena el formulario sobre el cual aplicar los colores.
    Sub New(ByVal FormularioAplicars As Object)
        FormularioAplicar = FormularioAplicars
    End Sub

    Public Property Servidor() As String
        Get
            Return vServidor
        End Get
        Set(ByVal Value As String)
            vServidor = Value
        End Set
    End Property

    ' Nodo o PC donde se encuentra instalado
    Public Property Nodo() As String
        Get
            Return vNodo
        End Get
        Set(ByVal Value As String)
            vNodo = Value
        End Set
    End Property

    ' Grupo OPC
    Public Property Grupo() As String
        Get
            Return vGrupo
        End Get
        Set(ByVal Value As String)
            vGrupo = Value
        End Set
    End Property

    Public Sub CrearServidorGrupo(ByVal Servidor As String, ByVal Nodo As String, ByVal Grupo As String, ByVal Items As Object, ByVal CantidadItems As Integer)
        Dim i As Integer
        Dim a As Integer
        Dim b As Integer

        Try
            'Se configuran las propiedades del objeto
            Me.Servidor = Servidor
            Me.Nodo = Nodo
            Me.Grupo = Grupo

            'Creacion del objeto OPCServer
            'Este objeto es el mas alto de la jerarquia. Con el se inicia
            'el trabajo de conexion al servidor OPC
            objServidor = New OPCAutomation.OPCServerClass()
            'Conexion al Servidor OPC
            objServidor.Connect(Servidor, Nodo)
            'Creacion del objeto OPCGroups. Este representa una coleccion de cada
            'uno de los grupos de variables que se leeran
            'Se requiere usar Marshal para el manejo de tipos. Recuerde que
            'OPCAutomation es COM
            objGrupos = CType(Marshal.CreateWrapperOfType(objServidor.OPCGroups, _
                         GetType(OPCGroupsClass)), OPCGroupsClass)

            'Estado activo por defecto para los Grupos que se agreguen a la coleccion
            'de Grupos OPC
            objGrupos.DefaultGroupIsActive = True
            'Valor de banda muerta. 
            objGrupos.DefaultGroupDeadband = 0

            'Adicion de un Grupo OPC a la coleccion de Grupos.
            'Un grupo representa un conjunto de variables. Por ejemplo
            'si voy a leer todas las variables de una maquina determinada
            'creo un Grupo para esas variables.
            objGrupo = objGrupos.Add(Grupo)
            'Estado del Grupo
            objGrupo.IsActive = True
            objGrupo.IsSubscribed = True
            'Tiempo del lectura en milisegundos. Es decir, cada 1 segundo
            'el Cliente OPC(este programa) le preguntará al Servidor OPC
            'si existen cambios en alguna de las variables del Grupo
            objGrupo.UpdateRate = 1000

            'Creacion de la Objeto que representa la Coleccion de Items o Variables
            'a leer
            objItems = objGrupo.OPCItems
            'Estado por defecto para las variables que se agrequen a la coleccion
            'de Items
            objItems.DefaultIsActive = False

            'Se crean arreglo de variables
            For i = 1 To CantidadItems
                objItem(i) = objItems.AddItem(Items(i - 1, 0), Items(i - 1, 1))
                objItem(i).IsActive = Items(i - 1, 2)
            Next i

        Catch ex As System.Exception
            Exit Sub
        End Try
    End Sub

    Public Sub EnviarValor(ByVal Servidor As String, ByVal Nodo As String, ByVal Grupo As String, ByVal Item As String, ByVal ValorNuevo As Double, ByRef ValorActual As Double)
        'Creacion del objeto Servidor
        objServidor = New OPCAutomation.OPCServerClass()
        'Conexion al Servidor OPC
        objServidor.Connect(Servidor.Trim, Nodo.Trim)

        'Marshal para manejo de tipos de COM
        objGrupos = CType(Marshal.CreateWrapperOfType(objServidor.OPCGroups, _
                     GetType(OPCGroupsClass)), OPCGroupsClass)
        objGrupo = objGrupos.Add(Grupo.Trim)
        objItems = objGrupo.OPCItems

        objItem(0) = objItems.AddItem(Item.Trim, 0)
        'Leer el valor actual de la variable
        objItem(0).Read(1, ValorActual)
        'Escribir un nuevo valor para la variable
        objItem(0).Write(ValorNuevo)
        objServidor = Nothing
        objGrupos = Nothing
        objItems = Nothing
        objItem(0) = Nothing
    End Sub

    Sub objGrupo_DataChange(ByVal TransactionID As Integer, ByVal NumItems As Integer, _
ByRef ClientHandles As System.Array, ByRef ItemValues As System.Array, _
ByRef Qualities As System.Array, ByRef TimeStamps As System.Array) Handles objGrupo.DataChange
        Dim Valores(99, 3) As Object
        Dim i As Integer

        'Creación de un vector que condensa toda la información enviada por
        'el Servidor OPC
        For i = 1 To NumItems
            Valores(i - 1, 0) = ItemValues.GetValue(i)
            Valores(i - 1, 1) = ClientHandles.GetValue(i)
            Valores(i - 1, 2) = TimeStamps.GetValue(i)

            'Se obtiene un valor significativo de la calidad de la informacion
            If Qualities.GetValue(i) And &HC0 Then
                Valores(i - 1, 3) = "Buena"
            Else
                Valores(i - 1, 3) = "Deficiente"
            End If
        Next i

        'Se llama al metodo ActualizarLista del formulario que instancio a clOPC
        'para que este obtenga el vector condensado con la informacion de los 
        'cambios de variables enviados por el Servidor OPC
        FormularioAplicar.ActualizarLista(Me.Servidor, Me.Nodo, Me.Grupo, NumItems, Valores)
    End Sub

    Public Sub TerminarLectura()
        'Se eliminan las instancias de los objetos creados
        objGrupos = Nothing
        objGrupo = Nothing
        objServidor = Nothing
        objItems = Nothing
        objItem = Nothing
    End Sub
End Class
