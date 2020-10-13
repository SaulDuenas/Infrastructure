VERSION 5.00
Begin VB.Form Finaliza_app 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Finalizar la Aplicacion"
   ClientHeight    =   3525
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6315
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   3525
   ScaleWidth      =   6315
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton btn_Aceptar 
      Caption         =   "&Aceptar"
      Height          =   495
      Left            =   3840
      TabIndex        =   4
      Top             =   2400
      Width           =   1695
   End
   Begin VB.CommandButton btn_Cancelar 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   495
      Left            =   480
      TabIndex        =   3
      Top             =   2400
      Width           =   1695
   End
   Begin VB.TextBox txtpasal 
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
      IMEMode         =   3  'DISABLE
      Left            =   2160
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   1080
      Width           =   1695
   End
   Begin VB.Label lblmsgf 
      Height          =   615
      Left            =   480
      TabIndex        =   5
      Top             =   1680
      Width           =   5055
   End
   Begin VB.Label Label2 
      BackColor       =   &H00808000&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Password:"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   480
      TabIndex        =   1
      Top             =   1080
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "Teclee el Password para Finalizar la Aplicacion."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   600
      TabIndex        =   0
      Top             =   240
      Width           =   5535
   End
End
Attribute VB_Name = "Finaliza_app"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub btn_Aceptar_Click()

If txtpasal.Text <> pasw_ma And txtpasal.Text <> pasw_us Then
    lblmsgf.Caption = " P A S S W O R D  I N V A L I D O "
    txtpasal.Text = ""
Else
    Unload Finaliza_app
    Unload Principal
    Close
    End
End If
    



End Sub

Private Sub btn_Cancelar_Click()
    Unload Me
End Sub

