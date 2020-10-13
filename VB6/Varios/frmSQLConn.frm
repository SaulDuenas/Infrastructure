VERSION 5.00
Begin VB.Form frmSQLConn 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Configurar conexión a SQL"
   ClientHeight    =   2910
   ClientLeft      =   5100
   ClientTop       =   4965
   ClientWidth     =   4215
   Icon            =   "frmSQLConn.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2910
   ScaleWidth      =   4215
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   450
      Left            =   2295
      TabIndex        =   10
      Top             =   2340
      Width           =   1440
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   450
      Left            =   600
      TabIndex        =   9
      Top             =   2340
      Width           =   1440
   End
   Begin VB.Frame fraStep3 
      Caption         =   "Parámetros de C&onexión"
      Height          =   2055
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   3990
      Begin VB.TextBox txtDBName 
         Height          =   300
         IMEMode         =   3  'DISABLE
         Left            =   1320
         TabIndex        =   4
         Top             =   720
         Width           =   2355
      End
      Begin VB.TextBox txtServer 
         Height          =   300
         Left            =   1320
         TabIndex        =   2
         Top             =   360
         Width           =   2355
      End
      Begin VB.TextBox txtUser 
         Height          =   300
         Left            =   1320
         TabIndex        =   6
         Top             =   1080
         Width           =   2355
      End
      Begin VB.TextBox txtPassword 
         Height          =   300
         IMEMode         =   3  'DISABLE
         Left            =   1320
         PasswordChar    =   "*"
         TabIndex        =   8
         Top             =   1440
         Width           =   2355
      End
      Begin VB.Label lblStep3 
         AutoSize        =   -1  'True
         Caption         =   "&Base de Datos:"
         Height          =   195
         Index           =   1
         Left            =   135
         TabIndex        =   3
         Top             =   780
         Width           =   1095
      End
      Begin VB.Label lblStep3 
         AutoSize        =   -1  'True
         Caption         =   "&Servidor:"
         Height          =   195
         Index           =   0
         Left            =   600
         TabIndex        =   1
         Top             =   420
         Width           =   630
      End
      Begin VB.Label lblStep3 
         AutoSize        =   -1  'True
         Caption         =   "&Usuario:"
         Height          =   195
         Index           =   2
         Left            =   645
         TabIndex        =   5
         Top             =   1140
         Width           =   585
      End
      Begin VB.Label lblStep3 
         AutoSize        =   -1  'True
         Caption         =   "&Password:"
         Height          =   195
         Index           =   3
         Left            =   495
         TabIndex        =   7
         Top             =   1500
         Width           =   735
      End
   End
End
Attribute VB_Name = "frmSQLConn"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Forma para configurar la conexión con la base de datos usando OLE DB
Option Explicit


'********** Propiedades de la Forma *******
Private mOK As Boolean  'Indica si se salió con Aceptar

Public Function Presenta(Optional pSilent As Boolean = False) As Boolean
 'Variables de BD y HTTP
 Dim SVR As String
 Dim SQLSVR As String
 Dim IP As String
 Dim DSN As String
 Dim UID As String
 Dim PWD As String
 'Otras Variables
 Dim lOK As Boolean
 Dim lhKey As Long
 Dim lModo As Integer
 
   'Inicializa mOK
   mOK = False
   'Carga la forma
   Load Me
                   
   'Llena los campos con lo que está guardado en el registro
   lhKey = FNRegistroAbrir(HKEY_PRINCIPAL, HKEY_APP & "\Conn", False, True)
   If lhKey <> 0 Then
      txtServer = FNRegistroLeer(lhKey, "Server", "(local)")
      txtDBName = FNRegistroLeer(lhKey, "DBName", "")
      txtUser = FNRegistroLeer(lhKey, "User")
      txtPassword = FNDesEncripta(FNRegistroLeer(lhKey, "Password"), GKey%)
      FNRegistroCerrar lhKey
   End If
   If txtServer = "" Then txtServer = "(local)"
   
   
   'Presenta la forma
   Me.Show vbModal
   
   'Lee los cambios en la forma
   If mOK Then
      'Fija las variable globales para conexión con los datos de la forma
      lOK = True
      
      'Server (SVR)
      APP_Server = txtServer
      APP_DBName = txtDBName
      APP_User = txtUser
      APP_Password = txtPassword
      
      'Escribe en el Registro los parámetros
      lhKey = FNRegistroAbrir(HKEY_PRINCIPAL, HKEY_APP & "\Conn", True)
      If lhKey <> 0 Then
         FNRegistroEscribir lhKey, "Server", APP_Server
         FNRegistroEscribir lhKey, "DBName", APP_DBName
         FNRegistroEscribir lhKey, "User", APP_User
         FNRegistroEscribir lhKey, "Password", FNEncripta(APP_Password, GKey%)
         FNRegistroCerrar lhKey
      Else
         lOK = False
      End If
      
      'Manda un aviso al usuario
      If lOK Then
         If Not pSilent Then
            FNInfoBox "Para que los cambios surtan efecto debe terminar la aplicación y volver a iniciarla"
         End If
      Else
         'En caso de error, lo reporta
         FNErrorBox "No se pudo guardar la configuración en el Registro de Windows"
      End If
   End If

   'Descarga la forma
   Unload Me
   'Regresa
   Presenta = mOK
End Function

Private Sub cmdCancel_Click()
   'Se salió sin OK
   mOK = False
   'Oculta la forma
   Me.Hide
End Sub

Private Sub cmdOK_Click()
   'Se salió con OK
   mOK = True
   'Oculta la forma
   Me.Hide
End Sub

Private Sub Form_Load()
   'Centra la forma
   FNCentrar Me
   'Inicializa mOK
   mOK = False
End Sub

