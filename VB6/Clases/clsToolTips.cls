VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsToolTips"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit


'declaraciones Api
''''''''''''''''''''''''''''''''''
Private Declare Sub InitCommonControls Lib "comctl32.dll" ()

Private Declare Function CreateWindowEx Lib "user32" Alias "CreateWindowExA" ( _
    ByVal dwExStyle As Long, _
    ByVal lpClassName As String, _
    ByVal lpWindowName As String, _
    ByVal dwStyle As Long, _
    ByVal x As Long, _
    ByVal Y As Long, _
    ByVal nWidth As Long, _
    ByVal nHeight As Long, _
    ByVal hWndParent As Long, _
    ByVal hMenu As Long, _
    ByVal hInstance As Long, _
    lpParam As Any) As Long

Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" ( _
    ByVal hwnd As Long, _
    ByVal wMsg As Long, _
    ByVal wParam As Long, _
    lParam As Any) As Long

Private Declare Function SendMessageLong Lib "user32" Alias "SendMessageA" ( _
    ByVal hwnd As Long, _
    ByVal wMsg As Long, _
    ByVal wParam As Long, _
    ByVal lParam As Long) As Long

Private Declare Function DestroyWindow Lib "user32" (ByVal hwnd As Long) As Long

'Constantes y UDT
''''''''''''''''''''''''''''''''''

Private Const WM_USER = &H400
Private Const CW_USEDEFAULT = &H80000000
Private Type RECT
        Left As Long
        Top As Long
        Right As Long
        Bottom As Long
End Type

' declaración de constantes
'''''''''''''''''''''''''''''''''''''''''''''''''

Private Const TTS_NOPREFIX = &H2
Private Const TTF_TRANSPARENT = &H100
Private Const TTF_CENTERTIP = &H2
Private Const TTM_ADDTOOLA = (WM_USER + 4)
Private Const TTM_ACTIVATE = WM_USER + 1
Private Const TTM_UPDATETIPTEXTA = (WM_USER + 12)
Private Const TTM_SETMAXTIPWIDTH = (WM_USER + 24)
Private Const TTM_SETTIPBKCOLOR = (WM_USER + 19)
Private Const TTM_SETTIPTEXTCOLOR = (WM_USER + 20)
Private Const TTM_SETTITLE = (WM_USER + 32)
Private Const TTS_BALLOON = &H40
Private Const TTS_ALWAYSTIP = &H1
Private Const TTF_SUBCLASS = &H10
Private Const TTF_IDISHWND = &H1
Private Const TTM_SETDELAYTIME = (WM_USER + 3)
Private Const TTDT_AUTOPOP = 2
Private Const TTDT_INITIAL = 3

' enum, tipos
''''''''''''''''''''''''''''''''''''''''''''''''''

Private Const TOOLTIPS_CLASSA = "tooltips_class32"

Private Type TOOLINFO
    lSize As Long
    lFlags As Long
    hwnd As Long
    lId As Long
    lpRect As RECT
    hInstance As Long
    lpStr As String
    lParam As Long
End Type


Public Enum ttIconType
    TTNoIcon = 0
    TTIconInfo = 1
    TTIconWarning = 2
    TTIconError = 3
End Enum

Public Enum ttStyleEnum
    TTStandard
    TTBalloon
End Enum


' variables locales
''''''''''''''''''''''''''''''''''''
Private mvarBackColor As Long
Private mvarTitle As String
Private mvarForeColor As Long
Private mvarIcon As ttIconType
Private mvarCentered As Boolean
Private mvarStyle As ttStyleEnum
Private mvarTipText As String
Private mvarVisibleTime As Long
Private mvarDelayTime As Long


Private m_lTTHwnd As Long
Private m_lParentHwnd As Long
Private ti As TOOLINFO

