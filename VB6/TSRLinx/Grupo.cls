VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Grupo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit


'variables locales para almacenar los valores de las propiedades
Private mEsActivo As Boolean
Private mEsAsincrono As Boolean
Private mVelActualiza As Variant
Private mTopico As String
Private mKey As String
Private mOPCServer As OPCServer
Private WithEvents mOPCGroup As OPCGroup
Attribute mOPCGroup.VB_VarHelpID = -1
Private mTSRLinx As TSRLinx

Private Const OPC_DS_CACHE As Long = 1  ' Para leer datos desde el cache de RSLinx (Scheduled)
Private Const OPC_DS_DEVICE As Long = 2 ' Para leer datos desde el dispositivo (DeviceSheduled)


'Tipo de dato para DataPoints
Private Type tDataPoint
   TagName As String
   Direccion As String
   Tipo As VariantTypeConstants
   ModoAcceso As lnxModoAcceso
   ServerHandle As Long
   FactorEscala As Double
   Nota As String            'Auxiliar para etiquetar alguna variable
End Type
Private mNumDataPoints As Long

'*******Arreglos y colecciones para Tags.******
'Arreglo principal de Tags, el índice del Arreglo es el ClientHandle
Private mDataPoints() As tDataPoint
'Coleccion de Tagnames para hacer búsquedas (TagName->ClientHandle)
Private mTagName2Idx As Collection
'Coleccion de ServerHandles para hacer búsquedas (ServerHandle->ClientHandle)
Private mSvrHdl2Idx As Collection



'variables locales para almacenar los valores de las propiedades
Private mNombreGrupo As String 'copia local

'Crear el Objeto OPCGroup
Private Sub Class_Initialize()
   mNumDataPoints = 0
   ReDim mDataPoints(1 To 10)
   Set mTagName2Idx = New Collection
   Set mSvrHdl2Idx = New Collection
End Sub

Private Sub Class_Terminate()
 Dim laErrores() As Long
 Dim laSvrHandles() As Long
   
   'Apaga el grupo
   'mOPCGroup.IsActive = False
   'mOPCGroup.IsSubscribed = False
   
   'Elimina Todos los Tags del Grupo
   If mNumDataPoints > 0 Then
      'Obtiene la lista de Server Handles
      GetSvrHandlesArray laSvrHandles
      
      'Los elimina del servidor OPC
      On Error Resume Next
      mOPCGroup.OPCItems.Remove mNumDataPoints, laSvrHandles, laErrores
      On Error GoTo 0
   End If
   Set mOPCGroup = Nothing
   
   'Elimina las colecciones
   Do While mTagName2Idx.Count > 0: mTagName2Idx.Remove 1: Loop
   Set mTagName2Idx = Nothing
   Do While mSvrHdl2Idx.Count > 0: mSvrHdl2Idx.Remove 1: Loop
   Set mSvrHdl2Idx = Nothing
   
   'Elimina el grupo OPC
   On Error Resume Next
   mOPCServer.OPCGroups.Remove mNombreGrupo
   On Error GoTo 0
   
   'Quita la referencias a objetos
   Set mOPCServer = Nothing
   Set mOPCGroup = Nothing
   Set mTSRLinx = Nothing
End Sub

'Obtiene un arreglo con todos los ServerHandles del grupo
Private Sub GetSvrHandlesArray(paServerHandles() As Long)
 Dim i As Long
   'Dimensiona el arreglo
   ReDim paServerHandles(1 To mNumDataPoints)
   'Lo carga
   For i = 1 To mNumDataPoints
      paServerHandles(i) = mDataPoints(i).ServerHandle
   Next
End Sub


'Nombre del grupo
Public Property Let Nombre(ByVal vData As String)
   mNombreGrupo = vData
End Property
Public Property Get Nombre() As String
   Nombre = mNombreGrupo
End Property

