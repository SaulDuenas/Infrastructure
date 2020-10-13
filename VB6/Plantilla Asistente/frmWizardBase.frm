VERSION 5.00
Begin VB.Form frmWizardBase 
   Appearance      =   0  'Flat
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Asistente para cambios de componentes en manifiestos."
   ClientHeight    =   5235
   ClientLeft      =   3360
   ClientTop       =   4095
   ClientWidth     =   12765
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
   Icon            =   "frmWizardBase.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "frmWizardBase.frx":0442
   ScaleHeight     =   5235
   ScaleWidth      =   12765
   Tag             =   "10"
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
      Height          =   4635
      Index           =   0
      Left            =   -15000
      TabIndex        =   5
      Tag             =   "1000"
      Top             =   0
      Width           =   12615
      Begin VB.Label lblEsteEs 
         BackStyle       =   0  'Transparent
         Caption         =   $"frmWizardBase.frx":310C
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
      Begin VB.Image imgStep 
         BorderStyle     =   1  'Fixed Single
         Height          =   4455
         Index           =   0
         Left            =   120
         Picture         =   "frmWizardBase.frx":31D9
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
         Caption         =   $"frmWizardBase.frx":355E3
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
      Height          =   4665
      Index           =   1
      Left            =   -15000
      TabIndex        =   6
      Tag             =   "2000"
      Top             =   0
      Width           =   12675
      Begin VB.Frame frmPaso1 
         Height          =   4155
         Left            =   2220
         TabIndex        =   12
         Top             =   420
         Width           =   10440
      End
      Begin VB.Image Image 
         BorderStyle     =   1  'Fixed Single
         Height          =   4575
         Index           =   0
         Left            =   0
         Picture         =   "frmWizardBase.frx":356CF
         Top             =   7
         Width           =   2220
      End
      Begin VB.Label lblStep01 
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
         Left            =   2235
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
      Height          =   4665
      Index           =   2
      Left            =   -15000
      TabIndex        =   7
      Tag             =   "2002"
      Top             =   0
      Width           =   12675
      Begin VB.Frame FrmPaso2 
         Height          =   4155
         Left            =   2220
         TabIndex        =   15
         Top             =   420
         Width           =   10440
      End
      Begin VB.Image Image 
         BorderStyle     =   1  'Fixed Single
         Height          =   4575
         Index           =   1
         Left            =   0
         Picture         =   "frmWizardBase.frx":3BA4F
         Top             =   0
         Width           =   2220
      End
      Begin VB.Label lblStep02 
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
         Left            =   2235
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
      Height          =   4665
      Index           =   3
      Left            =   -15000
      TabIndex        =   8
      Tag             =   "2004"
      Top             =   0
      Width           =   12735
      Begin VB.Frame FraPaso3 
         Height          =   4155
         Left            =   2220
         TabIndex        =   16
         Top             =   420
         Width           =   10440
      End
      Begin VB.Image Image 
         BorderStyle     =   1  'Fixed Single
         Height          =   4575
         Index           =   2
         Left            =   0
         Picture         =   "frmWizardBase.frx":41DCB
         Top             =   0
         Width           =   2220
      End
      Begin VB.Label lblStep03 
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
         Left            =   2235
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
      Height          =   4665
      Index           =   4
      Left            =   0
      TabIndex        =   9
      Tag             =   "2006"
      Top             =   0
      Width           =   12735
      Begin VB.Frame FraPaso4 
         Height          =   4155
         Left            =   2220
         TabIndex        =   18
         Top             =   420
         Width           =   10440
      End
      Begin VB.Image Image 
         BorderStyle     =   1  'Fixed Single
         Height          =   4575
         Index           =   3
         Left            =   0
         Picture         =   "frmWizardBase.frx":4815F
         Top             =   0
         Width           =   2220
      End
      Begin VB.Label lblStep04 
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
         Left            =   2235
         TabIndex        =   19
         Top             =   60
         Width           =   10365
      End
   End
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
      Height          =   570
      Left            =   0
      ScaleHeight     =   570
      ScaleWidth      =   12765
      TabIndex        =   0
      Top             =   4665
      Width           =   12765
      Begin VB.CommandButton cmdNav 
         Caption         =   "&Finalizar"
         Height          =   312
         Index           =   4
         Left            =   11550
         MaskColor       =   &H00000000&
         TabIndex        =   4
         Tag             =   "104"
         Top             =   120
         Width           =   1092
      End
      Begin VB.CommandButton cmdNav 
         Caption         =   "&Siguiente >"
         Height          =   312
         Index           =   3
         Left            =   10185
         MaskColor       =   &H00000000&
         TabIndex        =   3
         Tag             =   "103"
         Top             =   120
         Width           =   1092
      End
      Begin VB.CommandButton cmdNav 
         Caption         =   "< &Anterior"
         Height          =   312
         Index           =   2
         Left            =   9075
         MaskColor       =   &H00000000&
         TabIndex        =   2
         Tag             =   "102"
         Top             =   120
         Width           =   1092
      End
      Begin VB.CommandButton cmdNav 
         Cancel          =   -1  'True
         Caption         =   "Cancelar"
         Height          =   312
         Index           =   1
         Left            =   7890
         MaskColor       =   &H00000000&
         TabIndex        =   1
         Tag             =   "101"
         Top             =   120
         Width           =   1092
      End
      Begin VB.Line Line1 
         BorderColor     =   &H00808080&
         Index           =   1
         X1              =   60
         X2              =   12660
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
End
Attribute VB_Name = "frmWizardBase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'*********************************************************************************************
'*   Módulo: frmWizard                                                                       *
'*   Nombre: frmWizard                                                                       *
'* Objetivo: Plantilla para asistente                *
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
Const NUM_STEPS = 5

