VERSION 5.00
Begin VB.Form VALIDA_CONEX 
   Caption         =   "VALIDA CONEXION"
   ClientHeight    =   1770
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7785
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   1770
   ScaleWidth      =   7785
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Interval        =   500
      Left            =   7200
      Top             =   1080
   End
   Begin VB.TextBox RSDSEGUNDO 
      Height          =   405
      Left            =   7200
      LinkItem        =   "S:23"
      LinkTopic       =   "RSLINX|PLC_3"
      TabIndex        =   1
      Text            =   "34"
      Top             =   480
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.Label Label1 
      BorderStyle     =   1  'Fixed Single
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   360
      TabIndex        =   0
      Top             =   480
      Width           =   6615
   End
End
Attribute VB_Name = "VALIDA_CONEX"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
    Label1.Caption = "VALIDANDO CONEXION CON PLC..."
    'RSDSEGUNDO.LinkMode = 2
End Sub

Private Sub Timer1_Timer()
    Err.Clear
    On Error GoTo SALTA
    RSDSEGUNDO.LinkMode = 2
    RSDSEGUNDO.LinkRequest
    Label1.Caption = "CONEXION EXISTOSA!!!"
    Call MANDA_PRINCIPAL
    
    Exit Sub
SALTA:
    Label1.Caption = "ERROR DE COMUNICACION CON EL PLC, REINTENTANDO..."
End Sub


Sub MANDA_PRINCIPAL()
    Call main
    Unload Me
End Sub
