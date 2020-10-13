VERSION 5.00
Begin VB.Form AboutDialog 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About TSR-GRID"
   ClientHeight    =   1410
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   3660
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1410
   ScaleWidth      =   3660
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton OKButton 
      Caption         =   "OK"
      Height          =   375
      Left            =   2280
      TabIndex        =   0
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label Label3 
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   0
      Left            =   300
      TabIndex        =   1
      Top             =   180
      Width           =   915
   End
End
Attribute VB_Name = "AboutDialog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub OKButton_Click()
   Unload Me
End Sub
