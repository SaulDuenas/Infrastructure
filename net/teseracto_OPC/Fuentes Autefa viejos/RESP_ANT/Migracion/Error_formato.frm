VERSION 5.00
Begin VB.Form Error_formato 
   BackColor       =   &H000000FF&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "¡ ERROR EN FORMATO !"
   ClientHeight    =   3840
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   9765
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   3840
   ScaleWidth      =   9765
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox forma_err 
      Height          =   1215
      Left            =   480
      TabIndex        =   1
      Top             =   720
      Width           =   8775
   End
   Begin VB.CommandButton Command1 
      Caption         =   "&ACEPTAR"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   975
      Left            =   2760
      TabIndex        =   0
      Top             =   2640
      Width           =   3855
   End
End
Attribute VB_Name = "Error_formato"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Unload Me
End Sub

Private Sub Form_Load()
'Error_formato.Height = Screen.Height
'Error_formato.Width = Screen.Width

'Error_formato.Top = (Screen.Height / 2) - Error_formato.Height / 2
'Error_formato.Left = (Screen.Width / 2) - Error_formato.Width / 2
forma_err.Text = fr_err
End Sub
