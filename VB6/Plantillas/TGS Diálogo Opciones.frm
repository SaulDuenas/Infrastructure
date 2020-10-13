VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form frmOpciones 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Opciones"
   ClientHeight    =   4770
   ClientLeft      =   2655
   ClientTop       =   1470
   ClientWidth     =   5115
   Icon            =   "TSR Diálogo Opciones.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   318
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   341
   Begin VB.Frame fraTab 
      BorderStyle     =   0  'None
      Height          =   3555
      Index           =   0
      Left            =   180
      TabIndex        =   1
      Top             =   480
      Width           =   4755
      Begin VB.Label Label2 
         BorderStyle     =   1  'Fixed Single
         Caption         =   "Para editarlos usa Ctrl-J para traerlos al frente o Ctrl-K para enviarlos atras"
         Height          =   555
         Left            =   660
         TabIndex        =   8
         Top             =   1860
         Width           =   3435
      End
      Begin VB.Label Label1 
         BorderStyle     =   1  'Fixed Single
         Caption         =   "Recuerda poner tantos frames como tabs, este es el frame 0 que corresponde al primer tab"
         Height          =   555
         Left            =   720
         TabIndex        =   7
         Top             =   780
         Width           =   3435
      End
   End
   Begin VB.Frame fraTab 
      BorderStyle     =   0  'None
      Height          =   3495
      Index           =   3
      Left            =   180
      TabIndex        =   4
      Top             =   480
      Visible         =   0   'False
      Width           =   4755
   End
   Begin VB.Frame fraTab 
      BorderStyle     =   0  'None
      Height          =   3555
      Index           =   2
      Left            =   180
      TabIndex        =   3
      Top             =   480
      Visible         =   0   'False
      Width           =   4755
   End
   Begin VB.Frame fraTab 
      BorderStyle     =   0  'None
      Height          =   3555
      Index           =   1
      Left            =   180
      TabIndex        =   2
      Top             =   480
      Visible         =   0   'False
      Width           =   4755
   End
   Begin VB.CommandButton cmdOK 
      Cancel          =   -1  'True
      Caption         =   "&Aceptar"
      Height          =   375
      Left            =   2280
      TabIndex        =   6
      Top             =   4260
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   375
      Left            =   3720
      TabIndex        =   5
      Top             =   4260
      Width           =   1275
   End
   Begin ComctlLib.TabStrip tabDatos 
      Height          =   3975
      Left            =   120
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   120
      Width           =   4875
      _ExtentX        =   8599
      _ExtentY        =   7011
      ShowTips        =   0   'False
      _Version        =   327682
      BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
         NumTabs         =   4
         BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "Tab &1"
            Key             =   ""
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "Tab &2"
            Key             =   ""
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab3 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "Tab &3"
            Key             =   ""
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab4 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "Tab &4"
            Key             =   ""
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "frmOpciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Forma para Alta y modificación de Movimientos
Option Explicit

'*** Variables del módulo ***
Private mCurFrame%      'Almacena el Frame Actual (base en uno)
Private mOk As Boolean  'Indica si se oprimió el botón OK

Sub Presenta()
 
   'Inicia
   mCurFrame% = 1 'Inicia con el primer Tab/Frame
   mOk = False
      
   'Carga la forma
   Load Me
   
   
   'Llena/Inicializa Controles
   
   
   'Muestra la forma
   Me.Show vbModal
   
   'Procesa los datos capturados
   
   
   'Descarga la forma
   Unload Me

End Sub

Private Sub Form_Load()
   'Centra la forma
   FNCentrar Me
End Sub

Private Sub cmdCancel_Click()
   'Oculta la forma
   Me.Hide
End Sub


Private Sub cmdOK_Click()
   'Valida la forma
   If Valida() Then
      mOk = True
      Me.Hide
   End If
End Sub

Private Function Valida() As Boolean
 Dim lOk As Boolean, lMsg$
   
   'Inicia
   lOk = True
   
   
'1. Valida que se cumpla tal cosa
'   If Condicion_de_error Then
'      lMsg$ = "Mensaje de error"
'      Control.SetFocus
'      lOk = False
'   End If
'   If Not lOk Then GoTo ExitValida


ExitValida:
   If Not lOk And lMsg$ <> "" Then FNExclamBox lMsg$
   Valida = lOk
End Function




'****** FUNCIONALIDAD DE LA FORMA

'Procesa Ctrl-Tab para las pestañas
Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
 Dim i As Integer
   'handle ctrl+tab to move to the next tab
   If Shift = vbCtrlMask And KeyCode = vbKeyTab Then
       i = tabDatos.SelectedItem.Index
       If i = tabDatos.Tabs.Count Then
           'last tab so we need to wrap to tab 1
           Set tabDatos.SelectedItem = tabDatos.Tabs(1)
       Else
           'increment the tab
           Set tabDatos.SelectedItem = tabDatos.Tabs(i + 1)
       End If
   End If
End Sub

Private Sub tabDatos_Click()
   If tabDatos.SelectedItem.Index = mCurFrame% Then Exit Sub ' No need to change frame.
   
   ' Otherwise, hide old frame, show new.
   fraTab(tabDatos.SelectedItem.Index - 1).Visible = True
   fraTab(tabDatos.SelectedItem.Index - 1).ZOrder
   fraTab(mCurFrame% - 1).Visible = False
   
   ' Set mCurFrame% to new value.
   mCurFrame% = tabDatos.SelectedItem.Index
     
   ' Send focus to the corresponding control
   'Controlxx.SetFocus

End Sub



'Solo Mayúsculas en la forma
'Private Sub Form_KeyPress(KeyAscii As Integer)
'
'   'Todo en mayúsculas
'   KeyAscii = Asc(UCase(Chr(KeyAscii)))
'
'   'Solo se valen letras y la eñe
'   Select Case KeyAscii
'          'BkSpc,Tab,LF,CR,letras, números y símbolos estandar y eñe
'      Case 8, 9, 10, 13, 32 To 91, 93 To 95, 209
'         'No hago nada
'      Case 192 To 198 'Letras "A" acentuadas
'         KeyAscii = 65   ' "A"
'      Case 200 To 203 'Letras "E" acentuadas
'         KeyAscii = 69   ' "E"
'      Case 204 To 207 'Letras "I" acentuadas
'         KeyAscii = 73   ' "I"
'      Case 211 To 214 'Letras "O" acentuadas
'         KeyAscii = 79   ' "O"
'      Case 217 To 220 'Letras "U" acentuadas
'         KeyAscii = 85   ' "U"
'      Case Else
'         'Lo demás no juega
'         KeyAscii = 0
'   End Select
'End Sub

