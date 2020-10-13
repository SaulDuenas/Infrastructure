VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "mshflxgd.ocx"
Begin VB.UserControl TSR_Grid 
   ClientHeight    =   4395
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   6345
   PropertyPages   =   "TSR_Grid.ctx":0000
   ScaleHeight     =   4395
   ScaleWidth      =   6345
   ToolboxBitmap   =   "TSR_Grid.ctx":0054
   Begin MSComCtl2.DTPicker dtpFecha 
      Height          =   315
      Left            =   3540
      TabIndex        =   3
      Top             =   3360
      Visible         =   0   'False
      Width           =   1695
      _ExtentX        =   2990
      _ExtentY        =   556
      _Version        =   393216
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Format          =   16842753
      CurrentDate     =   39001
   End
   Begin VB.ListBox LtsEdit 
      Appearance      =   0  'Flat
      Height          =   810
      ItemData        =   "TSR_Grid.ctx":0366
      Left            =   1500
      List            =   "TSR_Grid.ctx":037C
      TabIndex        =   2
      Top             =   3300
      Visible         =   0   'False
      Width           =   1935
   End
   Begin VB.ComboBox cmbEdit 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000001&
      Height          =   315
      Left            =   120
      TabIndex        =   1
      Text            =   "Combo1"
      Top             =   3300
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.TextBox txtEdit 
      Appearance      =   0  'Flat
      Height          =   285
      Left            =   120
      TabIndex        =   0
      Top             =   3840
      Visible         =   0   'False
      Width           =   980
   End
   Begin MSComCtl2.DTPicker dtpHora 
      Height          =   375
      Left            =   3540
      TabIndex        =   4
      Top             =   3780
      Visible         =   0   'False
      Width           =   1695
      _ExtentX        =   2990
      _ExtentY        =   661
      _Version        =   393216
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Format          =   16842754
      CurrentDate     =   38994
   End
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid fg 
      Height          =   3075
      Left            =   60
      TabIndex        =   5
      Top             =   60
      Width           =   6075
      _ExtentX        =   10716
      _ExtentY        =   5424
      _Version        =   393216
      BackColor       =   -2147483634
      Rows            =   10
      Cols            =   5
      FixedCols       =   0
      BackColorBkg    =   -2147483631
      _NumberOfBands  =   1
      _Band(0).Cols   =   5
   End
   Begin VB.Image ImgUnCheck 
      Height          =   195
      Left            =   5520
      Picture         =   "TSR_Grid.ctx":0392
      Top             =   3600
      Width           =   195
   End
   Begin VB.Image ImgCheck 
      Height          =   195
      Left            =   5520
      Picture         =   "TSR_Grid.ctx":0617
      Top             =   3900
      Width           =   195
   End
End
Attribute VB_Name = "TSR_Grid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "PropPageWizardRun" ,"Yes"
Option Explicit

Enum ROWS_MOD
   ADD_ROWS
   OMIT_ROWS
   MANUAL
End Enum

Enum PRESENTATION_STYLE
  RESTORE_COLOR
  ALTERNATIVE_COLOR
  RELOAD_ALTERNATIVE_COLOR
End Enum


'Implements ISubclass
Private Const SM_CXVSCROLL = 2
Private Const ONE_ROW = 1
Private Const TWO_ROW = 2

Dim bPrivateCellChange As Boolean
Dim mTextedit As Boolean
Dim mComboEdit As Boolean
Dim mListEdit As Boolean
Dim mDtpFecha As Boolean
Dim mDtpHora As Boolean

Dim mExtRows As Long
Dim mRowHeight As Long


Private Declare Function GetSystemMetrics Lib "user32" (ByVal nIndex As Long) As Long

'Extra Events
Public Event BeforeEdit(pCancel As Boolean, pTypeEdit As GridEditionType)
Public Event AfterEdit(ByVal Row As Long, ByVal Col As Long, ByVal pNewText As String)
Public Event KeyPressEdit(ByVal Row As Long, ByVal Col As Long, KeyAscii As Integer)
Public Event KeyDownEdit(ByVal Row As Long, ByVal Col As Long, KeyCode As Integer, ByVal Shift As Integer)
Public Event ValidateEdit(pRow As Long, pCol As Long, pOldText As String, pNewText As String, pCancel As Boolean)