'Objeto OPCGroup
Friend Property Set OPCGroup(ByVal vData As OPCGroup)
   Set mOPCGroup = vData
End Property
Friend Property Get OPCGroup() As OPCGroup
   Set OPCGroup = mOPCGroup
End Property


'Establece el OPCServer
Friend Property Set OPCServer(ByVal pOPCServer As OPCServer)
   Set mOPCServer = pOPCServer
End Property
Friend Property Get OPCServer() As OPCServer
   Set OPCServer = mOPCServer
End Property


'Establece el Tópico del Grupo
Public Property Let Topico(ByVal vData As String)
   mTopico = vData
   mOPCGroup.OPCItems.DefaultAccessPath = mTopico
End Property
Public Property Get Topico() As String
    Topico = mTopico
End Property


'Indica si permite lectura/escritura asíncrona
Public Property Let EsAsincrono(ByVal vData As Boolean)
Attribute EsAsincrono.VB_Description = "Indica si se harán actualizaciones automáticas asíncronas"
   mEsAsincrono = vData
   mOPCGroup.IsSubscribed = mEsAsincrono
End Property
Public Property Get EsAsincrono() As Boolean
   EsAsincrono = mEsAsincrono
End Property


'Indica si el grupo está activo
Public Property Let EsActivo(ByVal vData As Boolean)
   mEsActivo = vData
   mOPCGroup.IsActive = mEsActivo
End Property
Public Property Get EsActivo() As Boolean
   EsActivo = mEsActivo
End Property

'Velocidad de Actualización del Grupo
Public Property Let VelActualiza(ByVal vData As Variant)
    mVelActualiza = vData
    mOPCGroup.UpdateRate = mVelActualiza
End Property
Public Property Get VelActualiza() As Variant
   VelActualiza = mVelActualiza
End Property

'Agrega un nuevo Tag al Grupo
Public Function NuevoTag(ByVal TagName As String, ByVal Direccion As String, _
                         ByVal Tipo As VariantTypeConstants, ByVal ModoAcceso As lnxModoAcceso, _
                         Optional ByVal FactorEscala As Double = 1, _
                         Optional ByVal Nota As String) As Boolean
 Dim lTam As Long
 Dim lIndice As Long
 Dim lOK As Boolean
 Dim lOPCItem As OPCItem
 Dim lDatapoint As tDataPoint
 
   'Inicia
   lOK = True
 
   'Obtiene el tamaño actual del arreglo
   lTam = UBound(mDataPoints)
   'Verifica que quepa el nuevo elemento
   If mNumDataPoints = lTam Then
      'Necesitamos hacer mas grande el arreglo
      ReDim Preserve mDataPoints(1 To lTam + 10)
   End If
   
   'Establece el nuevo índice
   lIndice = mNumDataPoints + 1
   
   'Primero añade el item en OPCItems
   On Error GoTo ErrHandler
   Set lOPCItem = mOPCGroup.OPCItems.AddItem(Direccion, lIndice)
   lOPCItem.RequestedDataType = Tipo '<-- Aqui hay error en Linx 2.20
   On Error GoTo 0
   
   'Después lo mete al arreglo
   With mDataPoints(lIndice)
      .TagName = TagName
      .Direccion = Direccion
      .Tipo = Tipo
      .ModoAcceso = ModoAcceso
      .ServerHandle = lOPCItem.ServerHandle
      .FactorEscala = FactorEscala
      .Nota = Nota
   End With
   
   'Lo agrega a las colecciones para realizar búsquedas
   mTagName2Idx.Add lIndice, TagName                    'Por Tag
   mSvrHdl2Idx.Add lIndice, CStr(lOPCItem.ServerHandle) 'Por ServerHandle
   
   'Actualiza el contador de elementos
   mNumDataPoints = lIndice
   
   Set lOPCItem = Nothing
   
Salida:
   NuevoTag = lOK
   Exit Function

