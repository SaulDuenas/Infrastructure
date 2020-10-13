VERSION 5.00
Begin VB.Form Error_Comunicacion 
   BackColor       =   &H000000FF&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Error de Comunicacion"
   ClientHeight    =   3570
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   7530
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   3570
   ScaleWidth      =   7530
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CMD_EJECUTA_RSLINX 
      Caption         =   "EJECUTAR"
      Height          =   375
      Left            =   3000
      TabIndex        =   4
      Top             =   2760
      Width           =   1335
   End
   Begin VB.CommandButton CMD_OK 
      Caption         =   "OK"
      Height          =   375
      Left            =   3000
      TabIndex        =   1
      Top             =   2160
      Width           =   1335
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "¿EJECUTAR RSLINX?"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   2760
      Width           =   2655
   End
   Begin VB.Label comu_err1 
      BackColor       =   &H80000009&
      BorderStyle     =   1  'Fixed Single
      Height          =   735
      Left            =   240
      TabIndex        =   2
      Top             =   1200
      Width           =   7095
   End
   Begin VB.Label comu_err 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   1  'Fixed Single
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   7095
   End
End
Attribute VB_Name = "Error_Comunicacion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub CMD_EJECUTA_RSLINX_Click()
Dim numerito As Integer
    hay_error = False
    numerito = Shell("C:\Program Files\Rockwell Software\RSLINX\RSLINX.EXE")
    Unload Me
End Sub

Private Sub CMD_OK_Click()
hay_error = False
Unload Me
End Sub

Private Sub Form_Load()
'Error_Comunicacion.Height = Screen.Height
'Error_Comunicacion.Width = Screen.Width

'Error_Comunicacion.Top = (Screen.Height / 2) - Error_Comunicacion.Height / 2
'Error_Comunicacion.Left = (Screen.Width / 2) - Error_Comunicacion.Width / 2

comu_err.Caption = fr_err
comu_err1.Caption = fr_err1
Err.Clear
End Sub


