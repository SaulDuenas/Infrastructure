VERSION 5.00
Begin VB.Form frm_contingencia 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "CONTINGENCIA"
   ClientHeight    =   3525
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6825
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   3525
   ScaleWidth      =   6825
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton Command2 
      Caption         =   "&Regresar"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   3600
      TabIndex        =   4
      Top             =   1800
      Width           =   2055
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Aceptar Password"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   3600
      TabIndex        =   3
      Top             =   1200
      Width           =   2055
   End
   Begin VB.TextBox txtpasc 
      Height          =   495
      IMEMode         =   3  'DISABLE
      Left            =   1680
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   1200
      Width           =   1575
   End
   Begin VB.Label lblmsgc 
      Height          =   855
      Left            =   120
      TabIndex        =   5
      Top             =   2520
      Width           =   6615
   End
   Begin VB.Label Label2 
      Caption         =   "Password:"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   600
      TabIndex        =   1
      Top             =   1320
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "Teclee el Password para INICIAR la Transferencia a (Dispositivos) de las Balas NO Registradas en la Base de Datos SQL Server."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   360
      TabIndex        =   0
      Top             =   120
      Width           =   5895
   End
End
Attribute VB_Name = "frm_contingencia"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Dim nomarch As String

If txtpasc.Text <> pasw_ma And txtpasc.Text <> pasw_us Then
    lblmsgc.Caption = "P A S S W O R D   I N V A L I D O"
    txtpasc.Text = ""
    txtpasc.SetFocus
Else
    nomarch = ""
    nomarch = Dir("c:\cont\balas.off")
    If nomarch <> "balas.off" Then
        lblmsgc.Caption = "No existen Balas a R E C U P E R A R "
        txtpasc.Text = ""
    Else
        On Error GoTo falla_c
        FileCopy "C:\cont\balas.off", "c:\cont\ba" + CStr(Format$(Now, "hhmmss")) + ".off"
        FileCopy "C:\cont\balas.off", "d:\BALASCON\balas.off"
        nomarch = Dir("c:\cont\balas.off")
        If nomarch = "balas.off" Then
            Kill "c:\cont\balas.off"
            lblmsgc.Caption = "Transferencia Efectuada E X I T O S A M E N T E"
        End If
    End If
End If
Exit Sub

falla_c:
    txtpasc.Text = ""
    Select Case Err.Number
        Case 57
            lblmsgc.Caption = "Transferencia INCOMPLETA, Device I/O ERROR "
        Case 61
            lblmsgc.Caption = "Transferencia INCOMPLETA, Disk d:\> Full "
        Case 68
            lblmsgc.Caption = "Transferencia INCOMPLETA, Device Unavilable "
        Case 70
            lblmsgc.Caption = "Transferencia INCOMPLETA, Disk d:\> is Write Protected "
        Case 71
            lblmsgc.Caption = "Transferencia INCOMPLETA, Disk d:\> Not Ready "
        Case 72
            lblmsgc.Caption = "Transferencia INCOMPLETA, Disk Media Error "
        Case Else
            lblmsgc.Caption = "Transferencia INCOMPLETA, Error no Definido, Consulte al Operador "
        End Select


End Sub

Private Sub Command2_Click()
    Unload Me
End Sub

Private Sub Form_Activate()
    txtpasc.SetFocus
End Sub


Private Sub Form_Unload(Cancel As Integer)
    Principal.SetFocus
End Sub
