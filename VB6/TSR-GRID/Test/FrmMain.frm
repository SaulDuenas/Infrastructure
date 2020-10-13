VERSION 5.00
Object = "*\A..\TSRGrid.vbp"
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form FrmMain 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   7500
   ClientLeft      =   3870
   ClientTop       =   2115
   ClientWidth     =   9750
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7500
   ScaleWidth      =   9750
   Begin MSFlexGridLib.MSFlexGrid MSFlexGrid 
      Height          =   3075
      Left            =   60
      TabIndex        =   11
      Top             =   180
      Width           =   7335
      _ExtentX        =   12938
      _ExtentY        =   5424
      _Version        =   393216
      Cols            =   5
      FixedCols       =   0
      AllowUserResizing=   1
      Appearance      =   0
   End
   Begin TSRGrid.TSR_Grid TSR_Grid 
      Height          =   3525
      Left            =   90
      TabIndex        =   10
      Top             =   3930
      Width           =   7335
      _ExtentX        =   12938
      _ExtentY        =   6218
      EnterKeyBehaviour=   0
      BackColorAlternate=   12648447
      GridLinesFixed  =   2
      AllowUserResizing=   3
      BackColor       =   -2147483628
      BackColorFixed  =   -2147483626
      Cols            =   6
      FixedCols       =   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      GridColor       =   -2147483630
      GridColorFixed  =   12632256
      HighLight       =   0
      MouseIcon       =   "FrmMain.frx":0000
      Rows            =   1
   End
   Begin VB.CheckBox chkAlternateColor 
      Caption         =   "Alternate Color"
      Height          =   345
      Left            =   5160
      TabIndex        =   9
      Top             =   4920
      Width           =   1575
   End
   Begin VB.CheckBox chkEditable 
      Caption         =   "Editable"
      Height          =   345
      Left            =   5160
      TabIndex        =   8
      Top             =   4470
      Width           =   1635
   End
   Begin VB.CheckBox chkAllowTo 
      Caption         =   "Allow to Edit Name Column"
      Height          =   375
      Left            =   3660
      TabIndex        =   7
      Top             =   3360
      Width           =   2895
   End
   Begin VB.CheckBox chkOnEnter 
      Caption         =   "On Enter Key Move Down"
      Height          =   405
      Left            =   420
      TabIndex        =   6
      Top             =   3360
      Width           =   2925
   End
   Begin VB.CommandButton cmdChange2nd 
      Caption         =   "Change 2nd Row BackColor"
      Height          =   615
      Left            =   7830
      TabIndex        =   5
      Top             =   180
      Width           =   1665
   End
   Begin VB.CommandButton cmdChange3nd 
      Caption         =   "Change 3nd Row CellAlignment"
      Height          =   615
      Left            =   7830
      TabIndex        =   4
      Top             =   930
      Width           =   1665
   End
   Begin VB.CommandButton cmdAutosizeColumn 
      Caption         =   "Autosize Column 1 && 2"
      Height          =   705
      Left            =   7770
      TabIndex        =   3
      Top             =   1740
      Width           =   1725
   End
   Begin VB.CommandButton cmdSumOf 
      Caption         =   "Sum of Salary"
      Height          =   675
      Left            =   7830
      TabIndex        =   2
      Top             =   2640
      Width           =   1695
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "Add"
      Height          =   375
      Left            =   7800
      TabIndex        =   1
      Top             =   3990
      Width           =   1035
   End
   Begin VB.CommandButton cmdRemove 
      Caption         =   "Remove"
      Height          =   375
      Left            =   7800
      TabIndex        =   0
      Top             =   4530
      Width           =   1035
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub chkAlternateColor_Click()
   TSR_Grid.EnableAlternateColor = chkAlternateColor.Value
End Sub

Private Sub cmdAdd_Click()
   'TSR_Grid.Rows = TSR_Grid.Rows + 1
   FGAgregarRenglon TSR_Grid, 1, 2, 3, 4, 5
