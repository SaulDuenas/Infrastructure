VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form frmWizardDesviaciones 
   Appearance      =   0  'Flat
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Asistente para cambios de componentes en manifiestos."
   ClientHeight    =   7905
   ClientLeft      =   1800
   ClientTop       =   2385
   ClientWidth     =   15255
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmWizardDesviaciones.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "frmWizardDesviaciones.frx":0442
   ScaleHeight     =   7905
   ScaleWidth      =   15255
   Tag             =   "10"
   Begin VB.PictureBox picNav 
      Align           =   2  'Align Bottom
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   720
      Left            =   0
      ScaleHeight     =   720
      ScaleWidth      =   15255
      TabIndex        =   0
      Top             =   7185
      Width           =   15255
      Begin VB.CommandButton cmdNav 
         Caption         =   "&Finalizar"
         Height          =   405
         Index           =   4
         Left            =   13830
         MaskColor       =   &H00000000&
         TabIndex        =   4
         Tag             =   "104"
         Top             =   150
         Width           =   1155
      End
      Begin VB.CommandButton cmdNav 
         Caption         =   "&Siguiente >"
         Height          =   375
         Index           =   3
         Left            =   12405
         MaskColor       =   &H00000000&
         TabIndex        =   3
         Tag             =   "103"
         Top             =   180
         Width           =   1155
      End
      Begin VB.CommandButton cmdNav 
         Caption         =   "< &Anterior"
         Height          =   375
         Index           =   2
         Left            =   11235
         MaskColor       =   &H00000000&
         TabIndex        =   2
         Tag             =   "102"
         Top             =   180
         Width           =   1155
      End
      Begin VB.CommandButton cmdNav 
         Cancel          =   -1  'True
         Caption         =   "Cancelar"
         Height          =   375
         Index           =   1
         Left            =   9690
         MaskColor       =   &H00000000&
         TabIndex        =   1
         Tag             =   "101"
         Top             =   180
         Width           =   1215
      End
      Begin VB.Line Line1 
         BorderColor     =   &H00808080&
         Index           =   1
         X1              =   80
         X2              =   15200
         Y1              =   0
         Y2              =   0
      End
      Begin VB.Line Line1 
         BorderColor     =   &H00FFFFFF&
         Index           =   0
         X1              =   108
         X2              =   7012
         Y1              =   24
         Y2              =   24
      End
   End
   Begin VB.Frame fraStep 
      BorderStyle     =   0  'None
      Caption         =   "Step 5"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   7215
      Index           =   5
      Left            =   -16000
      TabIndex        =   21
      Tag             =   "2000"
      Top             =   0
      Width           =   15615
      Begin VB.Frame FraPaso5 
         Height          =   6705
         Left            =   2670
         TabIndex        =   22
         Top             =   420
         Width           =   12510
      End
      Begin VB.Image image 
         BorderStyle     =   1  'Fixed Single
         Height          =   7140
         Index           =   4
         Left            =   0
         Picture         =   "frmWizardDesviaciones.frx":0E12
         Stretch         =   -1  'True
         Top             =   0
         Width           =   2610
      End
      Begin VB.Label lblStep 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "lblStep05"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   15.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Index           =   5
         Left            =   2730
         TabIndex        =   23
         Top             =   60
         Width           =   1245
      End
   End
   Begin VB.Frame fraStep 
      BorderStyle     =   0  'None
      Caption         =   "Introduction Screen"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   7215
      Index           =   0
      Left            =   0
      TabIndex        =   5
      Tag             =   "1000"
      Top             =   0
      Width           =   15225
      Begin VB.Label lblEsteEs 
         BackStyle       =   0  'Transparent
         Caption         =   $"frmWizardDesviaciones.frx":B4F1
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   900
         Left            =   4200
         TabIndex        =   20
         Top             =   840
         Width           =   8295
      End
      Begin VB.Image image 
         BorderStyle     =   1  'Fixed Single
         Height          =   4455
         Index           =   5
         Left            =   120
         Picture         =   "frmWizardDesviaciones.frx":B5BE
         Stretch         =   -1  'True
         Top             =   120
         Width           =   3885
      End
      Begin VB.Label lblBienvenido 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Bienvenido:"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   15.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   4155
         TabIndex        =   11
         Top             =   285
         Width           =   1650
      End
      Begin VB.Label lblEstosCambios 
         BackStyle       =   0  'Transparent
         Caption         =   $"frmWizardDesviaciones.frx":3D9C8
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1785
         Left            =   4200
         TabIndex        =   10
         Top             =   1920
         Width           =   8325
      End
   End
   Begin VB.Frame fraStep 
      BorderStyle     =   0  'None
      Caption         =   "Step 1"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   7215
      Index           =   1
      Left            =   -16000
      TabIndex        =   6
      Tag             =   "2000"
      Top             =   0
      Width           =   15615
      Begin VB.Frame FraPaso1 
         Height          =   6705
         Left            =   2670
         TabIndex        =   12
         Top             =   420
         Width           =   12510
         Begin MSFlexGridLib.MSFlexGrid grdPartes 
            Height          =   2955
            Left            =   90
            TabIndex        =   24
            Top             =   3630
            Width           =   12315
            _ExtentX        =   21722
            _ExtentY        =   5212
            _Version        =   393216
            Cols            =   22
            BackColorSel    =   14786427
            AllowBigSelection=   0   'False
            FocusRect       =   2
            SelectionMode   =   1
            AllowUserResizing=   1
            FormatString    =   $"frmWizardDesviaciones.frx":3DAB4
         End
      End
      Begin VB.Image image 
         BorderStyle     =   1  'Fixed Single
         Height          =   7140
         Index           =   0
         Left            =   0
         Picture         =   "frmWizardDesviaciones.frx":3DBAC
         Stretch         =   -1  'True
         Top             =   0
         Width           =   2610
      End
      Begin VB.Label lblStep 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "lblStep01"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   15.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Index           =   1
         Left            =   2730
         TabIndex        =   13
         Top             =   60
         Width           =   10365
      End
   End
   Begin VB.Frame fraStep 
      BorderStyle     =   0  'None
      Caption         =   "Step 2"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   7215
      Index           =   2
      Left            =   -16000
      TabIndex        =   7
      Tag             =   "2002"
      Top             =   0
      Width           =   15615
      Begin VB.Frame FraPaso2 
         Height          =   6705
         Left            =   2670
         TabIndex        =   15
         Top             =   420
         Width           =   12510
      End
      Begin VB.Image image 
         BorderStyle     =   1  'Fixed Single
         Height          =   7140
         Index           =   1
         Left            =   0
         Picture         =   "frmWizardDesviaciones.frx":48216
         Stretch         =   -1  'True
         Top             =   0
         Width           =   2610
      End
      Begin VB.Label lblStep 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "lblStep02"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   15.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Index           =   2
         Left            =   2730
         TabIndex        =   14
         Top             =   60
         Width           =   10365
      End
   End
   Begin VB.Frame fraStep 
      BorderStyle     =   0  'None
      Caption         =   "Step 3"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   7215
      Index           =   3
      Left            =   -16000
      TabIndex        =   8
      Tag             =   "2004"
      Top             =   0
      Width           =   15615
      Begin VB.Frame FraPaso3 
         Height          =   6705
         Left            =   2670
         TabIndex        =   16
         Top             =   420
         Width           =   12510
      End
      Begin VB.Image image 
         BorderStyle     =   1  'Fixed Single
         Height          =   7140
         Index           =   2
         Left            =   0
         Picture         =   "frmWizardDesviaciones.frx":528F5
         Stretch         =   -1  'True
         Top             =   0
         Width           =   2610
      End
      Begin VB.Label lblStep 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "lblStep03"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   15.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Index           =   3
         Left            =   2730
         TabIndex        =   17
         Top             =   60
         Width           =   10365
      End
   End
   Begin VB.Frame fraStep 
      BorderStyle     =   0  'None
      Caption         =   "Step 4"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   7215
      Index           =   4
      Left            =   -16000
      TabIndex        =   9
      Tag             =   "2006"
      Top             =   0
      Width           =   15615
      Begin VB.Frame FraPaso4 
         Height          =   6705
         Left            =   2670
         TabIndex        =   18
         Top             =   420
         Width           =   12510
      End
      Begin VB.Image image 
         BorderStyle     =   1  'Fixed Single
         Height          =   7140
         Index           =   3
         Left            =   0
         Picture         =   "frmWizardDesviaciones.frx":5CFD4
         Stretch         =   -1  'True
         Top             =   0
         Width           =   2610
      End
      Begin VB.Label lblStep 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "lblStep04"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   15.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Index           =   4
         Left            =   2730
         TabIndex        =   19
         Top             =   60
         Width           =   10365
      End
   End
