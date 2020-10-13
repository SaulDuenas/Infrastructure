VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TSRLinx"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'****** Variables Privadas
Private WithEvents mOPCServer As OPCServer   'Servidor OPC
Attribute mOPCServer.VB_VarHelpID = -1
Private mGrupos As colGrupos      'Coleccion de grupos
Private mGrupoDefault As String   'Nombre del Grupo Default

'****** Enums
'Tipos de Servidores OPC
Public Enum lnxOPCServerType
    lnxRSLinxLocal
    lnxRSLinxRemoto
    lnxOtroOPCServer
End Enum

'Constantes de modo de acceso para DataPoints
Public Enum lnxModoAcceso
   lnxScheduled = 1        'OPC_DS_CACHE As Long = 1  ' Para leer datos desde el cache de RSLinx (Scheduled)
   lnxDeviceScheduled = 2  'OPC_DS_DEVICE As Long = 2 ' Para leer datos desde el dispositivo (DeviceSheduled)
End Enum


'Constantes de Calidad
Const OPC_QUALITY_BAD As Long = &H0
Const OPC_QUALITY_UNCERTAIN As Long = &H40
Const OPC_QUALITY_GOOD      As Long = &HC0
Const OPC_QUALITY_CONFIG_ERROR As Long = &H4
Const OPC_QUALITY_NOT_CONNECTED As Long = &H8
Const OPC_QUALITY_DEVICE_FAILURE As Long = &HC
Const OPC_QUALITY_SENSOR_FAILURE As Long = &H10
Const OPC_QUALITY_LAST_KNOWN   As Long = &H14
Const OPC_QUALITY_COMM_FAILURE As Long = &H18
Const OPC_QUALITY_OUT_OF_SERVICE As Long = &H1C
Const OPC_QUALITY_LAST_USABLE  As Long = &H44
Const OPC_QUALITY_SENSOR_CAL   As Long = &H50
Const OPC_QUALITY_EGU_EXCEEDED As Long = &H54
Const OPC_QUALITY_SUB_NORMAL   As Long = &H58
Const OPC_QUALITY_LOCAL_OVERRIDE As Long = &HD8
Const OPC_STATUS_RUNNING As Long = &H1
Const OPC_STATUS_FAILED As Long = &H2
Const OPC_STATUS_NOCONFIG As Long = &H3
Const OPC_STATUS_SUSPENDED As Long = &H4
Const OPC_STATUS_TEST As Long = &H5






'**************** EVENTOS **************************
Public Event TagLeido(ByVal Grupo As String, ByVal TagName As String, ByVal Valor As Variant, _
                      ByVal Calidad As Long, ByVal Error As Long, ByVal Nota As String, ByVal TransactionID As Long)

Public Event Desconexion(ByVal Motivo As String)

'************** Initialize & Terminate ****************
'Inicialización de la Clase
Private Sub Class_Initialize()
   'Crea el Objeto OPCServer
   Set mOPCServer = New OPCServer
   'Crea la colección de Grupos Vacía
   Set mGrupos = New colGrupos
   'Le pasa la referencia al OPCServer
   Set mGrupos.OPCServer = mOPCServer
   'Le pasa la referencia a este objeto
   Set mGrupos.TSRLinx = Me
End Sub
'Finalizar la Clase
Private Sub Class_Terminate()
   'On Error Resume Next
   
   'Elimina todos los Grupos
   mGrupos.RemoveAll
   Set mGrupos = Nothing
   
   'Elimina todos los grupos creados (por si las moscas)
   mOPCServer.OPCGroups.RemoveAll
   
   'Se desconecta de Linx
   mOPCServer.Disconnect
   
   'Destruye el objeto OPCServer
   Set mOPCServer = Nothing
End Sub