End Sub

Private Sub cmdRemove_Click()
  TSR_Grid.RemoveItem TSR_Grid.Row
  
  
End Sub

Private Sub Form_Load()
    
    Dim i As Integer
    Dim j As Integer
    Dim lStr As String
    Dim lQry As String
    
    TSR_Grid.TextMatrix(0, 1) = "Name"
    TSR_Grid.TextMatrix(0, 2) = "Salary"
    TSR_Grid.ColDisplayFormat(2) = "#0.00"
    
    'Implemented only for Numeric Entry
    TSR_Grid.ColInputMask(2) = "0000.00"
    TSR_Grid.TextMatrix(9, 0) = "Total"
    
    'TSR_Grid.RowHeight(1) = 300
         
    MSFlexGrid.Row = 1
   TSR_Grid.Row = 1
   
      Call DBConectar_SQLServer("teseracto.dyndns.biz\SQL2005", "MixModeProd", "sa", "Te$eract0")
     lQry = "EXEC  uspDetManifiestos"
       
       
     Call FGLlenar(TSR_Grid, lQry)
 
     Call FGLlenar(MSFlexGrid, lQry)
 
'       MSFlexGrid.Redraw = False
'   'Construye el renglón para la primera columna
'       For j = 1 To 2000
'
'         lStr = "(" & CStr(j) & "," & CStr(0) & ")"
'         For i = 1 To MSFlexGrid.Cols - 1
'            ' continua para las columnas siguientes
'            lStr = lStr & vbTab & "(" & CStr(j) & "," & CStr(i) & ")"
'         Next i
'         'Añade un nuevo renglón
'         MSFlexGrid.AddItem lStr
'
'
'       Next j
'       MSFlexGrid.Redraw = True
'       TSR_Grid.Redraw = False
'       For j = 1 To 2000
'
'         FGAgregarRenglon TSR_Grid, 1, 2, 3, 4, 5
'
'       Next j
'       TSR_Grid.Redraw = True
       
   
End Sub


Private Sub chkAltColor_Click()
   If chkAltColor.Value = vbChecked Then
      TSR_Grid.BackColorAlternate = &H80000016
   Else
      TSR_Grid.BackColorAlternate = vbWhite
   End If
End Sub


Private Sub chkEditable_Click()
   If chkEditable.Value = vbChecked Then
      TSR_Grid.Editable = True
   Else
      TSR_Grid.Editable = False
   End If
End Sub


Private Sub chkMove_Click()
    If chkMove.Value = vbChecked Then
       TSR_Grid.EnterKeyBehaviour = klexEKMoveDown
    Else
       TSR_Grid.EnterKeyBehaviour = klexEKMoveRight
    End If
End Sub



Private Sub cmdSum_Click()
    TSR_Grid.TextMatrix(9, 2) = TSR_Grid.Aggregate(klexSTSum, 1, 2, 8, 2)
End Sub


Private Sub Command1_Click()
     TSR_Grid.Cell(klexcpCellBackColor, 2, 1, 2, TSR_Grid.Cols - 1) = vbBlue
End Sub

Private Sub Command2_Click()
     TSR_Grid.Cell(klexcpCellAlignment, 3, 1, 3, TSR_Grid.Cols - 1) = 3
End Sub

Private Sub cmdAutosize_Click()
    TSR_Grid.AutoSizeMode = klexAutoSizeColWidth
    TSR_Grid.AutoSize 1, 2
End Sub

Private Sub TSR_Grid_BeforeEdit(pCancel As Boolean, pTypeEdit As TSRGrid.GridEditionType)

 If TSR_Grid.Col = 1 Then
      If chkAllowTo.Value = vbUnchecked Then
         pCancel = True
         pTypeEdit = TEXTEDIT
      End If
   End If

   If TSR_Grid.Col = 3 Then
      pCancel = False
      pTypeEdit = COMBOEDIT
   End If


End Sub