End
Attribute VB_Name = "frmWizardDesviaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'*********************************************************************************************
'*   Módulo: frmWizard                                                                       *
'*   Nombre: frmWizard                                                                       *
'* Objetivo: Plantilla para asistente                                                        *
'*                                                                                           *
'*                                                                                           *
'* Parámetros:                                                                               *
'*        -Entrada-                                                                          *
'*                  No tiene                                                                 *
'*                                                                                           *
'*        -Salida-                                                                           *
'*                  No Tiene                                                                 *
'*                                                                                           *
'*  Versión: 1.0                                                                             *
'*    Autor: TSR-SDB                                                                         *
'*    Fecha: 09/11/2011                                                                      *
'*                                                                                           *
'*********************************************************************************************


Option Explicit

'******** Constantes para el control del asistente ********
' Establece el numero de pasos que consiste el asistente
Const NUM_STEPS = 6

Const RES_ERROR_MSG = 30000

Const HIDE_STEP As Integer = -16000
' Identificadores de botones de navegación del asistente
Const BTN_HELP = 0
Const BTN_CANCEL = 1
Const BTN_BACK = 2
Const BTN_NEXT = 3
Const BTN_FINISH = 4

' Se declaran constantes para cada pantalla para el asistente
Const STEP_INTRO = 0
Const STEP_1 = 1
Const STEP_2 = 2
Const STEP_3 = 3
Const STEP_4 = 4
Const STEP_FINISH = 5