ErrHandler:
   'MsgBox Err.Description, vbOKOnly + vbExclamation, "TSRLinx.Grupo.NuevoTag"
   lOK = False
   Resume Salida
   
End Function
'Establece el Objeto raiz
Friend Property Set TSRLinx(ByVal pTSRLinx As TSRLinx)
   Set mTSRLinx = pTSRLinx
End Property

'Genera el evento TagLeido para cada tag leído
Private Sub mOPCGroup_AsyncReadComplete(ByVal TransactionID As Long, ByVal NumItems As Long, ClientHandles() As Long, ItemValues() As Variant, Qualities() As Long, TimeStamps() As Date, Errors() As Long)
 Dim i As Long, lhTag As Long
 
   'Recorre la lista de tags reportados como leidos
   For i = 1 To NumItems
      lhTag = ClientHandles(i)
      'Es Numérico y tiene factor de escala?
      If (mDataPoints(lhTag).Tipo <> vbVString) And (mDataPoints(lhTag).FactorEscala <> 1) Then
         'Sí, Aplica factor de escala
         mTSRLinx.Evento_TagLeido mNombreGrupo, mDataPoints(lhTag).TagName, (ItemValues(i) * mDataPoints(lhTag).FactorEscala), Qualities(i), Errors(i), mDataPoints(lhTag).Nota, TransactionID
      Else
         'No, devuelve el valor tal cual
         mTSRLinx.Evento_TagLeido mNombreGrupo, mDataPoints(lhTag).TagName, ItemValues(i), Qualities(i), Errors(i), mDataPoints(lhTag).Nota, TransactionID
      End If
   Next
End Sub

'Dado que este evento hace casi lo mismo que AsyncReadComplete,
'Salvo que no regresa errores, entonces, para esta clase TSR vamos a tratarlo
'como si se tratara del mismo evento, estableciendo errores=0 (sin errores)
Private Sub mOPCGroup_DataChange(ByVal TransactionID As Long, ByVal NumItems As Long, ClientHandles() As Long, ItemValues() As Variant, Qualities() As Long, TimeStamps() As Date)
 Dim lErrores() As Long, i As Long
   'Crea un arreglo de errores de la misma longitud que el de datos.
   ReDim lErrores(LBound(ClientHandles) To UBound(ClientHandles))
   'Lo llena de ceros
   For i = LBound(ClientHandles) To UBound(ClientHandles): lErrores(i) = 0: Next
   'Lo pasa al evento AsyncReadComplete
   mOPCGroup_AsyncReadComplete TransactionID, NumItems, ClientHandles, ItemValues, Qualities, TimeStamps, lErrores
End Sub

Friend Function LeerTag(TagName, Error) As Variant
 Dim laValores() As Variant
 Dim laSvrHandles() As Long
 Dim laErrores() As Long
 Dim laCalidad() As Long
 Dim lNumItems As Long
 Dim lhTag As Long  'client Handle del Tag
 Dim i As Long, lMsg As String
 Dim lModoAcceso As lnxModoAcceso
 
   'Inicia
   'Vamos a leer un solo tag
   lNumItems = 1
   ReDim laValores(1 To 1)
   ReDim laSvrHandles(1 To 1)
   ReDim laErrores(1 To 1)
   ReDim laCalidad(1 To 1)

   
   'Obtenemos su ClientHandle
   lhTag = mTagName2Idx(TagName)
   
   'Establece el arreglo de serverhandles que se va a leer (uno solo)
   laSvrHandles(1) = mDataPoints(lhTag).ServerHandle
 
   'Lee el Tag
   On Error GoTo ErrHandler
   mOPCGroup.SyncRead mDataPoints(lhTag).ModoAcceso, lNumItems, laSvrHandles, laValores, laErrores ', laCalidad
   On Error GoTo 0
   
   'Recorre los arreglos de resultados (solo uno)
   For i = 1 To lNumItems
      'Verifica que no haya leido un arreglo en vez de un solo tag
      If VarType(laValores(i)) < vbArray Then
         'Obtiene sus valores
