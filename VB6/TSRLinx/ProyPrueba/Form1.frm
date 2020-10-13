VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3915
   ClientLeft      =   1200
   ClientTop       =   2220
   ClientWidth     =   9420
   LinkTopic       =   "Form1"
   ScaleHeight     =   3915
   ScaleWidth      =   9420
   Begin VB.CommandButton Command7 
      Caption         =   "Command7"
      Height          =   255
      Left            =   1260
      TabIndex        =   8
      Top             =   3420
      Width           =   675
   End
   Begin VB.TextBox txtMensaje 
      BackColor       =   &H8000000F&
      Height          =   735
      Left            =   2580
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   7
      Text            =   "Form1.frx":0000
      Top             =   2880
      Width           =   6495
   End
   Begin VB.CommandButton Command6 
      Caption         =   "Leer Grupo"
      Height          =   435
      Left            =   120
      TabIndex        =   6
      Top             =   1140
      Width           =   2235
   End
   Begin VB.CommandButton Command5 
      Caption         =   "Desactivar Polling"
      Height          =   375
      Left            =   120
      TabIndex        =   5
      Top             =   2160
      Width           =   2235
   End
   Begin VB.ListBox lstMensajes 
      Height          =   2595
      Left            =   2520
      TabIndex        =   4
      Top             =   120
      Width           =   6555
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Activar Polling"
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   1680
      Width           =   2235
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Desconectar"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   2700
      Width           =   2235
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Leer Tag"
      Height          =   435
      Left            =   120
      TabIndex        =   1
      Top             =   600
      Width           =   2235
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Conectar"
      Height          =   435
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   2235
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim WithEvents mTSRLinx As TSRLinx
Attribute mTSRLinx.VB_VarHelpID = -1

'Conectar
Private Sub Command1_Click()
 Dim lFolio As String
   
   'Crea un nombre unico de Grupo
   lFolio = Format(Now, "HHMMSS")
   
   'Crea el Objeto
   Set mTSRLinx = New TSRLinx

   'se Conecta
   mTSRLinx.Conectar
   

   'Crea un Grupo
   mTSRLinx.NuevoGrupo "Grupo Mike " & lFolio, "SEY", True, 1000
   
   
   mTSRLinx.NuevoTag "ActiveAlarmValue", "Celda[0].ActiveAlarmValue", vbVLong, lnxDeviceScheduled
'   mTSRLinx.NuevoTag "TestDINT", "TestDINT", vbVLong, lnxDeviceScheduled
'   mTSRLinx.NuevoTag "TestINT", "TestINT", vbVLong, lnxDeviceScheduled
'   mTSRLinx.NuevoTag "TestSTRING", "TestSTRING", vbVString, lnxDeviceScheduled
'   mTSRLinx.NuevoTag "Nombre", "Sesion[0].Nombre.DATA,sc80", vbVString, lnxDeviceScheduled
   

'   mTSRLinx.EliminaGrupo "Grupo1"
'
'   mTSRLinx.EliminaTag(TagName,[pGpo])
'
'   mTSRLinx.IniciaComm
'
'   mTSRLinx.LeerGrupo lnxSincrono, "Grupo Mike"
'
'    MsgBox mTSRLinx.LeerTag(TagName)   ', [Error], [Grupo]
'
'   mTSRLinx.DetieneComm ([Grupo])
'
'   mTSRLinx.Desconectar
   MsgBox "Conectado"
End Sub

'Lee Tag
Private Sub Command2_Click()
 Dim lValor As Variant, lError As Long
 
  'Lee el Tag
  lValor = mTSRLinx.LeerTag("ActiveAlarmValue", lError)
    
  'Muestra el valor
  MsgBox "MiTag= " & lValor & vbCrLf & _
         "Error= " & lError

End Sub


'Activar Polling
Private Sub Command4_Click()
   mTSRLinx.IniciaComm
End Sub

'Desactiva Polling
Private Sub Command5_Click()
   mTSRLinx.DetieneComm
End Sub

'Desconectar de RSLinx
Private Sub Command3_Click()
   'Se desconecta
   mTSRLinx.Desconectar
   'Destruye el objeto
   Set mTSRLinx = Nothing
   MsgBox "Desconectado"
End Sub


Private Sub Command6_Click()
   mTSRLinx.LeerGrupo
End Sub

Private Sub Command7_Click()
   mTSRLinx.EscribirTag "ActiveAlarmValue", 99
End Sub

Private Sub lstMensajes_Click()
   txtMensaje = lstMensajes
End Sub

'Ocurre cuando se lee un Tag
Private Sub mTSRLinx_TagLeido(ByVal Grupo As String, ByVal TagName As String, ByVal Valor As Variant, ByVal Calidad As Long, ByVal Error As Long, ByVal Nota As String, ByVal TransactionID As Long)
   'Lo mete a la lista
   lstMensajes.AddItem TagName & "= " & Valor & "   -C: " & mTSRLinx.DescripcionCalidad(Calidad) & "   -E: " & mTSRLinx.DescripcionError(Error)
End Sub