Const DIR_NONE = 0
Const DIR_BACK = 1
Const DIR_NEXT = 2

Const FRM_TITLE = "Programación de cambios de Ingenieria"

Dim mStepTitle() As String

'******** Variables usadas en el control del asistente ********

Dim mnCurStep       As Integer
Dim mbHelpStarted   As Boolean

'Public VBInst       As VBIDE.VBE
Dim mbFinishOK      As Boolean
'
Dim mRetVal As Boolean

'*************************************************************************
'* Procedimiento: Presenta.                                              *
'*      Objetivo: Presentar el asistente  *
'*         Autor: TSR-SDB.                                               *
'*    Parámetros:                                                        *
'*                -Entrada-                                              *
'*                          No tiene                                     *
'*                                                                       *
'*         Fecha: 14/Noviembre/2011.                                     *
'*************************************************************************
Public Function Presenta() As Boolean

   ' [1] Preparar el formulario
   Call PreparaFormulario

   ' [4] Mostrar asistente
   Me.Show vbModal
   
   Presenta = mRetVal
   ' [5] Cerrar ventana
   Unload Me

End Function



'*************************************************************************
'* Procedimiento: Init_Wizard.                                           *
'*      Objetivo: Inicializa los componentes y pantallas del asistente   *
'*         Autor: TSR-SDB.                                               *
'*    Parámetros:                                                        *
'*                -Entrada-                                              *
'*                          No tiene                                     *
'*                                                                       *
'*         Fecha: 14/Noviembre/2011.                                     *
'*************************************************************************
Private Sub Init_Wizard()
   Dim i As Integer
   
   mbFinishOK = False
   ReDim mStepTitle(NUM_STEPS)
    
    
   ' Ocultamos todas las pantallas
   For i = 0 To NUM_STEPS - 1
     fraStep(i).Left = HIDE_STEP
   Next
   
   ' Se establecen los titulos de cada paso
   mStepTitle(STEP_INTRO) = "Introducción"
   mStepTitle(STEP_1) = "PASO 1: Selección de Operaciones"
   mStepTitle(STEP_2) = "PASO 2: Selección de Componentes"
   mStepTitle(STEP_3) = "PASO 3: Manifiestos Afectados"
   mStepTitle(STEP_4) = "PASO 4: Picklist Afectados"
   mStepTitle(STEP_FINISH) = "PASO 5: Resumen de Operaciones y Finalización"
   
   
   SetStep 0, DIR_NONE