Const RES_ERROR_MSG = 30000

'BASE VALUE FOR HELP FILE FOR THIS WIZARD:
Const HELP_BASE = 1000
Const HELP_FILE = "MYWIZARD.HLP"

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
Const STEP_FINISH = 4

Const DIR_NONE = 0
Const DIR_BACK = 1
Const DIR_NEXT = 2

Const FRM_TITLE = "Programación de cambios de componentes"

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
     fraStep(i).Left = -15000
   Next
   
   ' Se establecen los titulos de cada paso
   mStepTitle(STEP_INTRO) = "Asistente ...."
   mStepTitle(STEP_1) = "PASO 1:"
   mStepTitle(STEP_2) = "PASO 2:"
   mStepTitle(STEP_3) = "PASO 3:"
   mStepTitle(STEP_FINISH) = "PASO 4: Resumen de Acciones"
   
   
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
    
    '
    Call cmdNav_Ext(Index)
    
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
             lblStep01.Caption = mStepTitle(STEP_1)
        Case STEP_2
             lblStep02.Caption = mStepTitle(STEP_2)
        Case STEP_3
             lblStep03.Caption = mStepTitle(STEP_3)
             mbFinishOK = False
        Case STEP_FINISH
              lblStep04.Caption = mStepTitle(STEP_FINISH)
             mbFinishOK = True
        
    End Select
    
    'move to new step
    fraStep(mnCurStep).Enabled = False
    fraStep(nStep).Left = 0
    If nStep <> mnCurStep Then
        fraStep(mnCurStep).Left = -15000
    End If
    fraStep(nStep).Enabled = True
  
    SetCaption nStep
    SetNavBtns nStep
  
End Sub




' *****************************   Sección de la solución *************************************

'*********************************************************************************************
'*   Procedimiento: cmdNav_Ext                                                               *
'*                                                                                           *
'*   Objetivo:   Extención del evento cmdNav_click para usarla en la solución                *
'*                                                                                           *
'* Parámetros:                                                                               *
'*        -Entrada-                                                                          *
'*                  No tiene                                                                 *
'*                                                                                           *
'*        -Salida-                                                                           *
'*                  No tiene                                                                 *
'*                                                                                           *
'*   Autor: TSR-SDB                                                                          *
'*   Fecha: 10/11/2011                                                                       *
'*                                                                                           *
'*********************************************************************************************

Private Sub cmdNav_Ext(Optional Index As Integer = 0)


Select Case Index
                
        Case BTN_CANCEL
        
             mRetVal = False
             ' Ocultamos la ventana
             Me.Hide
         
        Case BTN_BACK

          
        Case BTN_NEXT

          
        Case BTN_FINISH
            ' Ocultamos la ventana
            mRetVal = True
            Me.Hide
    
    End Select
   
End Sub




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