' declaración de propiedades
'''''''''''''''''''''''''''''''''''''''''''''''

' tipo de Tip
''''''''''''''

Public Property Let Estilo(ByVal vData As ttStyleEnum)
   mvarStyle = vData
End Property

Public Property Get Estilo() As ttStyleEnum
   Estilo = mvarStyle
End Property

' para centrarlo
''''''''''''''''''''

Public Property Let Centrar(ByVal vData As Boolean)
   mvarCentered = vData
End Property

Public Property Get Centrar() As Boolean
   Centrar = mvarCentered
End Property

' crea el Tip ( se le pasa el Hwnd del control )
'''''''''''''''''''''''
Public Function Crear(ByVal ParentHwnd As Long) As Boolean
   Dim lWinStyle As Long
   
   If m_lTTHwnd <> 0 Then
      DestroyWindow m_lTTHwnd
   End If
   
   m_lParentHwnd = ParentHwnd
   
   lWinStyle = TTS_ALWAYSTIP Or TTS_NOPREFIX
   If mvarStyle = TTBalloon Then lWinStyle = lWinStyle Or TTS_BALLOON
    
   m_lTTHwnd = CreateWindowEx(0&, _
      TOOLTIPS_CLASSA, _
      vbNullString, _
      lWinStyle, _
      CW_USEDEFAULT, _
      CW_USEDEFAULT, _
      CW_USEDEFAULT, _
      CW_USEDEFAULT, _
      0&, _
      0&, _
      App.hInstance, _
      0&)
               
   With ti
      If mvarCentered Then
         .lFlags = TTF_SUBCLASS Or TTF_CENTERTIP Or TTF_IDISHWND
      Else
         .lFlags = TTF_SUBCLASS Or TTF_IDISHWND
      End If
       
      
      .hwnd = m_lParentHwnd
      .lId = m_lParentHwnd '0
      .hInstance = App.hInstance
      .lSize = Len(ti)
   End With
   
   SendMessage m_lTTHwnd, TTM_ADDTOOLA, 0&, ti

   ' Establece el titulo
   If mvarTitle <> vbNullString Or mvarIcon <> TTNoIcon Then
      SendMessage m_lTTHwnd, TTM_SETTITLE, CLng(mvarIcon), ByVal mvarTitle
   End If
   ' Establece el Forecolor
   If mvarForeColor <> Empty Then
      SendMessage m_lTTHwnd, TTM_SETTIPTEXTCOLOR, mvarForeColor, 0&
   End If
   ' Establece el color de fondo
   If mvarBackColor <> Empty Then
      SendMessage m_lTTHwnd, TTM_SETTIPBKCOLOR, mvarBackColor, 0&
   End If
   
   SendMessageLong m_lTTHwnd, TTM_SETDELAYTIME, TTDT_AUTOPOP, mvarVisibleTime
   SendMessageLong m_lTTHwnd, TTM_SETDELAYTIME, TTDT_INITIAL, mvarDelayTime
End Function

' icono del Tip
'''''''''''''''''''''''''

Public Property Let Icono(ByVal vData As ttIconType)
   mvarIcon = vData
   If m_lTTHwnd <> 0 And mvarTitle <> Empty And mvarIcon <> TTNoIcon Then
      SendMessage m_lTTHwnd, TTM_SETTITLE, CLng(mvarIcon), ByVal mvarTitle
   End If
End Property

Public Property Get Icono() As ttIconType
   Icono = mvarIcon
End Property

' Color de la fuente

Public Property Let ForeColor(ByVal vData As Long)
   mvarForeColor = vData
   If m_lTTHwnd <> 0 Then
      SendMessage m_lTTHwnd, TTM_SETTIPTEXTCOLOR, mvarForeColor, 0&
   End If
End Property

Public Property Get ForeColor() As Long
   ForeColor = mvarForeColor
End Property

' Establece y recupera el Titulo
''''''''''''''''''''''''''''''''''''''''''''

Public Property Let Titulo(ByVal vData As String)
   mvarTitle = vData
   If m_lTTHwnd <> 0 And mvarTitle <> Empty And mvarIcon <> TTNoIcon Then
      SendMessage m_lTTHwnd, TTM_SETTITLE, CLng(mvarIcon), ByVal mvarTitle
   End If
End Property

Public Property Get Titulo() As String
   Titulo = ti.lpStr
End Property

' Color de fondo de la ventana del Tips
'''''''''''''''''''''''''''''''''''''''''

Public Property Let BackColor(ByVal vData As Long)
   mvarBackColor = vData
   If m_lTTHwnd <> 0 Then
      SendMessage m_lTTHwnd, TTM_SETTIPBKCOLOR, mvarBackColor, 0&
   End If
End Property

Public Property Get BackColor() As Long
   BackColor = mvarBackColor
End Property

' Establece y recupera El Texto
'''''''''''''''''''''''''''''''''''

Public Property Let Texto(ByVal vData As String)
   mvarTipText = vData
   ti.lpStr = vData
   If m_lTTHwnd <> 0 Then
      SendMessage m_lTTHwnd, TTM_UPDATETIPTEXTA, 0&, ti
   End If
End Property

Public Property Get Texto() As String
   Texto = mvarTipText
End Property

' inicio de la clase
''''''''''''''''''''''''''''''

Private Sub Class_Initialize()
   InitCommonControls
   mvarDelayTime = 500
   mvarVisibleTime = 5000
End Sub

Private Sub Class_Terminate()
   Destroy
End Sub

' Método que finaliza y destruye la ventana
''''''''''''''''''''''''''''''''''''''''''''
Public Sub Destroy()
   If m_lTTHwnd <> 0 Then
      DestroyWindow m_lTTHwnd
   End If
End Sub

'Para el tiempo que durará ( en milisegundos )
'''''''''''''''''''''''''''''''''''''''''''''''

Public Property Get Duracion() As Long
   Duracion = mvarVisibleTime
End Property

Public Property Let Duracion(ByVal lData As Long)
   mvarVisibleTime = lData
End Property

' tiempo que tardará en ser visible
'''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Property Get Delay() As Long
   Delay = mvarDelayTime
End Property

Public Property Let Delay(ByVal lData As Long)
   mvarDelayTime = lData
End Property