'Mapped Events
Public Event Click()
Public Event Compare(ByVal Row1 As Long, ByVal Row2 As Long, Cmp As Integer)
Public Event DblClick()
Public Event EnterCell()
Public Event GridGotFocus()
Public Event LeaveCell()
Public Event RowColChange()
Public Event Scroll()
Public Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event SelChange()
Public Event KeyPress(KeyAscii As Integer)
Public Event KeyDown(KeyCode As Integer, Shift As Integer)
Public Event KeyUp(KeyCode As Integer, Shift As Integer)
Public Event OLEStartDrag(Data As MSHierarchicalFlexGridLib.DataObject, AllowedEffects As Long)
Public Event OLESetData(Data As MSHierarchicalFlexGridLib.DataObject, DataFormat As Integer)
Public Event OLEGiveFeedback(Effect As Long, DefaultCursors As Boolean)
Public Event OLEDragOver(Data As MSHierarchicalFlexGridLib.DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer)
Public Event OLEDragDrop(Data As MSHierarchicalFlexGridLib.DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event OLECompleteDrag(Effect As Long)

Public Type FgCol
    ColDisplayFormat As String
    ColInputMask As String
End Type

Public Enum enuCellProperty
    tsrcpCellAlignment
    tsrcpCellFontName
    tsrcpCellFontSize
    tsrcpCellFontBold
    tsrcpCellForeColor
    tsrcpCellBackColor
End Enum

Public Enum enuAutoSizeSetting
    tsrAutoSizeColWidth
    tsrAutoSizeRowHeight
End Enum

Public Enum enuSubTotalSettings
    tsrSTAverage
    tsrSTCount
    tsrSTMax
    tsrSTMin
    tsrSTSum
End Enum

Public Enum enuEnterkeyBehaviour
    tsrEKMoveDown
    tsrEKMoveRight
    tsrEKNone
End Enum


Public Enum GridEditionType
    TEXTEDIT
    COMBOEDIT
    LISTEDIT
    DATEEDIT
End Enum

Public Enum TextEditMode
   
   FREE
   DECIMALS
   NUMBERS
   ABS_DECIMALS
   ABS_NUMBERS

End Enum

Private m_Cols() As FgCol

Dim m_EnterKeyBehaviour As enuEnterkeyBehaviour
Dim m_Editable As Boolean
Dim m_AutoSizeMode As enuAutoSizeSetting
Dim m_BackColorAlternate As OLE_COLOR
Dim EditionType As GridEditionType

Dim mUseCheckBok As Boolean
Dim mEnableAlternateColor As Boolean


Private Sub IsCellVisible()
    Dim a As Boolean
    a = fg.CellTop
End Sub


Private Sub MoveCellOnEnter()
    If Not m_EnterKeyBehaviour = tsrEKNone Then
        If m_EnterKeyBehaviour = tsrEKMoveRight Then
            If fg.Col < fg.Cols - 1 Then
               fg.Col = fg.Col + 1
            Else
               If fg.Row < fg.Rows - 1 Then
                  Dim nRow As Long
                  Dim nCol As Long
                  nCol = fg.Col
                  nRow = fg.Row
                  nRow = fg.Row + 1
                  Dim i As Long
                  For i = fg.FixedCols To fg.Cols - 1
                      If fg.ColWidth(i) > 0 Then
                         nCol = i
                         Exit For
                      End If
                  Next
                  bPrivateCellChange = True
                  fg.Row = nRow
                  bPrivateCellChange = False
                  If fg.Col <> nCol Then
                     fg.Col = nCol
                  End If
               End If
            End If
            
        ElseIf m_EnterKeyBehaviour = tsrEKMoveDown Then
            If fg.Row < fg.Rows - 1 Then fg.Row = fg.Row + 1
        End If
        Call IsCellVisible
    End If
End Sub


Public Sub RemoveItem(pIndex As Long)
   
   If mEnableAlternateColor = True And Ambient.UserMode Then
      ' El Tenemos registros despues de que sera eliminado ?
      If pIndex < (fg.Rows - 1) Then
         SetAlternateRowColors RESTORE_COLOR, pIndex
      End If
   End If
   
   RowsModify OMIT_ROWS, , pIndex
   
   ' repintamos
   If mEnableAlternateColor = True And Ambient.UserMode Then
     ' El Tenemos registros despues del eliminado ?
     If pIndex < (fg.Rows - 1) Then
        SetAlternateRowColors ALTERNATIVE_COLOR, pIndex
     End If
   End If
   
End Sub

Public Sub AddItem(pItem As String, Optional pIndex As Long = 0)

   RowsModify ADD_ROWS, pItem, pIndex
   
   If m_BackColorAlternate <> fg.BackColor And mEnableAlternateColor = True Then
      fg.Redraw = False
      ' Solo pares
      If ((fg.Rows - 1) Mod 2) = 0 Then SetRowColor m_BackColorAlternate, fg.Rows - 1
      fg.Redraw = True
   End If
   
End Sub


Private Function AutosizeCols(myGrid As TSR_Grid, _
                              Optional ByVal lFirstCol As Long = -1, _
                              Optional ByVal lLastCol As Long = -1, _
                              Optional bCheckFont As Boolean = False)
  
  Dim lCol As Long, lRow As Long, lCurCol As Long, lCurRow As Long
  Dim lCellWidth As Long, lColWidth As Long
  Dim bFontBold As Boolean
  Dim dFontSize As Double
  Dim sFontName As String
    
  bPrivateCellChange = True
  If bCheckFont Then
    ' save the forms font settings
    bFontBold = Me.FontBold
    sFontName = Me.FontName
    dFontSize = Me.FontSize
  End If
  
  With myGrid
    If bCheckFont Then
      lCurRow = .Row
      lCurCol = .Col
    End If
    
    If lFirstCol = -1 Then lFirstCol = 0
    If lLastCol = -1 Then lLastCol = .Cols - 1
    
    For lCol = lFirstCol To lLastCol
      lColWidth = 0
      If bCheckFont Then .Col = lCol
      For lRow = 0 To .Rows - 1
        If bCheckFont Then
          .Row = lRow
          UserControl.FontBold = .CellFontBold
          UserControl.FontName = .CellFontName
          UserControl.FontSize = .CellFontSize
        End If
        lCellWidth = UserControl.TextWidth(.TextMatrix(lRow, lCol))
        If lCellWidth > lColWidth Then lColWidth = lCellWidth
      Next lRow
      .ColWidth(lCol) = lColWidth + UserControl.TextWidth("W")
    Next lCol
    
    If bCheckFont Then
      .Row = lCurRow
      .Col = lCurCol
    End If
  End With
  
  If bCheckFont Then
    ' restore the forms font settings
    UserControl.FontBold = bFontBold
    UserControl.FontName = sFontName
    UserControl.FontSize = dFontSize
  End If
  bPrivateCellChange = False
End Function

'---------------------------------------------------------------------------------------
' Procedure : SetAlternateRowColors
' Author    : TSR-SDB
' Date      : 4/29/2012
' Purpose   : Cambia los colores de los registros alternando entre dos tipos de color
'---------------------------------------------------------------------------------------
Private Sub SetAlternateRowColors(Optional pStyle As PRESENTATION_STYLE = ALTERNATIVE_COLOR, Optional pRow As Long = 1)
    
    Dim lRow As Long
    Dim lCol As Long
    Dim lRowA As Long
    Dim lOrgRow As Long, lOrgCol As Long
    Dim lStep As Integer
    bPrivateCellChange = True

    If m_BackColorAlternate <> fg.BackColor Or pStyle = RESTORE_COLOR Then
         
      If pStyle = RESTORE_COLOR Then
      lStep = 1
      lRowA = pRow
      ElseIf pStyle = ALTERNATIVE_COLOR Then
      lStep = 2
      lRowA = IIf((pRow Mod 2) = 0, pRow, pRow + 1)
      End If
      
      With fg
      .Redraw = False
      ' save the current cell position
      lOrgRow = .Row
      lOrgCol = .Col
      ' only the data rows
      For lRow = lRowA To (.Rows - 1) Step lStep
         .Row = lRow
         .Col = .FixedCols
         'Restablece el color de las filas
         If pStyle = RESTORE_COLOR Then
            If fg.BackColor <> .CellBackColor Then
               ' only the data columns
               For lCol = .FixedCols To .Cols - 1
                   .Col = lCol
                   .CellBackColor = fg.BackColor
               Next lCol
            End If
         End If
         'Color Registros pares
         If (lRow Mod 2) = 0 And pStyle = ALTERNATIVE_COLOR Then
            If fg.BackColor = .CellBackColor Then
               ' only the data columns
               For lCol = .FixedCols To .Cols - 1
                   .Col = lCol
                   .CellBackColor = m_BackColorAlternate
               Next lCol
            End If
         End If
       Next lRow
      ' restore the orginal cell position
      
      .Redraw = True
      .Row = lOrgRow
      .Col = lOrgCol
      '.SetFocus
      
      End With
    
    End If
    
    bPrivateCellChange = False
    
End Sub

'---------------------------------------------------------------------------------------
' Procedure : SetRowColor
' Author    : TSR-SDB
' Date      : 4/29/2012
' Purpose   : Establece un color en el registro especificado en el Grid
'---------------------------------------------------------------------------------------
Private Sub SetRowColor(pColor As Long, pRow As Long)
    
    Dim lOrgRow As Long, lOrgCol As Long
    Dim lCol As Long
    bPrivateCellChange = True

    With fg
        
        '.Redraw = False
        .Row = pRow
         ' only the data columns
         For lCol = .FixedCols To .Cols - 1
             .Col = lCol
             .CellBackColor = pColor
         Next lCol
         .Col = .FixedCols
        '.Redraw = True
    End With
    bPrivateCellChange = False
End Sub


'---------------------------------------------------------------------------------------
' Procedure : FGColor
' Author    : TSR-SDB
' Date      : 4/29/2012
' Purpose   : Devuelve el color establecido en la celda especificada
'---------------------------------------------------------------------------------------
Private Function FGColor(pRow As Long, pCol As Long) As Long

    Dim lOrgRow As Long, lOrgCol As Long
    Dim lCol As Long
    bPrivateCellChange = True

    fg.Row = pRow
    fg.Col = pCol
    ' restore the orginal cell position
    FGColor = fg.CellBackColor
    
End Function



Private Sub fg_KeyPress(KeyAscii As Integer)
    Dim sInputMask As String
    sInputMask = m_Cols(fg.Col).ColInputMask
    
    If LenB(sInputMask) > 0 Then
       If Not KeyAscii = 13 Then
           txtEdit.Text = ""
           NumKeyPress KeyAscii, txtEdit, sInputMask
           If KeyAscii = 0 Then
              Exit Sub
           End If
       End If
    End If
    
    '
    RaiseEvent KeyPress(KeyAscii)
    
    If KeyAscii = 0 Then Exit Sub
    RaiseEvent KeyPressEdit(fg.Row, fg.Col, KeyAscii)
    
    If KeyAscii = vbKeyTab Then Exit Sub
    
    ' Presionaron Enter ?
    If KeyAscii = 13 Then
        Call MoveCellOnEnter
        KeyAscii = 0
    End If
    
    If KeyAscii > 0 Then
        Call StartKeyEdit(KeyAscii)
    End If

End Sub

Private Sub fg_Click()
    RaiseEvent Click
End Sub

Private Sub ImgCheck_Click()

End Sub

Private Sub txtEdit_LostFocus()
  Call EndKeyEdit
End Sub

Private Sub UserControl_Initialize()
    ReDim m_Cols(fg.Cols)
   '   AttachMessage Me, fg.hwnd, WM_MOUSEMOVE
    mRowHeight = 240
End Sub


Private Sub UserControl_Terminate()
'    DetachMessage Me, fg.hwnd, WM_MOUSEMOVE
End Sub

Private Sub UserControl_Resize()
    With fg
        .Left = 0
        .Top = 0
        .Height = UserControl.Height
        .Width = UserControl.Width
    End With
End Sub

'---------------------------------------------------------------------------------------
' Procedure : StartDateEdit
' Author    : TSR-SDB
' Date      : 4/29/2012
' Purpose   : Inicializa la edicion del grid por DateTimePicker de la celda seleccionada
'---------------------------------------------------------------------------------------
Private Sub StartDateEdit()
    
   Dim Cancel As Boolean
   Dim TypeEdit As GridEditionType
   
   If Not m_Editable Then Exit Sub
   
   ' [1] Posisiona el control
   With fg
      If .CellWidth < 0 Then Exit Sub
      
      dtpFecha.Move (.Left + .CellLeft), _
                    (.Top + 30 + (.RowHeight(0) * (.Row - .TopRow + 1))), _
                    (.CellWidth), _
                    (.CellHeight + 30)
      
      ' -- Asignar la fecha ( El texto de la celda en el DTPicker)
      If Trim(.Text) <> vbNullString Then
          dtpFecha.Value = Format(.Text, "Short Date")   ' -- formato de fecha Corto
      Else
          dtpFecha.Value = Format(Date, "Short Date")
      End If
   
   End With
   
   ' [2] Establece la confirmación de la edición
   RaiseEvent BeforeEdit(Cancel, TypeEdit)
   
   If (Not Cancel) And TypeEdit = GridEditionType.DATEEDIT Then
      dtpFecha.Tag = fg.Row & "|" & fg.Col
      dtpFecha.Visible = True
      dtpFecha.SetFocus
   End If

End Sub


Private Sub EndDateEdit()
       
   
End Sub


'---------------------------------------------------------------------------------------
' Procedure : StartComboEdit
' Author    : TSR-SDB
' Date      : 4/29/2012
' Purpose   : Inicializa la edicion del grid por ComboBox de la celda seleccionada
'---------------------------------------------------------------------------------------
Private Sub StartComboEdit()
    
   Dim Cancel As Boolean
   Dim TypeEdit As GridEditionType
  
   ' [1] Establece el Control
   With fg
      If .CellWidth < 0 Then Exit Sub
      cmbEdit.Width = .CellWidth + 30
      cmbEdit.Left = .CellLeft + .Left - 30
      cmbEdit.Top = .CellTop + .Top - 30
      cmbEdit.Text = .Text
   End With
   
    ' [2] Establece la confirmación de la edición
   RaiseEvent BeforeEdit(Cancel, TypeEdit)
   
   If (Not Cancel) And TypeEdit = COMBOEDIT Then
      cmbEdit.Tag = fg.Row & "|" & fg.Col
      cmbEdit.Visible = True
      cmbEdit.SetFocus
   End If

End Sub


'---------------------------------------------------------------------------------------
' Procedure : EndComboEdit
' Author    : TSR-SDB
' Date      : 4/29/2012
' Purpose   : Finaliza la edicion del grid por ComboBox de la celda seleccionada
'---------------------------------------------------------------------------------------
Private Sub EndComboEdit()
       
    If cmbEdit.Visible = True Then
        ' le asigna el texto a la celda del FlexGrid con el valor del combo1
        fg.Text = cmbEdit.Text
        cmbEdit.Visible = False
    End If
  
End Sub

'---------------------------------------------------------------------------------------
' Procedure : StartKeyEdit
' Author    : TSR-SDB
' Date      : 4/29/2012
' Purpose   : Inicializa la edicion del grid por texbox de la celda seleccionada
'---------------------------------------------------------------------------------------
Private Sub StartKeyEdit(KeyAscii As Integer, Optional bShowOldText As Boolean)
   
   ' [1] Posiciona el Control
   With fg
       If .CellWidth < 0 Then Exit Sub
       txtEdit.Move .Left + .CellLeft - 30, .Top + .CellTop - 30, .CellWidth + 30, .CellHeight + 30
   End With
   
   If bShowOldText Then
      txtEdit.Text = fg.Text
      txtEdit.SelStart = 0
      txtEdit.SelLength = Len(txtEdit.Text)
   Else
      'txtEdit_KeyPress KeyAscii
      'If KeyAscii <> 0 Then
      txtEdit.Text = Chr(KeyAscii)
      'End If
      txtEdit.SelStart = 1
   End If
   
   txtEdit.Tag = fg.Row & "|" & fg.Col
   txtEdit.Visible = True
   txtEdit.SetFocus
   
End Sub

'---------------------------------------------------------------------------------------
' Procedure : EndKeyEdit
' Author    : TSR-SDB
' Date      : 4/29/2012
' Purpose   : Finaliza la edicion del grid por texbox de la celda seleccionada
'---------------------------------------------------------------------------------------
Private Function EndKeyEdit() As Boolean
    Dim nRow As Long
    Dim nCol As Long
    Dim sData
    Dim mOldText As String
    Dim lCancel As Boolean
    
    lCancel = False
    mOldText = fg.TextMatrix(nRow, nCol)
    ' Lanzamos evento de confirmación de edición
    RaiseEvent ValidateEdit(nRow, nCol, mOldText, txtEdit.Text, lCancel)
        
    ' cancelaron la edición de la celda ?
    If (Not lCancel) And txtEdit.Visible = True Then

      RaiseEvent AfterEdit(nRow, nCol, txtEdit.Text)
      txtEdit.Visible = False
      fg.SetFocus
    
    Else
      fg.TextMatrix(nRow, nCol) = mOldText
      fg.SetFocus
    End If
    
    EndKeyEdit = lCancel
    
End Function


Private Sub AbortEdit()
    txtEdit.Visible = False
    fg.SetFocus
End Sub


Private Sub txtEdit_KeyPress(KeyAscii As Integer)
    
    Dim Cancel As Boolean
    
    RaiseEvent KeyPressEdit(fg.Row, fg.Col, KeyAscii)
    
    ' Teclearon Enter ?
    If KeyAscii = 13 Then
        ' Terminamos la edición de la celda
        Cancel = EndKeyEdit
        ' Confirmaron la Edición de la Celda ?
        If Not Cancel Then
           ' Establecemos el foco a la siguiente celda
           Call MoveCellOnEnter
        End If
    
    End If
    
    'Teclearon ESC ?
    If KeyAscii = 27 Then
        ' Cancelamos la edición de la celda
        AbortEdit
    End If
End Sub


Private Sub txtEdit_KeyDown(KeyCode As Integer, Shift As Integer)
    Dim sInputMask As String
    sInputMask = m_Cols(fg.Col).ColInputMask
    If LenB(sInputMask) > 0 Then
       NumKeyDown KeyCode, txtEdit, sInputMask
    End If
    RaiseEvent KeyDownEdit(fg.Row, fg.Col, KeyCode, Shift)
    Dim Cancel As Boolean
    If KeyCode = vbKeyDown Then
        
        Cancel = EndKeyEdit
        If Not Cancel Then
           If fg.Row < fg.Rows - 1 Then fg.Row = fg.Row + 1
        End If
    End If
    If KeyCode = vbKeyUp Then
        Cancel = EndKeyEdit
        If Not Cancel Then
            If fg.Row > fg.FixedRows Then fg.Row = fg.Row - 1
        End If
    End If
End Sub


Private Sub cmbEdit_Click()
    fg.SetFocus
End Sub


Private Sub dtpFecha_Change()
    With fg
      .TextMatrix(.Row, .Col) = dtpFecha.Value
    End With
End Sub

' ----------------------------------------------------------------------------
' \\ -- Ocultar  DTPicker cuando pierde el foco
' ----------------------------------------------------------------------------
Private Sub dtpFecha_LostFocus()
   '
End Sub

Private Sub DisplayFormatedText(s As String, Row As Long, Col As Long)
   If Row < mExtRows Then fg.TextMatrix(Row, Col) = Format(s, m_Cols(Col).ColDisplayFormat)
End Sub


'*********************************
'Load property values from storage
'*********************************
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    ' New Properties
    m_EnterKeyBehaviour = PropBag.ReadProperty("EnterKeyBehaviour", tsrEKMoveRight)
    m_Editable = PropBag.ReadProperty("Editable", False)
    m_AutoSizeMode = PropBag.ReadProperty("AutoSizeMode", tsrAutoSizeColWidth)
    m_BackColorAlternate = PropBag.ReadProperty("BackColorAlternate", &H80000005)
    mEnableAlternateColor = PropBag.ReadProperty("EnableAlternateColor", False)
    mUseCheckBok = PropBag.ReadProperty("UseCheckBok", False)
    ' Mapped Properties
    fg.GridLinesFixed = PropBag.ReadProperty("GridLinesFixed", flexGridInset)
    fg.GridLines = PropBag.ReadProperty("GridLines", flexGridFlat)
    fg.AllowBigSelection = PropBag.ReadProperty("AllowBigSelection", True)
    fg.AllowUserResizing = PropBag.ReadProperty("AllowUserResizing", 0)
    fg.Appearance = PropBag.ReadProperty("Appearance", 1)
    fg.BackColor = PropBag.ReadProperty("BackColor", &H80000005)
    'Set Edit's backcolor similar to grid's backcolor
    txtEdit.BackColor = fg.BackColor
    fg.BackColorBkg = PropBag.ReadProperty("BackColorBkg", &H808080)
    fg.BackColorFixed = PropBag.ReadProperty("BackColorFixed", &H8000000F)
    fg.BackColorSel = PropBag.ReadProperty("BackColorSel", &H8000000D)
    fg.BorderStyle = PropBag.ReadProperty("BorderStyle", 1)
    'fg.Cols = PropBag.ReadProperty("Cols", 2)
    Cols = PropBag.ReadProperty("Cols", 2)
    fg.Enabled = PropBag.ReadProperty("Enabled", True)
    fg.FillStyle = PropBag.ReadProperty("FillStyle", 0)
    fg.FixedCols = PropBag.ReadProperty("FixedCols", 1)
    fg.FixedRows = PropBag.ReadProperty("FixedRows", 1)
    fg.FocusRect = PropBag.ReadProperty("FocusRect", 1)
    Set fg.Font = PropBag.ReadProperty("Font", Ambient.Font)
    fg.ForeColor = PropBag.ReadProperty("ForeColor", &H80000008)
    fg.ForeColorFixed = PropBag.ReadProperty("ForeColorFixed", &H80000012)
    fg.ForeColorSel = PropBag.ReadProperty("ForeColorSel", &H8000000E)
    fg.FormatString = PropBag.ReadProperty("FormatString", "")
    fg.GridColor = PropBag.ReadProperty("GridColor", &HC0C0C0)
    fg.GridColorFixed = PropBag.ReadProperty("GridColorFixed", &H0&)
    fg.GridLineWidth = PropBag.ReadProperty("GridLineWidth", 1)
    fg.HighLight = PropBag.ReadProperty("HighLight", 1)
    fg.MergeCells = PropBag.ReadProperty("MergeCells", 0)
    Set MouseIcon = PropBag.ReadProperty("MouseIcon", Nothing)
    fg.MousePointer = PropBag.ReadProperty("MousePointer", 0)
    fg.OLEDropMode = PropBag.ReadProperty("OLEDropMode", 0)
    fg.PictureType = PropBag.ReadProperty("PictureType", 0)
    fg.Redraw = PropBag.ReadProperty("Redraw", True)
    fg.RightToLeft = PropBag.ReadProperty("RightToLeft", False)
    fg.RowHeightMin = PropBag.ReadProperty("RowHeightMin", 0)
    mExtRows = PropBag.ReadProperty("Rows", 2)
    RowsModify MANUAL, , , mExtRows
    fg.ScrollBars = PropBag.ReadProperty("ScrollBars", 3)
    fg.ScrollTrack = PropBag.ReadProperty("ScrollTrack", False)
    fg.SelectionMode = PropBag.ReadProperty("SelectionMode", 0)
    fg.Sort = PropBag.ReadProperty("Sort", 0)
    fg.TextStyle = PropBag.ReadProperty("TextStyle", 0)
    fg.TextStyleFixed = PropBag.ReadProperty("TextStyleFixed", 0)
    fg.WordWrap = PropBag.ReadProperty("WordWrap", False)
    
    Set txtEdit.Font = fg.Font
    Set cmbEdit.Font = fg.Font
    Set LtsEdit.Font = fg.Font
    Set dtpFecha.Font = fg.Font
    Set dtpHora.Font = fg.Font
    
    If mEnableAlternateColor = True And Ambient.UserMode Then
       Call SetAlternateRowColors(ALTERNATIVE_COLOR)
    End If


End Sub

'********************************
'Write property values to storage
'********************************
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    ' New Properties
    Call PropBag.WriteProperty("EnterKeyBehaviour", m_EnterKeyBehaviour, tsrEKMoveRight)
    Call PropBag.WriteProperty("Editable", m_Editable, False)
    Call PropBag.WriteProperty("EnableAlternateColor", mEnableAlternateColor, False)
    Call PropBag.WriteProperty("UseCheckBok", mUseCheckBok, False)
    Call PropBag.WriteProperty("AutoSizeMode", m_AutoSizeMode, tsrAutoSizeColWidth)
    Call PropBag.WriteProperty("BackColorAlternate", m_BackColorAlternate, &H80000005)
    
    ' Mapped Properties
    Call PropBag.WriteProperty("GridLines", fg.GridLines, 1)
    Call PropBag.WriteProperty("GridLinesFixed", fg.GridLinesFixed, 1)
    Call PropBag.WriteProperty("AllowBigSelection", fg.AllowBigSelection, True)
    Call PropBag.WriteProperty("AllowUserResizing", fg.AllowUserResizing, 0)
    Call PropBag.WriteProperty("Appearance", fg.Appearance, 1)
    Call PropBag.WriteProperty("BackColor", fg.BackColor, &H80000005)
    Call PropBag.WriteProperty("BackColorBkg", fg.BackColorBkg, &H808080)
    Call PropBag.WriteProperty("BackColorFixed", fg.BackColorFixed, &H8000000F)
    Call PropBag.WriteProperty("BackColorSel", fg.BackColorSel, &H8000000D)
    Call PropBag.WriteProperty("BorderStyle", fg.BorderStyle, 1)
    Call PropBag.WriteProperty("Cols", fg.Cols, 2)
    Call PropBag.WriteProperty("Enabled", fg.Enabled, True)
    Call PropBag.WriteProperty("FillStyle", fg.FillStyle, 0)
    Call PropBag.WriteProperty("FixedCols", fg.FixedCols, 1)
    Call PropBag.WriteProperty("FixedRows", fg.FixedRows, 1)
    Call PropBag.WriteProperty("FocusRect", fg.FocusRect, 1)
    Call PropBag.WriteProperty("Font", fg.Font, Ambient.Font)
    Call PropBag.WriteProperty("ForeColor", fg.ForeColor, &H80000008)
    Call PropBag.WriteProperty("ForeColorFixed", fg.ForeColorFixed, &H80000012)
    Call PropBag.WriteProperty("ForeColorSel", fg.ForeColorSel, &H8000000E)
    Call PropBag.WriteProperty("FormatString", fg.FormatString, "")
    Call PropBag.WriteProperty("GridColor", fg.GridColor, &HC0C0C0)
    Call PropBag.WriteProperty("GridColorFixed", fg.GridColorFixed, &H0&)
    Call PropBag.WriteProperty("GridLineWidth", fg.GridLineWidth, 1)
    Call PropBag.WriteProperty("HighLight", fg.HighLight, 1)
    Call PropBag.WriteProperty("MergeCells", fg.MergeCells, 0)
    Call PropBag.WriteProperty("MouseIcon", MouseIcon, Nothing)
    Call PropBag.WriteProperty("MousePointer", fg.MousePointer, 0)
    Call PropBag.WriteProperty("OLEDropMode", fg.OLEDropMode, 0)
    Call PropBag.WriteProperty("PictureType", fg.PictureType, 0)
    Call PropBag.WriteProperty("Redraw", fg.Redraw, True)
    Call PropBag.WriteProperty("RightToLeft", fg.RightToLeft, False)
    Call PropBag.WriteProperty("RowHeightMin", fg.RowHeightMin, 0)
    Call PropBag.WriteProperty("Rows", mExtRows, 2)
    Call PropBag.WriteProperty("ScrollBars", fg.ScrollBars, 3)
    Call PropBag.WriteProperty("ScrollTrack", fg.ScrollTrack, False)
    Call PropBag.WriteProperty("SelectionMode", fg.SelectionMode, 0)
    Call PropBag.WriteProperty("TextStyle", fg.TextStyle, 0)
    Call PropBag.WriteProperty("TextStyleFixed", fg.TextStyleFixed, 0)
    Call PropBag.WriteProperty("WordWrap", fg.WordWrap, False)
End Sub

'************
'New Methods
'************
Public Sub AboutBox()
Attribute AboutBox.VB_UserMemId = -552
Attribute AboutBox.VB_MemberFlags = "40"
   Load AboutDialog
   AboutDialog.Show (vbModal)
End Sub

Public Sub AutoSize(Col1 As Long, Optional Col2 As Long)
    Select Case m_AutoSizeMode
           Case Is = tsrAutoSizeColWidth
                Dim i As Long, j As Long
                Dim nMaxWidth As Long
                Dim nCurrWidth As Long
                If IsMissing(Col2) Then Col2 = Col1
                Call AutosizeCols(fg, Col1, Col2, True)
           Case Is = tsrAutoSizeRowHeight
               'Pending to do
    End Select
End Sub


Public Sub ExtendLastColumn(Optional Col As Long)
    Dim m_lScrollWidth As Long
    m_lScrollWidth = GetSystemMetrics(SM_CXVSCROLL) * Screen.TwipsPerPixelY
    
    Dim lCol As Long
    Dim lTotWidth As Long
    Dim lScrollWidth As Long
    Dim nMargin As Long
    nMargin = 95
    With fg
        ' is there a vertical scrollbar
        lScrollWidth = 0
        If .ScrollBars = flexScrollBarBoth Or .ScrollBars = flexScrollBarBoth Then
            If Not .RowIsVisible(0) Or Not .RowIsVisible(.Rows - 1) Then
                lScrollWidth = m_lScrollWidth
            End If
        End If
    
        Dim nWidth As Long
        nWidth = fg.Width - lScrollWidth
        Dim nColWidths As Long
        Dim i As Long
        For i = 0 To fg.Cols - 1
            nColWidths = nColWidths + fg.ColWidth(i) + fg.GridLineWidth
        Next
        If fg.Appearance = flex3D Then
            nMargin = 95
        Else
            nMargin = 35
        End If
        
        Dim nProcessCol As Long
        If Not IsMissing(Col) Then
           nProcessCol = Col
        Else
           nProcessCol = fg.Cols - 1
        End If
        If nColWidths < nWidth - nMargin Then
            fg.ColWidth(nProcessCol) = fg.ColWidth(nProcessCol) + (nWidth - nColWidths - nMargin)
        End If
        If lScrollWidth = 0 Then
        End If
    End With
End Sub


'***************
' New Properties
'***************

Public Property Get EditSelStart() As Long
    EditSelStart = txtEdit.SelStart
End Property

Public Property Let EditSelStart(ByVal NewData As Long)
    txtEdit.SelStart = NewData
End Property

Public Property Get EditSelLength() As Long
    EditSelLength = txtEdit.SelLength
End Property

Public Property Let EditSelLength(ByVal NewData As Long)
    txtEdit.SelLength = NewData
End Property

Public Property Get EditSelText() As String
    EditSelText = txtEdit.SelText
End Property

Public Property Let EditSelText(ByVal NewData As String)
    txtEdit.SelText = NewData
End Property

Public Property Get EditText() As String
   EditText = txtEdit.Text
End Property

Public Property Let EditText(ByVal NewData As String)
   txtEdit.Text = NewData
End Property

Public Property Get ColDisplayFormat(ByVal Col As Long) As String
    ColDisplayFormat = m_Cols(Col).ColDisplayFormat
End Property

Public Property Let ColDisplayFormat(ByVal Col As Long, ByVal New_ColDisplayFormat As String)
    m_Cols(Col).ColDisplayFormat = New_ColDisplayFormat
End Property

Public Property Get ColInputMask(ByVal Col As Long) As String
    ColInputMask = m_Cols(Col).ColInputMask
End Property

Public Property Let ColInputMask(ByVal Col As Long, ByVal New_ColInputMask As String)
    m_Cols(Col).ColInputMask = New_ColInputMask
End Property

Public Property Get EnterKeyBehaviour() As enuEnterkeyBehaviour
    EnterKeyBehaviour = m_EnterKeyBehaviour
End Property

Public Property Let EnterKeyBehaviour(ByVal New_EnterKeyBehaviour As enuEnterkeyBehaviour)
    m_EnterKeyBehaviour = New_EnterKeyBehaviour
    PropertyChanged "EnterKeyBehaviour"
End Property

Public Property Get AutoSizeMode() As enuAutoSizeSetting
    AutoSizeMode = m_AutoSizeMode
End Property

Public Property Let AutoSizeMode(ByVal New_AutoSizeMode As enuAutoSizeSetting)
    m_AutoSizeMode = New_AutoSizeMode
    PropertyChanged "AutoSizeMode"
End Property

Public Property Get BackColorAlternate() As OLE_COLOR
    BackColorAlternate = m_BackColorAlternate
End Property

Public Property Let BackColorAlternate(ByVal New_BackColorAlternate As OLE_COLOR)
    m_BackColorAlternate = New_BackColorAlternate
    
    If Ambient.UserMode Then
      If mEnableAlternateColor = True Then
         Call SetAlternateRowColors(ALTERNATIVE)
      ElseIf m_BackColorAlternate = fg.BackColor Then
         Call SetAlternateRowColors(RESTORE_COLOR)
      End If
    End If
    PropertyChanged "BackColorAlternate"
End Property


Public Property Get Editable() As Boolean
Attribute Editable.VB_Description = "Returns/sets a value that determines whether data in grid can be edit"
Attribute Editable.VB_ProcData.VB_Invoke_Property = "Additional"
    Editable = m_Editable
End Property

Public Property Let Editable(ByVal New_Editable As Boolean)
    m_Editable = New_Editable
    PropertyChanged "Editable"
End Property

'*******************
' End New Properties
'*******************


'**************
' Mapped Events
'**************

Private Sub fg_GotFocus()
'
'Dim mTextedit As Boolean
'Dim mComboEdit As Boolean
'Dim mListEdit As Boolean
'Dim mDtpFecha As Boolean
'Dim mDtpHora As Boolean
'
   
'   If mTextedit Then Call EndKeyEdit
'   If mComboEdit Then Call EndComboEdit
'   'If mTextedit Then RaiseEvent GridGotFocus
    
End Sub

Private Sub fg_LeaveCell()
   If Not bPrivateCellChange Then
      RaiseEvent LeaveCell
   End If

   Call EndComboEdit

End Sub


Private Sub fg_DblClick()
    
   Dim Cancel As Boolean
   Dim TypeEdit As GridEditionType
    
   RaiseEvent DblClick
    
   ' [1] Esta habilitado el Modo de edición ?
   If m_Editable Then
     ' [2] Establece la Confirmación de la edición
     RaiseEvent BeforeEdit(Cancel, TypeEdit)
     ' [3] Activa el modo de edición por el tipo seleccionado s
     If (Not Cancel) And TypeEdit = GridEditionType.TEXTEDIT Then Call StartKeyEdit(0, True)
     If (Not Cancel) And TypeEdit = GridEditionType.COMBOEDIT Then Call StartComboEdit
   
   End If

End Sub

' ----------------------------------------------------------------------------
' \\ -- Al mover el Scroll del Grid ocultar los controles
' ----------------------------------------------------------------------------
Private Sub fg_Scroll()
   
   If txtEdit.Visible = True Then AbortEdit
   
   dtpFecha.Visible = False
   cmbEdit.Visible = False
   txtEdit.Visible = False
   LtsEdit.Visible = False
   dtpHora.Visible = False
 
   RaiseEvent Scroll

End Sub

Private Sub fg_Compare(ByVal Row1 As Long, ByVal Row2 As Long, Cmp As Integer)
    RaiseEvent Compare(Row1, Row2, Cmp)
End Sub

Private Sub fg_EnterCell()
    If Not bPrivateCellChange Then
       RaiseEvent EnterCell
    End If
End Sub


Private Sub fg_RowColChange()
   If Not bPrivateCellChange Then
       RaiseEvent RowColChange
   End If
End Sub


Private Sub fg_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
   RaiseEvent MouseDown(Button, Shift, X, Y)
End Sub

Private Sub fg_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
   RaiseEvent MouseMove(Button, Shift, X, Y)
End Sub

Private Sub fg_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
   RaiseEvent MouseUp(Button, Shift, X, Y)
End Sub

Private Sub fg_SelChange()
   If Not bPrivateCellChange Then
      RaiseEvent SelChange
   End If
End Sub

Private Sub fg_KeyUp(KeyCode As Integer, Shift As Integer)
   RaiseEvent KeyUp(KeyCode, Shift)
End Sub

Private Sub fg_KeyDown(KeyCode As Integer, Shift As Integer)
   RaiseEvent KeyDown(KeyCode, Shift)
   If KeyCode = vbKeyF2 Then
      Call StartKeyEdit(0, True)
   End If
End Sub


Private Sub fg_OLECompleteDrag(Effect As Long)
   RaiseEvent OLECompleteDrag(Effect)
End Sub

Private Sub fg_OLEDragDrop(Data As MSHierarchicalFlexGridLib.DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
   RaiseEvent OLEDragDrop(Data, Effect, Button, Shift, X, Y)
End Sub

Private Sub fg_OLEDragOver(Data As MSHierarchicalFlexGridLib.DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer)
   RaiseEvent OLEDragOver(Data, Effect, Button, Shift, X, Y, State)
End Sub

Private Sub fg_OLEGiveFeedback(Effect As Long, DefaultCursors As Boolean)
   RaiseEvent OLEGiveFeedback(Effect, DefaultCursors)
End Sub

Private Sub fg_OLESetData(Data As MSHierarchicalFlexGridLib.DataObject, DataFormat As Integer)
   RaiseEvent OLESetData(Data, DataFormat)
End Sub

Private Sub fg_OLEStartDrag(Data As MSHierarchicalFlexGridLib.DataObject, AllowedEffects As Long)
   RaiseEvent OLEStartDrag(Data, AllowedEffects)
End Sub


'**************************************
' Properties Mapped to Flexgrid Control
'**************************************

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,AllowBigSelection
Public Property Get AllowBigSelection() As Boolean
Attribute AllowBigSelection.VB_Description = "Returns/sets whether clicking on a column or row header should cause the entire column or row to be selected."
Attribute AllowBigSelection.VB_ProcData.VB_Invoke_Property = "General"
    AllowBigSelection = fg.AllowBigSelection
End Property

Public Property Let AllowBigSelection(ByVal New_AllowBigSelection As Boolean)
    fg.AllowBigSelection() = New_AllowBigSelection
    PropertyChanged "AllowBigSelection"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,AllowUserResizing
Public Property Get AllowUserResizing() As AllowUserResizeSettings
Attribute AllowUserResizing.VB_Description = "Returns/sets whether the user should be allowed to resize rows and columns with the mouse."
Attribute AllowUserResizing.VB_ProcData.VB_Invoke_Property = ";Behavior"
    AllowUserResizing = fg.AllowUserResizing
End Property

Public Property Let AllowUserResizing(ByVal New_AllowUserResizing As AllowUserResizeSettings)
    fg.AllowUserResizing() = New_AllowUserResizing
    PropertyChanged "AllowUserResizing"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,Appearance
Public Property Get Appearance() As AppearanceSettings
Attribute Appearance.VB_Description = "Returns/sets whether a control should be painted with 3-D effects."
Attribute Appearance.VB_ProcData.VB_Invoke_Property = ";Appearance"
    Appearance = fg.Appearance
End Property

Public Property Let Appearance(ByVal New_Appearance As AppearanceSettings)
    fg.Appearance() = New_Appearance
    PropertyChanged "Appearance"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,BackColor
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "Returns/sets the background color of various elements of the FlexGrid."
Attribute BackColor.VB_ProcData.VB_Invoke_Property = ";Appearance"
    BackColor = fg.BackColor
End Property

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
    If txtEdit.BackColor = fg.BackColor Then
       txtEdit.BackColor = New_BackColor
    End If
    '    m_BackColorAlternate = New_BackColor
    '    PropertyChanged "BackColorAlterName"
    
    fg.BackColor = New_BackColor
    PropertyChanged "BackColor"
       
    If m_BackColorAlternate <> fg.BackColor And mEnableAlternateColor = True Then
       Call SetRowColors(New_BackColor)
    End If

End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,BackColorBkg
Public Property Get BackColorBkg() As OLE_COLOR
Attribute BackColorBkg.VB_Description = "Returns/sets the background color of various elements of the FlexGrid."
Attribute BackColorBkg.VB_ProcData.VB_Invoke_Property = ";Appearance"
    BackColorBkg = fg.BackColorBkg
End Property

Public Property Let BackColorBkg(ByVal New_BackColorBkg As OLE_COLOR)
    fg.BackColorBkg() = New_BackColorBkg
    PropertyChanged "BackColorBkg"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,BackColorFixed
Public Property Get BackColorFixed() As OLE_COLOR
Attribute BackColorFixed.VB_Description = "Returns/sets the background color of various elements of the FlexGrid."
Attribute BackColorFixed.VB_ProcData.VB_Invoke_Property = ";Appearance"
    BackColorFixed = fg.BackColorFixed
End Property

Public Property Let BackColorFixed(ByVal New_BackColorFixed As OLE_COLOR)
    fg.BackColorFixed() = New_BackColorFixed
    PropertyChanged "BackColorFixed"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,BackColorSel
Public Property Get BackColorSel() As OLE_COLOR
Attribute BackColorSel.VB_Description = "Returns/sets the background color of various elements of the FlexGrid."
Attribute BackColorSel.VB_ProcData.VB_Invoke_Property = ";Appearance"
    BackColorSel = fg.BackColorSel
End Property

Public Property Let BackColorSel(ByVal New_BackColorSel As OLE_COLOR)
    fg.BackColorSel() = New_BackColorSel
    PropertyChanged "BackColorSel"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,BorderStyle
Public Property Get BorderStyle() As BorderStyleSettings
Attribute BorderStyle.VB_Description = "Returns/sets the border style for an object."
Attribute BorderStyle.VB_ProcData.VB_Invoke_Property = ";Appearance"
    BorderStyle = fg.BorderStyle
End Property

Public Property Let BorderStyle(ByVal New_BorderStyle As BorderStyleSettings)
    fg.BorderStyle() = New_BorderStyle
    PropertyChanged "BorderStyle"
End Property


'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellAlignment() As AlignmentSettings
Attribute CellAlignment.VB_MemberFlags = "400"
    CellAlignment = fg.CellAlignment
End Property

Public Property Let CellAlignment(ByVal New_CellAlignment As AlignmentSettings)
    fg.CellAlignment = New_CellAlignment
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellBackColor() As OLE_COLOR
Attribute CellBackColor.VB_MemberFlags = "400"
    CellBackColor = fg.CellBackColor
End Property

Public Property Let CellBackColor(ByVal New_CellBackColor As OLE_COLOR)
    fg.CellBackColor = New_CellBackColor
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellFontBold() As Boolean
Attribute CellFontBold.VB_MemberFlags = "400"
    CellFontBold = fg.CellFontBold
End Property

Public Property Let CellFontBold(ByVal New_CellFontBold As Boolean)
    fg.CellFontBold = New_CellFontBold
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellFontItalic() As Boolean
Attribute CellFontItalic.VB_MemberFlags = "400"
    CellFontItalic = fg.CellFontItalic
End Property

Public Property Let CellFontItalic(ByVal New_CellFontItalic As Boolean)
    fg.CellFontItalic = New_CellFontItalic
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellFontName() As String
Attribute CellFontName.VB_MemberFlags = "400"
    CellFontName = fg.CellFontName
End Property

Public Property Let CellFontName(ByVal New_CellFontName As String)
    fg.CellFontName = New_CellFontName
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellFontSize() As Single
Attribute CellFontSize.VB_MemberFlags = "400"
    CellFontSize = fg.CellFontSize
End Property

Public Property Let CellFontSize(ByVal New_CellFontSize As Single)
    fg.CellFontSize = New_CellFontSize
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellFontStrikeThrough() As Boolean
Attribute CellFontStrikeThrough.VB_MemberFlags = "400"
    CellFontStrikeThrough = fg.CellFontStrikeThrough
End Property

Public Property Let CellFontStrikeThrough(ByVal New_CellFontStrikeThrough As Boolean)
    fg.CellFontStrikeThrough = New_CellFontStrikeThrough
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellFontUnderline() As Boolean
Attribute CellFontUnderline.VB_MemberFlags = "400"
    CellFontUnderline = fg.CellFontUnderline
End Property

Public Property Let CellFontUnderline(ByVal New_CellFontUnderline As Boolean)
    fg.CellFontUnderline = New_CellFontUnderline
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellFontWidth() As Single
Attribute CellFontWidth.VB_MemberFlags = "400"
    CellFontWidth = fg.CellFontWidth
End Property

Public Property Let CellFontWidth(ByVal New_CellFontWidth As Single)
    fg.CellFontWidth = New_CellFontWidth
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellForeColor() As OLE_COLOR
Attribute CellForeColor.VB_MemberFlags = "400"
    CellForeColor = fg.CellForeColor
End Property

Public Property Let CellForeColor(ByVal New_CellForeColor As OLE_COLOR)
    fg.CellForeColor = New_CellForeColor
End Property


'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,CellHeight
Public Property Get CellHeight() As Long
    CellHeight = fg.CellHeight
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,CellLeft
Public Property Get CellLeft() As Long
    CellLeft = fg.CellLeft
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,CellPicture
Public Property Get CellPicture() As Picture
Attribute CellPicture.VB_Description = "Returns/sets an image to be displayed in the current cell or in a range of cells."
Attribute CellPicture.VB_MemberFlags = "400"
    Set CellPicture = fg.CellPicture
End Property

Public Property Set CellPicture(ByVal New_CellPicture As Picture)
    Set fg.CellPicture = New_CellPicture
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellPictureAlignment() As AlignmentSettings
Attribute CellPictureAlignment.VB_MemberFlags = "400"
    CellPictureAlignment = fg.CellPictureAlignment
End Property

Public Property Let CellPictureAlignment(ByVal New_CellPictureAlignment As AlignmentSettings)
    fg.CellPictureAlignment = New_CellPictureAlignment
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CellTextStyle() As TextStyleSettings
Attribute CellTextStyle.VB_MemberFlags = "400"
    CellTextStyle = fg.CellTextStyle
End Property

Public Property Let CellTextStyle(ByVal New_CellTextStyle As TextStyleSettings)
    fg.CellTextStyle = New_CellTextStyle
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,CellTop
Public Property Get CellTop() As Long
    CellTop = fg.CellTop
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,CellWidth
Public Property Get CellWidth() As Long
    CellWidth = fg.CellWidth
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get Clip() As String
Attribute Clip.VB_MemberFlags = "400"
    Clip = fg.Clip
End Property

Public Property Let Clip(ByVal New_Clip As String)
    fg.Clip = New_Clip
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get Col() As Long
Attribute Col.VB_MemberFlags = "400"
    Col = fg.Col
End Property

Public Property Let Col(ByVal New_Col As Long)
    fg.Col = New_Col
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,ColAlignment
Public Property Get ColAlignment(ByVal index As Long) As Integer
Attribute ColAlignment.VB_Description = "Returns/sets the alignment of data in a column. Not available at design time (except indirectly through the FormatString property)."
    ColAlignment = fg.ColAlignment(index)
End Property

Public Property Let ColAlignment(ByVal index As Long, ByVal New_ColAlignment As Integer)
    fg.ColAlignment(index) = New_ColAlignment
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,ColData
Public Property Get ColData(ByVal index As Long) As Long
Attribute ColData.VB_Description = "Array of long integer values with one item for each row (RowData) and for each column (ColData) of the FlexGrid. Not available at design time."
    ColData = fg.ColData(index)
End Property

Public Property Let ColData(ByVal index As Long, ByVal New_ColData As Long)
    fg.ColData(index) = New_ColData
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,ColIsVisible
Public Property Get ColIsVisible(ByVal index As Long) As Boolean
    ColIsVisible = fg.ColIsVisible(index)
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,ColPos
Public Property Get ColPos(ByVal index As Long) As Long
    ColPos = fg.ColPos(index)
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,ColPosition
'Public Property Get ColPosition(ByVal index As Long) As Long
    'ColPosition = fg.ColPosition(index)
'End Property

Public Property Let ColPosition(ByVal index As Long, ByVal New_ColPosition As Long)
Attribute ColPosition.VB_Description = "Returns the distance in Twips between the upper-left corner of the control and the upper-left corner of a specified column."
    fg.ColPosition(index) = New_ColPosition
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,Cols
Public Property Get Cols() As Long
Attribute Cols.VB_Description = "Determines the total number of columns or rows in a FlexGrid."
Attribute Cols.VB_ProcData.VB_Invoke_Property = "General"
    Cols = fg.Cols
End Property

Public Property Let Cols(ByVal New_Cols As Long)
    On Error GoTo ErrHand
    fg.Cols() = New_Cols
    ReDim Preserve m_Cols(New_Cols + 1)
    PropertyChanged "Cols"
    Exit Property
ErrHand:
    Err.Raise Err.Number, Err.Source, Err.Description
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get ColSel() As Long
Attribute ColSel.VB_MemberFlags = "400"
    ColSel = fg.ColSel
End Property

Public Property Let ColSel(ByVal New_ColSel As Long)
    fg.ColSel = New_ColSel
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,ColWidth
Public Property Get ColWidth(ByVal index As Long) As Long
Attribute ColWidth.VB_Description = "Determines the width of the specified column in Twips. Not available at design time."
    ColWidth = fg.ColWidth(index)
End Property

Public Property Let ColWidth(ByVal index As Long, ByVal New_ColWidth As Long)
    fg.ColWidth(index) = New_ColWidth
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,Enabled
Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "Returns/sets a value that determines whether an object can respond to user-generated events."
    Enabled = fg.Enabled
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
    fg.Enabled() = New_Enabled
    PropertyChanged "Enabled"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,FillStyle
Public Property Get FillStyle() As FillStyleSettings
Attribute FillStyle.VB_Description = "Determines whether setting the Text property or one of the Cell formatting properties of a FlexGrid applies the change to all selected cells."
    FillStyle = fg.FillStyle
End Property

Public Property Let FillStyle(ByVal New_FillStyle As FillStyleSettings)
    fg.FillStyle() = New_FillStyle
    PropertyChanged "FillStyle"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,FixedAlignment
Public Property Get FixedAlignment(ByVal index As Long) As Integer
Attribute FixedAlignment.VB_Description = "Returns/sets the alignment of data in the fixed cells of a column."
    FixedAlignment = fg.FixedAlignment(index)
End Property

Public Property Let FixedAlignment(ByVal index As Long, ByVal New_FixedAlignment As Integer)
    fg.FixedAlignment(index) = New_FixedAlignment
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,FixedCols
Public Property Get FixedCols() As Long
Attribute FixedCols.VB_Description = "Returns/sets the total number of fixed (non-scrollable) columns or rows for a FlexGrid."
Attribute FixedCols.VB_ProcData.VB_Invoke_Property = "General"
    FixedCols = fg.FixedCols
End Property

Public Property Let FixedCols(ByVal New_FixedCols As Long)
    If New_FixedCols < fg.Cols Then
      fg.FixedCols() = New_FixedCols
    End If
    
    PropertyChanged "FixedCols"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,FixedRows
Public Property Get FixedRows() As Long
Attribute FixedRows.VB_Description = "Returns/sets the total number of fixed (non-scrollable) columns or rows for a FlexGrid."
Attribute FixedRows.VB_ProcData.VB_Invoke_Property = "General"
    FixedRows = fg.FixedRows
End Property

Public Property Let FixedRows(ByVal New_FixedRows As Long)
    
    If New_FixedRows < fg.Rows Then
      fg.FixedRows = New_FixedRows
    End If
    PropertyChanged "FixedRows"
    
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,FocusRect
Public Property Get FocusRect() As FocusRectSettings
Attribute FocusRect.VB_Description = "Determines whether the FlexGrid control should draw a focus rectangle around the current cell."
    FocusRect = fg.FocusRect
End Property

Public Property Let FocusRect(ByVal New_FocusRect As FocusRectSettings)
    fg.FocusRect() = New_FocusRect
    PropertyChanged "FocusRect"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,Font
Public Property Get Font() As Font
Attribute Font.VB_Description = "Returns/sets the default font or the font for individual cells."
Attribute Font.VB_UserMemId = -512
    Set Font = fg.Font
End Property

Public Property Set Font(ByVal New_Font As Font)
    Set fg.Font = New_Font
    Set txtEdit.Font = New_Font
    PropertyChanged "Font"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get FontBold() As Boolean
Attribute FontBold.VB_MemberFlags = "440"
    FontBold = fg.FontBold
End Property

Public Property Let FontBold(ByVal New_FontBold As Boolean)
    fg.FontBold = New_FontBold
    txtEdit.FontBold = New_FontBold
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get FontName() As String
Attribute FontName.VB_MemberFlags = "40"
    FontName = fg.FontName
End Property

Public Property Let FontName(ByVal New_FontName As String)
    fg.FontName = New_FontName
    txtEdit.FontName = New_FontName
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get FontSize() As Long
Attribute FontSize.VB_MemberFlags = "40"
    FontSize = fg.FontSize
End Property

Public Property Let FontSize(ByVal New_FontSize As Long)
    fg.FontSize = New_FontSize
    txtEdit.FontSize = New_FontSize
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get FontStrikethru() As Boolean
Attribute FontStrikethru.VB_MemberFlags = "40"
    FontStrikethru = fg.FontStrikethru
End Property

Public Property Let FontStrikethru(ByVal New_FontStrikethru As Boolean)
    fg.FontStrikethru = New_FontStrikethru
    txtEdit.FontStrikethru = New_FontStrikethru
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get FontUnderline() As Boolean
Attribute FontUnderline.VB_MemberFlags = "40"
    FontUnderline = fg.FontUnderline
End Property

Public Property Let FontUnderline(ByVal New_FontUnderline As Boolean)
    fg.FontUnderline = New_FontUnderline
    txtEdit.FontUnderline = New_FontUnderline
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,FontWidth
Public Property Get FontWidth() As Single
Attribute FontWidth.VB_Description = "Returns or sets the width, in points, of the font to be used for text displayed."
Attribute FontWidth.VB_MemberFlags = "400"
    FontWidth = fg.FontWidth
End Property

Public Property Let FontWidth(ByVal New_FontWidth As Single)
    fg.FontWidth() = New_FontWidth
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,ForeColor
Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_Description = "Determines the color used to draw text on each part of the FlexGrid."
Attribute ForeColor.VB_ProcData.VB_Invoke_Property = ";Appearance"
    ForeColor = fg.ForeColor
End Property

Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
    fg.ForeColor() = New_ForeColor
    PropertyChanged "ForeColor"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,
Public Property Get FontItalic() As Boolean
Attribute FontItalic.VB_Description = "Returns/sets italic font styles."
Attribute FontItalic.VB_MemberFlags = "40"
    FontItalic = fg.FontItalic
End Property

Public Property Let FontItalic(ByVal New_FontItalic As Boolean)
    fg.FontItalic = New_FontItalic
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,ForeColorFixed
Public Property Get ForeColorFixed() As OLE_COLOR
Attribute ForeColorFixed.VB_Description = "Determines the color used to draw text on each part of the FlexGrid."
Attribute ForeColorFixed.VB_ProcData.VB_Invoke_Property = ";Appearance"
    ForeColorFixed = fg.ForeColorFixed
End Property

Public Property Let ForeColorFixed(ByVal New_ForeColorFixed As OLE_COLOR)
    fg.ForeColorFixed() = New_ForeColorFixed
    PropertyChanged "ForeColorFixed"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,ForeColorSel
Public Property Get ForeColorSel() As OLE_COLOR
Attribute ForeColorSel.VB_Description = "Determines the color used to draw text on each part of the FlexGrid."
Attribute ForeColorSel.VB_ProcData.VB_Invoke_Property = ";Appearance"
    ForeColorSel = fg.ForeColorSel
End Property

Public Property Let ForeColorSel(ByVal New_ForeColorSel As OLE_COLOR)
    fg.ForeColorSel() = New_ForeColorSel
    PropertyChanged "ForeColorSel"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,FormatString
Public Property Get FormatString() As String
Attribute FormatString.VB_Description = "Allows you to set up a FlexGrid's column widths, alignments, and fixed row and column text at design time. See the help file for details."
Attribute FormatString.VB_ProcData.VB_Invoke_Property = "Style"
    FormatString = fg.FormatString
End Property

Public Property Let FormatString(ByVal New_FormatString As String)
    fg.FormatString() = New_FormatString
    PropertyChanged "FormatString"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,GridColor
Public Property Get GridColor() As OLE_COLOR
Attribute GridColor.VB_Description = "Returns/sets the color used to draw the lines between FlexGrid cells."
Attribute GridColor.VB_ProcData.VB_Invoke_Property = ";Appearance"
    GridColor = fg.GridColor
End Property

Public Property Let GridColor(ByVal New_GridColor As OLE_COLOR)
    fg.GridColor() = New_GridColor
    PropertyChanged "GridColor"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,GridColorFixed
Public Property Get GridColorFixed() As OLE_COLOR
Attribute GridColorFixed.VB_Description = "Returns/sets the color used to draw the lines between FlexGrid cells."
Attribute GridColorFixed.VB_ProcData.VB_Invoke_Property = ";Appearance"
    GridColorFixed = fg.GridColorFixed
End Property

Public Property Let GridColorFixed(ByVal New_GridColorFixed As OLE_COLOR)
    fg.GridColorFixed() = New_GridColorFixed
    PropertyChanged "GridColorFixed"
End Property

Public Property Let GridLines(ByVal New_GridLines As GridLineSettings)
  fg.GridLines = New_GridLines
  PropertyChanged "GridLines"
End Property

Public Property Get GridLines() As GridLineSettings
   GridLines = fg.GridLines
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,GridLineWidth
Public Property Get GridLineWidth() As Integer
Attribute GridLineWidth.VB_Description = "Returns/sets the width in Pixels of the gridlines for the control."
    GridLineWidth = fg.GridLineWidth
End Property

Public Property Let GridLineWidth(ByVal New_GridLineWidth As Integer)
    fg.GridLineWidth() = New_GridLineWidth
    PropertyChanged "GridLineWidth"
End Property

Public Property Get GridLinesFixed() As GridLineSettings
    GridLinesFixed = fg.GridLineWidth
End Property

Public Property Let GridLinesFixed(ByVal New_GridLinesFixed As GridLineSettings)
    fg.GridLinesFixed() = New_GridLinesFixed
    PropertyChanged "GridLinesFixed"
End Property


'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,HighLight
Public Property Get HighLight() As HighLightSettings
Attribute HighLight.VB_Description = "Returns/sets whether selected cells appear highlighted."
    HighLight = fg.HighLight
End Property

Public Property Let HighLight(ByVal New_HighLight As HighLightSettings)
    fg.HighLight() = New_HighLight
    PropertyChanged "HighLight"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get hwnd() As Long
    hwnd = fg.hwnd
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get LeftCol() As Long
Attribute LeftCol.VB_MemberFlags = "400"
    LeftCol = fg.LeftCol
End Property

Public Property Let LeftCol(ByVal New_LeftCol As Long)
    fg.LeftCol = New_LeftCol
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,MergeCells
Public Property Get MergeCells() As MergeCellsSettings
Attribute MergeCells.VB_Description = "Returns/sets whether cells with the same contents should be grouped in a single cell spanning multiple rows or columns."
    MergeCells = fg.MergeCells
End Property

Public Property Let MergeCells(ByVal New_MergeCells As MergeCellsSettings)
    fg.MergeCells() = New_MergeCells
    PropertyChanged "MergeCells"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,MergeCol
Public Property Get MergeCol(ByVal index As Long) As Boolean
Attribute MergeCol.VB_Description = "Returns/sets which rows (columns) should have their contents merged when the MergeCells property is set to a value other than 0 - Never."
Attribute MergeCol.VB_MemberFlags = "400"
    MergeCol = fg.MergeCol(index)
End Property

Public Property Let MergeCol(ByVal index As Long, ByVal New_MergeCol As Boolean)
    fg.MergeCol(index) = New_MergeCol
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,MergeRow
Public Property Get MergeRow(ByVal index As Long) As Boolean
Attribute MergeRow.VB_Description = "Returns/sets which rows (columns) should have their contents merged when the MergeCells property is set to a value other than 0 - Never."
Attribute MergeRow.VB_MemberFlags = "400"
    MergeRow = fg.MergeRow(index)
End Property

Public Property Let MergeRow(ByVal index As Long, ByVal New_MergeRow As Boolean)
    fg.MergeRow(index) = New_MergeRow
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,MouseCol
Public Property Get MouseCol() As Long
    MouseCol = fg.MouseCol
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,MouseIcon
Public Property Get MouseIcon() As Picture
Attribute MouseIcon.VB_Description = "Returns/sets a custom mouse icon."
    Set MouseIcon = fg.MouseIcon
End Property

Public Property Set MouseIcon(ByVal New_MouseIcon As Picture)
    Set fg.MouseIcon = New_MouseIcon
    PropertyChanged "MouseIcon"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,MousePointer
Public Property Get MousePointer() As MousePointerSettings
Attribute MousePointer.VB_Description = "Returns/sets the type of mouse pointer displayed when over part of an object."
    MousePointer = fg.MousePointer
End Property

Public Property Let MousePointer(ByVal New_MousePointer As MousePointerSettings)
    fg.MousePointer() = New_MousePointer
    PropertyChanged "MousePointer"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,MouseRow
Public Property Get MouseRow() As Long
    MouseRow = fg.MouseRow
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,OLEDropMode
Public Property Get OLEDropMode() As OLEDropConstants
Attribute OLEDropMode.VB_Description = "Returns/Sets whether this control can act as an OLE drop target."
    OLEDropMode = fg.OLEDropMode
End Property

Public Property Let OLEDropMode(ByVal New_OLEDropMode As OLEDropConstants)
    fg.OLEDropMode() = New_OLEDropMode
    PropertyChanged "OLEDropMode"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,Picture
Public Property Get Picture() As Picture
    Set Picture = fg.Picture
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,PictureType
Public Property Get PictureType() As PictureTypeSettings
Attribute PictureType.VB_Description = "Returns/sets the type of picture that should be generated by the Picture property."
    PictureType = fg.PictureType
End Property

Public Property Let PictureType(ByVal New_PictureType As PictureTypeSettings)
    fg.PictureType() = New_PictureType
    PropertyChanged "PictureType"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,Redraw
Public Property Get Redraw() As Boolean
Attribute Redraw.VB_Description = "Enables or disables redrawing of the FlexGrid control."
    Redraw = fg.Redraw
End Property

Public Property Let Redraw(ByVal New_Redraw As Boolean)
    fg.Redraw() = New_Redraw
    PropertyChanged "Redraw"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,RightToLeft
Public Property Get RightToLeft() As Boolean
Attribute RightToLeft.VB_Description = "Determines text display direction and control visual appearance on a bidirectional system."
    RightToLeft = fg.RightToLeft
End Property

Public Property Let RightToLeft(ByVal New_RightToLeft As Boolean)
    fg.RightToLeft() = New_RightToLeft
    PropertyChanged "RightToLeft"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get Row() As Long
Attribute Row.VB_MemberFlags = "400"
    Row = fg.Row
End Property

Public Property Let Row(ByVal New_Row As Long)
    fg.Row = New_Row
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,RowData
Public Property Get RowData(ByVal index As Long) As Long
Attribute RowData.VB_Description = "Array of long integer values with one item for each row (RowData) and for each column (ColData) of the FlexGrid. Not available at design time."
Attribute RowData.VB_MemberFlags = "400"
    RowData = fg.RowData(index)
End Property

Public Property Let RowData(ByVal index As Long, ByVal New_RowData As Long)
    fg.RowData(index) = New_RowData
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,RowHeight
Public Property Get RowHeight(ByVal index As Long) As Long
Attribute RowHeight.VB_Description = "Returns/sets the height of the specified row in Twips. Not available at design time."
Attribute RowHeight.VB_MemberFlags = "400"
    RowHeight = fg.RowHeight(index)
End Property

Public Property Let RowHeight(ByVal index As Long, ByVal New_RowHeight As Long)
    fg.RowHeight(index) = New_RowHeight
    mRowHeight = New_RowHeight
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,RowHeightMin
Public Property Get RowHeightMin() As Long
Attribute RowHeightMin.VB_Description = "Returns/sets a minimum row height for the entire control, in Twips."
Attribute RowHeightMin.VB_ProcData.VB_Invoke_Property = "Style"
    RowHeightMin = fg.RowHeightMin
End Property

Public Property Let RowHeightMin(ByVal New_RowHeightMin As Long)
    fg.RowHeightMin() = New_RowHeightMin
    PropertyChanged "RowHeightMin"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,RowIsVisible
Public Property Get RowIsVisible(ByVal index As Long) As Boolean
    RowIsVisible = fg.RowIsVisible(index)
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,RowPos
Public Property Get RowPos(ByVal index As Long) As Long
    RowPos = fg.RowPos(index)
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,RowPosition
'Public Property Get RowPosition(ByVal index As Long) As Long
'    RowPosition = fg.RowPosition(index)
'End Property

Public Property Let RowPosition(ByVal index As Long, ByVal New_RowPosition As Long)
Attribute RowPosition.VB_Description = "Returns the distance in Twips between the upper-left corner of the control and the upper-left corner of a specified row."
Attribute RowPosition.VB_MemberFlags = "400"
    fg.RowPosition(index) = New_RowPosition
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,Rows
Public Property Get Rows() As Long
Attribute Rows.VB_Description = "Determines the total number of columns or rows in a FlexGrid."
Attribute Rows.VB_ProcData.VB_Invoke_Property = "General"
    'Rows = fg.Rows
    Rows = mExtRows
End Property

Public Property Let Rows(ByVal New_Rows As Long)
   Dim mOldRows As Long
   'extRows
   
   'fg.Rows = New_Rows
   
   RowsModify MANUAL, , , New_Rows
   
  
   PropertyChanged "Rows"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get RowSel() As Long
Attribute RowSel.VB_MemberFlags = "400"
    RowSel = fg.RowSel
End Property

Public Property Let RowSel(ByVal New_RowSel As Long)
    fg.RowSel = New_RowSel
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,ScrollBars
Public Property Get ScrollBars() As ScrollBarsSettings
Attribute ScrollBars.VB_Description = "Returns/sets whether a FlexGrid has horizontal or vertical scroll bars."
    ScrollBars = fg.ScrollBars
End Property

Public Property Let ScrollBars(ByVal New_ScrollBars As ScrollBarsSettings)
    fg.ScrollBars() = New_ScrollBars
    PropertyChanged "ScrollBars"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,ScrollTrack
Public Property Get ScrollTrack() As Boolean
Attribute ScrollTrack.VB_Description = "Returns/sets whether FlexGrid should scroll its contents while the user moves the scroll box along the scroll bars."
    ScrollTrack = fg.ScrollTrack
End Property

Public Property Let ScrollTrack(ByVal New_ScrollTrack As Boolean)
    fg.ScrollTrack() = New_ScrollTrack
    PropertyChanged "ScrollTrack"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,SelectionMode
Public Property Get SelectionMode() As SelectionModeSettings
Attribute SelectionMode.VB_Description = "Returns/sets whether a FlexGrid should allow regular cell selection, selection by rows, or selection by columns."
    SelectionMode = fg.SelectionMode
End Property

Public Property Let SelectionMode(ByVal New_SelectionMode As SelectionModeSettings)
    fg.SelectionMode() = New_SelectionMode
    PropertyChanged "SelectionMode"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,Sort
Public Property Let Sort(ByVal New_Sort As SortSettings)
    fg.Sort() = New_Sort
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get Text() As String
Attribute Text.VB_MemberFlags = "400"
    Text = fg.Text
End Property

Public Property Let Text(ByVal New_Text As String)
    Call DisplayFormatedText(New_Text, fg.Row, fg.Col)
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,TextArray
Public Property Get TextArray(ByVal index As Long) As String
Attribute TextArray.VB_Description = "Returns/sets the text contents of an arbitrary cell (single subscript)."
Attribute TextArray.VB_MemberFlags = "400"
    TextArray = fg.TextArray(index)
End Property

Public Property Let TextArray(ByVal index As Long, ByVal New_TextArray As String)
    fg.TextArray(index) = New_TextArray
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,TextMatrix
Public Property Get TextMatrix(ByVal Row As Long, ByVal Col As Long) As String
Attribute TextMatrix.VB_Description = "Returns/sets the text contents of an arbitrary cell (row/col subscripts)."
Attribute TextMatrix.VB_MemberFlags = "400"
    TextMatrix = fg.TextMatrix(Row, Col)
End Property

Public Property Let TextMatrix(ByVal Row As Long, ByVal Col As Long, ByVal New_TextMatrix As String)
    Call DisplayFormatedText(New_TextMatrix, Row, Col)
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,TextStyle
Public Property Get TextStyle() As TextStyleSettings
Attribute TextStyle.VB_Description = "Returns/sets 3D effects for displaying text."
    TextStyle = fg.TextStyle
End Property

Public Property Let TextStyle(ByVal New_TextStyle As TextStyleSettings)
    fg.TextStyle() = New_TextStyle
    PropertyChanged "TextStyle"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,TextStyleFixed
Public Property Get TextStyleFixed() As TextStyleSettings
Attribute TextStyleFixed.VB_Description = "Returns/sets 3D effects for displaying text."
    TextStyleFixed = fg.TextStyleFixed
End Property

Public Property Let TextStyleFixed(ByVal New_TextStyleFixed As TextStyleSettings)
    fg.TextStyleFixed() = New_TextStyleFixed
    PropertyChanged "TextStyleFixed"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get TopRow() As Long
Attribute TopRow.VB_MemberFlags = "400"
    TopRow = fg.TopRow
End Property

Public Property Let TopRow(ByVal New_TopRow As Long)
    fg.TopRow = New_TopRow
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fg,fg,-1,WordWrap
Public Property Get WordWrap() As Boolean
Attribute WordWrap.VB_Description = "Returns/sets whether text within a cell should be allowed to wrap."
Attribute WordWrap.VB_ProcData.VB_Invoke_Property = "Style"
    WordWrap = fg.WordWrap
End Property

Public Property Let WordWrap(ByVal New_WordWrap As Boolean)
    fg.WordWrap() = New_WordWrap
    PropertyChanged "WordWrap"
End Property

Public Property Get UseCheckBox() As Boolean
    UseCheckBox = mUseCheckBok
End Property

Public Property Let UseCheckBox(ByVal New_UseCheckBox As Boolean)
    mUseCheckBok = New_UseCheckBox
    PropertyChanged "UseCheckBox"
End Property


Public Property Get EnableAlternateColor() As Boolean
    EnableAlternateColor = mEnableAlternateColor
End Property

Public Property Let EnableAlternateColor(ByVal New_EnableAlternateColor As Boolean)
   Dim lOldEnabled As Boolean
   
   lOldEnabled = mEnableAlternateColor
   mEnableAlternateColor = New_EnableAlternateColor
    
   If Ambient.UserMode Then
      If mEnableAlternateColor = True Then
         Call SetAlternateRowColors(ALTERNATIVE_COLOR)
      ElseIf lOldEnabled = True And mEnableAlternateColor = False Then
         Call SetAlternateRowColors(RESTORE_COLOR)
      End If
   End If
   PropertyChanged "EnableAlternateColor"
End Property


'*******************
' Internal Required Functions
'****************************
Private Function Max(Val1 As Double, Val2 As Double) As Double
    If Val1 > Val2 Then
       Max = Val1
    Else
       Max = Val2
    End If

End Function

Private Function Min(Val1 As Double, Val2 As Double) As Double
    If Val1 > Val2 Then
       Min = Val2
    Else
       Min = Val1
    End If
End Function

Private Function RowsModify(pOperation As ROWS_MOD, Optional pItem As String = "", Optional pIndex As Long = 0, Optional pNewRows As Long = 0)

   Select Case pOperation
      
      Case ADD_ROWS
         ' Se tienen una fila ?
         If mExtRows = ONE_ROW Then
            ' [1] Insertamos la fila nueva
            fg.RowHeight(ONE_ROW) = mRowHeight
            fg.AddItem pItem, fg.Rows
            ' [2] Eliminamos la Fila 1
            fg.RemoveItem ONE_ROW
          ElseIf mExtRows > ONE_ROW Then
            ' Se selecciono una ubicacion ?
            If pIndex <> 0 Then
               fg.AddItem pItem, pIndex
            ElseIf pIndex = 0 Then
               fg.AddItem pItem, fg.Rows
            End If
         
         End If
         
         mExtRows = fg.Rows
         
      Case OMIT_ROWS
         ' tenemos al menos una fila que eliminar ?
         If mExtRows > ONE_ROW And pIndex > 0 Then
            ' Eliminara la unica fila ?
            If pIndex = ONE_ROW And mExtRows = TWO_ROW Then
               ' ocultamos la Fila 1
               mRowHeight = fg.RowHeight(ONE_ROW)
               fg.RowHeight(ONE_ROW) = 0
               fg.HighLight = flexHighlightNever
               mExtRows = ONE_ROW
            ' El grid tiene mas de 2 registros para eliminar ?
            ElseIf mExtRows > TWO_ROW Then
               fg.RemoveItem (pIndex)
               mExtRows = fg.Rows
            End If
         
         End If
         
      Case MANUAL
         
         ' el resultado seria una Fila ?
         If pNewRows = ONE_ROW Then
            ' ocultamos la Fila 1
            fg.Rows = 2
            mRowHeight = fg.RowHeight(ONE_ROW)
            fg.RowHeight(ONE_ROW) = 0
            fg.HighLight = flexHighlightNever
            mExtRows = ONE_ROW
         
         ' Decrementaria ?
         ElseIf pNewRows < mExtRows And pNewRows > ONE_ROW Then
            fg.Rows = pNewRows
            mExtRows = fg.Rows
         
         ' Incrementaria ?
         ElseIf pNewRows > mExtRows And pNewRows > ONE_ROW Then
            fg.Rows = pNewRows
            mExtRows = fg.Rows
            fg.RowHeight(ONE_ROW) = mRowHeight
         End If
         
   End Select

End Function
