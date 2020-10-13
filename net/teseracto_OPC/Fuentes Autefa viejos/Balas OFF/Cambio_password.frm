VERSION 5.00
Begin VB.Form Cambio_password 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "CAMBIO DE PASSWORD."
   ClientHeight    =   4455
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   7800
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   4455
   ScaleWidth      =   7800
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton Command2 
      Caption         =   "Registrar nuevo Password"
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
      Left            =   3960
      TabIndex        =   11
      Top             =   3360
      Width           =   2175
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
      Left            =   840
      TabIndex        =   10
      Top             =   3360
      Width           =   2055
   End
   Begin VB.TextBox txtpanv 
      Enabled         =   0   'False
      Height          =   375
      IMEMode         =   3  'DISABLE
      Left            =   5160
      PasswordChar    =   "*"
      TabIndex        =   8
      Top             =   1680
      Width           =   1935
   End
   Begin VB.TextBox txtpant 
      Height          =   375
      IMEMode         =   3  'DISABLE
      Left            =   5160
      PasswordChar    =   "*"
      TabIndex        =   7
      Top             =   600
      Width           =   1935
   End
   Begin VB.Frame Frame1 
      Caption         =   "Tipo de Password"
      Height          =   1335
      Left            =   240
      TabIndex        =   0
      Top             =   480
      Width           =   1575
      Begin VB.OptionButton btn_maestro 
         Caption         =   "Maestro"
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   840
         Width           =   1335
      End
      Begin VB.OptionButton btn_usuario 
         Caption         =   "Usuario"
         Height          =   255
         Left            =   120
         TabIndex        =   1
         Top             =   360
         Width           =   1335
      End
   End
   Begin VB.Label lblmencp 
      BackColor       =   &H8000000B&
      BorderStyle     =   1  'Fixed Single
      Height          =   495
      Left            =   480
      TabIndex        =   9
      Top             =   2400
      Width           =   6495
   End
   Begin VB.Label Label4 
      Caption         =   "(Maximo de 8 Caracteres)"
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
      Left            =   2400
      TabIndex        =   6
      Top             =   1920
      Width           =   2295
   End
   Begin VB.Label Label3 
      BackColor       =   &H8000000A&
      Caption         =   "Introducir el Nuevo Password"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   2160
      TabIndex        =   5
      Top             =   1680
      Width           =   2895
   End
   Begin VB.Label Label2 
      Caption         =   "y luego presionar <ENTER>"
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
      Left            =   2160
      TabIndex        =   4
      Top             =   960
      Width           =   2535
   End
   Begin VB.Label Label1 
      BackColor       =   &H8000000B&
      Caption         =   "Introducir el Password Anterior"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   2160
      TabIndex        =   3
      Top             =   600
      Width           =   2895
   End
End
Attribute VB_Name = "Cambio_password"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim num_reg As Integer
Dim contar As Integer
Dim pas_ante As String


Private Sub btn_maestro_Click()
    pasw_gr = pasw_us
    num_reg = 2
    txtpant.SetFocus
    txtpant.SelStart = 0
End Sub

Private Sub btn_usuario_Click()
    pasw_gr = pasw_us
    num_reg = 1
    txtpant.SetFocus
    txtpant.SelStart = 0
End Sub

Private Sub Command1_Click()
    Unload Me
End Sub

Private Sub Command2_Click()
    Dim i As Integer
    Dim cartem As String * 1
    Dim nvopas As String * 8

password = ""
    For i = 1 To Len(txtpanv.Text)
        cartem = Mid(txtpanv.Text, i, 1)
        If Asc(cartem) > 32 Then
            password = password + Chr(Asc(cartem) + 1)
        End If
    Next i
    nvopas = password
    MsgBox filenum
    Put #filenum, num_reg, nvopas
    If num_reg = 1 Then
        pasw_us = txtpanv.Text
    Else
        pasw_ma = txtpanv.Text
    End If
    Unload Me
End Sub


Private Sub Form_Load()
txtpanv.Enabled = False
Command2.Enabled = False

End Sub

Private Sub txtpant_GotFocus()
    lblmencp.Caption = ""
End Sub

Private Sub txtpant_KeyPress(KeyAscii As Integer)
    If KeyAscii <> 13 Then
    Else
        If txtpant.Text = pasw_gr Then
            txtpanv.Enabled = True
            contar = 0
            lblmencp.Caption = ""
            txtpanv.SetFocus
            txtpanv.SelStart = 0
        Else
            lblmencp.Caption = "P A S S W O R D   I N V A L I D O "
            txtpant.Text = ""
        End If
    End If
        
End Sub


Private Sub txtpanv_KeyPress(KeyAscii As Integer)
    If KeyAscii <> 13 Then
        ' no hace nada
    Else
        If contar = 0 Then
            pas_ante = txtpanv.Text
            txtpanv.Text = ""
            txtpanv.SetFocus
            txtpanv.SelStart = 0
            lblmencp.Caption = "Favor de Reintroducir el Nuevo Password"
            contar = 1
        Else
            If pas_ante <> txtpanv.Text Then
                lblmencp.Caption = "El Nuevo password No Corresponde"
                txtpanv.Text = ""
                txtpanv.SetFocus
                txtpanv.SelStart = 0
            Else
                Command2.Enabled = True
                Command2.SetFocus
                lblmencp.Caption = ""
            End If
        End If
    End If
End Sub
