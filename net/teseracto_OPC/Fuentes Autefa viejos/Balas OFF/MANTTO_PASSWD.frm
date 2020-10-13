VERSION 5.00
Begin VB.Form MANTTO_PASSWD 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Acceso al Modulo de Mantenimiento"
   ClientHeight    =   3270
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6495
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   3270
   ScaleWidth      =   6495
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton Command2 
      Caption         =   "&Aceptar"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   3000
      TabIndex        =   5
      Top             =   2640
      Width           =   1815
   End
   Begin VB.CommandButton Command1 
      Caption         =   "&Regresar"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   600
      TabIndex        =   4
      Top             =   2640
      Width           =   1815
   End
   Begin VB.TextBox txtpasm 
      Height          =   495
      IMEMode         =   3  'DISABLE
      Left            =   2040
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   1080
      Width           =   1815
   End
   Begin VB.Label lblmsgm 
      BorderStyle     =   1  'Fixed Single
      Height          =   495
      Left            =   360
      TabIndex        =   3
      Top             =   1800
      Width           =   5775
   End
   Begin VB.Label Label2 
      Caption         =   "Password"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   720
      TabIndex        =   1
      Top             =   1080
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "Teclee el Password para Accesar al Modulo de Mantenimiento"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   360
      TabIndex        =   0
      Top             =   240
      Width           =   5775
   End
End
Attribute VB_Name = "MANTTO_PASSWD"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    Unload Me

End Sub

Private Sub Command2_Click()
    If txtpasm.Text <> pasw_ma And txtpasm.Text <> pasw_us Then
        lblmsgm.Caption = " P A S S W O R D    I N V A L I D O "
        txtpasm.Text = ""
        txtpasm.SetFocus
    Else
        MANTTO_PASSWD.Hide
        MANTENIMIENTO.Show
    End If
End Sub

Private Sub Form_Load()
'    MANTTO_PASSWD.Height = Screen.Height
'    MANTTO_PASSWD.Width = Screen.Width
'    MANTTO_PASSWD.Top = (Screen.Height / 2) - MANTTO_PASSWD.Height / 2
'    MANTTO_PASSWD.Left = (Screen.Width / 2) - Screen.Width / 2

End Sub