'************** Métodos ****************
'Conectarse al servidor OPC
Public Function Conectar(Optional Server As lnxOPCServerType = lnxRSLinxLocal, Optional RemotePCName As String, Optional OPCServerName As String = "") As Boolean
Attribute Conectar.VB_Description = "Se conecta a RSLinx u otro servidor OPC."
 Dim lOK As Boolean
   'Inicia
   lOK = True
   On Error GoTo ErrHandler
   Select Case Server
      'Servidor RSLinx Local
      Case lnxRSLinxLocal
         mOPCServer.Connect "RSLinx OPC Server"
      
      'Servidor RSLinx Remoto (Gateway)
      Case lnxRSLinxRemoto
         mOPCServer.Connect "RSLinx Remote OPC Server", RemotePCName
      
      'Otro Servidor OPC
      Case lnxOtroOPCServer
         mOPCServer.Connect OPCServerName
   End Select
Salida:
   Conectar = lOK
   Exit Function

ErrHandler:
   MsgBox Err.Description, vbOKOnly, "TSRLinx.Conectar"
   lOK = False
   Resume Salida
End Function

'Se desconecta del Servidor OPC
Public Sub Desconectar()
   'Quita todos los grupos
   mGrupos.RemoveAll
   'Elimina la coleccion de grupos
   'Set mGrupos = Nothing
   
   'Se desconecta del servidor OPC
   mOPCServer.Disconnect
End Sub

'Agrega un nuevo Grupo
Public Sub NuevoGrupo(ByVal Grupo As String, ByVal Topico As String, _
                      Optional ByVal ModoAsincrono As Boolean = False, _
                      Optional ByVal VelActualiza As Long = 1000)
   'Añade un grupo a la colección
   mGrupos.Add Grupo, Topico, ModoAsincrono, VelActualiza
      
   'Si es el primer Grupo, entonces es el default
   If mGrupos.Count = 1 Then mGrupoDefault = Grupo
End Sub

Public Sub EliminaGrupo(ByVal Grupo As String)
   MsgBox "OJO EliminaGrupo"
End Sub




'Activa la comunicación de uno o todos los grupos
Public Sub IniciaComm(Optional ByVal Grupo As String = "")
 Dim lGrupo As Grupo
 
   'Inicia
   If Grupo <> "" Then
      'Iniciar la comunicación del grupo indicado
      mGrupos(Grupo).EsActivo = True
   Else
      'Iniciar la comunicación de TODOS los grupos
      For Each lGrupo In mGrupos
         lGrupo.EsActivo = True
      Next
   End If
End Sub

'Desactiva la comunicación de uno o todos los grupos
Public Sub DetieneComm(Optional ByVal Grupo As String = "")
 Dim lGrupo As Grupo
 
   'Inicia
   If Grupo <> "" Then
      'Iniciar la comunicación del grupo indicado
      mGrupos(Grupo).EsActivo = False
   Else
      'Iniciar la comunicación de TODOS los grupos
      For Each lGrupo In mGrupos
         lGrupo.EsActivo = False
      Next
   End If
End Sub



'Agregar un nuevo Tag a un grupo
Public Function NuevoTag(ByVal TagName As String, ByVal Direccion As String, _
                         ByVal Tipo As VariantTypeConstants, ByVal ModoAcceso As lnxModoAcceso, _
                         Optional ByVal FactorEscala As Double = 1, _
                         Optional ByVal Nota As String, _
                         Optional ByVal Grupo As String = "") As Boolean
 Dim lGrupo As String
 
   'Inicia
   lGrupo = Grupo
   If lGrupo = "" Then lGrupo = mGrupoDefault
   
   'Añade el tag al grupo
   NuevoTag = mGrupos(lGrupo).NuevoTag(TagName, Direccion, Tipo, ModoAcceso, FactorEscala, Nota)
   
End Function

'Quitar un Tag de un grupo
Public Sub EliminaTag(ByVal TagName As String, Optional ByVal Grupo As String = "")
End Sub













'Establece/Obtiene el Grupo Default
Public Property Let GrupoDefault(ByVal vData As Variant)
   mGrupoDefault = vData
End Property
Public Property Get KeyGrupoDefault() As Variant
   KeyGrupoDefault = mGrupoDefault
End Property


'Da acceso a la colección de Grupos
'Public Property Get Grupos() As colGrupos
'   Set Grupos = mGrupos
'End Property

