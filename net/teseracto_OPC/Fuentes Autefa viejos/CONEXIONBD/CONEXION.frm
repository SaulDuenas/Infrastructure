VERSION 5.00
Begin VB.Form CONEXIONBD 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "CONECTA"
      Height          =   375
      Left            =   1440
      TabIndex        =   0
      Top             =   960
      Width           =   1935
   End
End
Attribute VB_Name = "CONEXIONBD"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
On Error GoTo SALTA

 ' Abre una conexión sin usar un Data Source Name (DSN).
    Set cnn1 = New ADODB.Connection
    cnn1.ConnectionString = "driver={SQL Server};" & _
        "server=MXQROSSQL001;uid=;pwd=;database=SAPPP"
        
    cnn1.ConnectionTimeout = 1
    cnn1.Open
    'aqui ya tengo la base de datos abierta
    MsgBox "CONEXION EXITOSA"
    Exit Sub
SALTA:
    MsgBox "ERROR EN CONEXION"

End Sub
