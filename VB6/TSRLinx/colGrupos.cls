VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "colGrupos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"Grupo"
Attribute VB_Ext_KEY = "Member0" ,"Grupo"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit


Private Declare Function GetSystemDefaultLCID Lib "kernel32" () As Long
Private Declare Function GetUserDefaultLCID Lib "kernel32" () As Long

'variable local para contener colección
Private mCol As Collection
Private mOPCServer As OPCServer
Private mTSRLinx As TSRLinx

Public Function Add(Key As String, Topico As String, ModoAsincrono As Boolean, VelActualiza As Variant) As Grupo
 Dim lNewGrupo As Grupo
 Dim lOPCGroup As OPCGroup
 
   'Crear un nuevo Grupo
   Set lNewGrupo = New Grupo
   'Crea el OPCGroup
   Set lOPCGroup = mOPCServer.OPCGroups.Add(Key)
   
   
'   Debug.Print lOPCGroup.LocaleID
'   Debug.Print GetSystemDefaultLCID
'   Debug.Print GetUserDefaultLCID
'   lOPCGroup.LocaleID = GetUserDefaultLCID

   'Establece propiedades Iniciales
   Set lNewGrupo.OPCServer = mOPCServer
   Set lNewGrupo.OPCGroup = lOPCGroup
   Set lNewGrupo.TSRLinx = mTSRLinx
   lNewGrupo.Nombre = Key
   lNewGrupo.EsAsincrono = ModoAsincrono
   lNewGrupo.EsActivo = False
   lNewGrupo.Topico = Topico
   lNewGrupo.VelActualiza = VelActualiza
   
           
   'Lo añade a la Colección
   mCol.Add lNewGrupo, Key

   'Devuelve el objeto creado
   Set Add = lNewGrupo
   Set lNewGrupo = Nothing
End Function

Public Property Get Item(vntIndexKey As Variant) As Grupo
Attribute Item.VB_UserMemId = 0
    'se usa al hacer referencia a un elemento de la colección
    'vntIndexKey contiene el índice o la clave de la colección,
    'por lo que se declara como un Variant
    'Syntax: Set foo = x.Item(xyz) or Set foo = x.Item(5)
  Set Item = mCol(vntIndexKey)
End Property



Public Property Get Count() As Long
    'se usa al obtener el número de elementos de la
    'colección. Sintaxis: Debug.Print x.Count
    Count = mCol.Count
End Property


Public Sub Remove(vntIndexKey As Variant)
    'se usa al quitar un elemento de la colección
    'vntIndexKey contiene el índice o la clave, por lo que se
    'declara como un Variant
    'Sintaxis: x.Remove(xyz)


    mCol.Remove vntIndexKey
End Sub

'Elimina todos los elementos de la colección
Public Sub RemoveAll()
   Do While mCol.Count > 0
      mCol.Remove 1
   Loop
End Sub



Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    'esta propiedad permite enumerar
    'esta colección con la sintaxis For...Each
    Set NewEnum = mCol.[_NewEnum]
End Property


Private Sub Class_Initialize()
    'crea la colección cuando se crea la clase
    Set mCol = New Collection
End Sub


Private Sub Class_Terminate()
    'destruye la colección cuando se termina la clase
    Set mCol = Nothing
    Set mOPCServer = Nothing
    Set mTSRLinx = Nothing
End Sub

'Establece el OPCServer
Friend Property Set OPCServer(ByVal pOPCServer As OPCServer)
   Set mOPCServer = pOPCServer
End Property
Friend Property Get OPCServer() As OPCServer
   Set OPCServer = mOPCServer
End Property

'Establece el Objeto raiz
Friend Property Set TSRLinx(ByVal pTSRLinx As TSRLinx)
   Set mTSRLinx = pTSRLinx
End Property