'         With mDataPoints(lhTag)
'            .Valor = laValores(i)
'            '.Calidad = laCalidad
'            .ErrorNum = laErrores(i)
'         End With
      Else
          MsgBox "Tipo de dato no esperado, se devolvió un arreglo cuando se esperaba un solo dato", vbCritical, "TSRLinx.Grupo.LeerTag"
          Exit Function
      End If
   Next i
   
   'Regresa
Salida:
   LeerTag = laValores(1)
   Exit Function
   
ErrHandler:
   Select Case Err.Number
      Case 2
         lMsg = ""
      Case Else
         lMsg = ""
   End Select
   MsgBox lMsg, vbExclamation, "TSRLinx.Grupo.LeerTag"
   Resume Salida
End Function

Friend Function EscribirTag(TagName, Valor) As Boolean
 Dim laValores() As Variant
 Dim laSvrHandles() As Long
 Dim laErrores() As Long
 Dim laCalidad() As Long
 Dim lNumItems As Long
 Dim lhTag As Long  'client Handle del Tag
 Dim i As Long, lMsg As String
 Dim lModoAcceso As lnxModoAcceso
 
   'Inicia
   'Vamos a escribir un solo tag
   lNumItems = 1
   ReDim laValores(1 To 1)
   ReDim laSvrHandles(1 To 1)
   ReDim laErrores(1 To 1)
   ReDim laCalidad(1 To 1)

   
   'Obtenemos su ClientHandle
   lhTag = mTagName2Idx(TagName)
   
   'Establece el arreglo de serverhandles que se va a escribir (uno solo)
   laSvrHandles(1) = mDataPoints(lhTag).ServerHandle
   
   'Establece el valor
   laValores(1) = Valor
 
   'Escribe el Tag
   On Error GoTo ErrHandler
   mOPCGroup.SyncWrite lNumItems, laSvrHandles, laValores, laErrores   ', laCalidad
   On Error GoTo 0
   
   
   'Regresa
Salida:
   EscribirTag = (laErrores(1) = 0)
   Exit Function
   
ErrHandler:
   Select Case Err.Number
      Case 2
         lMsg = ""
      Case Else
         lMsg = ""
   End Select
   MsgBox lMsg, vbExclamation, "TSRLinx.Grupo.EscribirTag"
   Resume Salida
End Function


Friend Sub LeerGrupo()
 Static lTran As Long
 Dim lDummy As Long
 Dim laValores() As Variant
 Dim laSvrHandles() As Long
 Dim laErrores() As Long
 Dim laCalidad() As Long
 Dim lNumItems As Long
 Dim lhTag As Long  'client Handle del Tag
 Dim i As Long, lMsg As String
 Dim lModoAcceso As lnxModoAcceso
 
 
   
   'Inicia
   If mNumDataPoints = 0 Then Exit Sub  'No hay nada que leer
   lTran = IIf(lTran = 1000000, 0, lTran + 1)
   
   'Vamos a leer todos los tags del grupo
   ReDim laSvrHandles(1 To mNumDataPoints)
   ReDim laErrores(1 To mNumDataPoints)
   ReDim laCalidad(1 To mNumDataPoints)

   'Obtenemos sus ServerHandles
   GetSvrHandlesArray laSvrHandles
   
   'Lee los Tags del Grupo
   On Error GoTo ErrHandler
   mOPCGroup.AsyncRead mNumDataPoints, laSvrHandles, laErrores, lTran, lDummy
   On Error GoTo 0
   
Salida:
   'Regresa
   Exit Sub
   
ErrHandler:
   Select Case Err.Number
      Case 2
         lMsg = ""
      Case Else
         lMsg = ""
   End Select
   MsgBox lMsg, vbExclamation, "TSRLinx.Grupo.LeerGrupo"
   Resume Salida
End Sub

