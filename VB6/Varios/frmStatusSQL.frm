VERSION 5.00
Begin VB.Form frmStatusSQL 
   Caption         =   "SQL Status"
   ClientHeight    =   1095
   ClientLeft      =   4335
   ClientTop       =   5100
   ClientWidth     =   3045
   Icon            =   "frmStatusSQL.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   1095
   ScaleWidth      =   3045
   Begin VB.Timer Timer 
      Interval        =   2000
      Left            =   120
      Top             =   600
   End
   Begin VB.CommandButton cmdCancelar 
      Caption         =   "&Cancelar"
      Height          =   375
      Left            =   915
      TabIndex        =   1
      Top             =   600
      Width           =   1215
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Esperando a que inicie el servicio SQL..."
      Height          =   195
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   2865
   End
End
Attribute VB_Name = "frmStatusSQL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancelar_Click()
   Unload Me
End Sub

Private Sub Form_Load()
   FNCentrar Me
End Sub

Private Sub Timer_Timer()
   If ServiceStatus(APP_Server, "MSSQLSERVER") = "Running" Then Unload Me
End Sub