End Sub




Private Sub Form_Load()
   
    
    'FNCentrar Me
    
    Call Init_Wizard
   
End Sub


Private Sub cmdNav_Click(Index As Integer)
    Dim nAltStep As Integer
    Dim lHelpTopic As Long
    Dim rc As Long
    
    Select Case Index
                
        Case BTN_CANCEL
        
             mRetVal = False
             ' Ocultamos la ventana
             Me.Hide
         
        Case BTN_BACK
            'place special cases here to jump
            'to alternate steps
            nAltStep = mnCurStep - 1
            SetStep nAltStep, DIR_BACK
          
        Case BTN_NEXT
            'place special cases here to jump
            'to alternate steps
            nAltStep = mnCurStep + 1
            SetStep nAltStep, DIR_NEXT
          
        Case BTN_FINISH
            ' Ocultamos la ventana
            Me.Hide
    
    End Select
    
End Sub


Private Sub SetNavBtns(nStep As Integer)
    mnCurStep = nStep
    
    If mnCurStep = 0 Then
        cmdNav(BTN_BACK).Enabled = False
        cmdNav(BTN_NEXT).Enabled = True
    ElseIf mnCurStep = NUM_STEPS - 1 Then
        cmdNav(BTN_NEXT).Enabled = False
        cmdNav(BTN_BACK).Enabled = True
    Else
        cmdNav(BTN_BACK).Enabled = True
        cmdNav(BTN_NEXT).Enabled = True
    End If
    
    cmdNav(BTN_FINISH).Enabled = mbFinishOK

End Sub


Private Sub SetCaption(nStep As Integer)
    On Error Resume Next

    Me.Caption = FRM_TITLE & " - " & mStepTitle(nStep)

End Sub


Private Sub Form_Unload(Cancel As Integer)
'    On Error Resume Next
'    Dim rc As Long
    
    
End Sub


' < Evento de la navegación >
' Se establecen los para cada pantalla
' Debe de coincidir el numero de pantallas con los casos del Select Case
'
Private Sub SetStep(nStep As Integer, nDirection As Integer)
  
    Select Case nStep
        Case STEP_INTRO
      
        Case STEP_1
             
        Case STEP_2
             
        Case STEP_3
             
        Case STEP_4
        
             mbFinishOK = False
             
        Case STEP_FINISH
              
             mbFinishOK = True
        
    End Select
    
    
    If nStep > STEP_INTRO Then lblStep(nStep).Caption = mStepTitle(nStep)
    
    'move to new step
    fraStep(mnCurStep).Enabled = False
    fraStep(nStep).Left = 0
    If nStep <> mnCurStep Then
        fraStep(mnCurStep).Left = HIDE_STEP
    End If
    fraStep(nStep).Enabled = True
  
    SetCaption nStep
    SetNavBtns nStep
  
End Sub



' *****************************   Sección de la solución *************************************




'*************************************************************************
'* Procedimiento: PreparaFormulario.                                     *
'*      Objetivo: Tiene la Rutina para preparar el formulario            *
'*         Autor: TSR-SDB.                                               *
'*    Parámetros:                                                        *
'*                -Entrada-                                              *
'*                          No tiene                                     *
'*                                                                       *
'*         Fecha: 14/Noviembre/2011.                                     *
'*************************************************************************
Private Sub PreparaFormulario()
 
   cmdNav(BTN_NEXT).Enabled = True

End Sub