'Devuelve la descripción de un error
Public Property Get DescripcionError(ErrorNum As Long) As String
   DescripcionError = mOPCServer.GetErrorString(ErrorNum)
End Property

'Devuelve la descripción de la calidad
Public Function DescripcionCalidad(Calidad As Long) As String
 Dim lCad As String
   
   'Inicia
   lCad = ""
   
   'Arma la descripcion dependiendo del código de calidad
   Select Case Calidad
      Case OPC_QUALITY_BAD
         lCad = "Bad"
      Case OPC_QUALITY_UNCERTAIN
         lCad = "Uncertain"
      Case OPC_QUALITY_GOOD
         lCad = "Good"
      Case OPC_QUALITY_CONFIG_ERROR
         lCad = "Bad - Configuration error"
      Case OPC_QUALITY_NOT_CONNECTED
         lCad = "Bad - Not connected"
      Case OPC_QUALITY_DEVICE_FAILURE
         lCad = "Bad - Device failure"
      Case OPC_QUALITY_SENSOR_FAILURE
         lCad = "Bad - Sensor failure"
      Case OPC_QUALITY_LAST_KNOWN
         lCad = "Bad - Last known value"
      Case OPC_QUALITY_COMM_FAILURE
         lCad = "Bad - Communication failure"
      Case OPC_QUALITY_OUT_OF_SERVICE
         lCad = "Bad - Out of service"
      Case OPC_QUALITY_LAST_USABLE
         lCad = "Uncertain - Last usable value"
      Case OPC_QUALITY_SENSOR_CAL
         lCad = "Uncertain - Sensor not accurate"
      Case OPC_QUALITY_EGU_EXCEEDED
         lCad = "Uncertain - EGU exceeded"
      Case OPC_QUALITY_SUB_NORMAL
         lCad = "Uncertain - Sub-normal"
      Case OPC_QUALITY_LOCAL_OVERRIDE
         lCad = "Good - Local override"
   End Select
   'Regresa la descripción
   DescripcionCalidad = lCad
End Function


'Genera el evento TagLeido
Friend Sub Evento_TagLeido(ByVal Grupo As String, ByVal TagName As String, _
                           ByVal Valor As Variant, ByVal Calidad As Long, _
                           ByVal Error As Long, ByVal Nota As String, _
                           ByVal TransactionID As Long)
   RaiseEvent TagLeido(Grupo, TagName, Valor, Calidad, Error, Nota, TransactionID)
End Sub

Public Function LeerTag(TagName As String, Optional Error As Long, Optional Grupo As String) As Variant
 Dim lGrupo As String

   'Inicia
   lGrupo = Grupo
   If lGrupo = "" Then lGrupo = mGrupoDefault
   
   'Invoca la lectura Síncrona del Tag
   LeerTag = mGrupos(lGrupo).LeerTag(TagName, Error)
End Function

Public Function EscribirTag(TagName As String, Valor As Variant, Optional Grupo As String) As Boolean
 Dim lGrupo As String

   'Inicia
   lGrupo = Grupo
   If lGrupo = "" Then lGrupo = mGrupoDefault
   
   'Invoca la Escritura Síncrona del Tag
   EscribirTag = mGrupos(lGrupo).EscribirTag(TagName, Valor)
End Function


Public Sub LeerGrupo(Optional ByVal Grupo As String = "")
 Dim lGrupo As String

   'Inicia
   lGrupo = Grupo
   If lGrupo = "" Then lGrupo = mGrupoDefault
   
   'Verifica que el grupo sea asíncrono
   If mGrupos(lGrupo).EsAsincrono Then
      'Invoca la lectura Asíncrona del Grupo
      mGrupos(lGrupo).LeerGrupo
   Else
      MsgBox "El grupo debe ser asíncrono para poder usar esta función", vbExclamation, "TSRLinx.LeerGrupo"
   End If
End Sub


Private Sub mOPCServer_ServerShutDown(ByVal Reason As String)
   'MsgBox "Se cerró RSLinx." & vbCrLf & Reason, vbCritical, "TSRLinx"
   Me.Desconectar
   RaiseEvent Desconexion(Reason)
End Sub

